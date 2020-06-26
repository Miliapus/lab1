%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int lineno = 1;
int cmnt_strt = 0; /*comment start*/
void check_inden();
%}
/*关键字*/
KEYWORD (if)|(else)|(switch)|(case)|(default)|(while)|(true)|(false)|(return)
/*基本类型*/
VARIABLE_TPYE (int)|(double)|(float)|(void)|(char)
/*运算符*/
OPT [+]|[-]|[*]|[/]
/*逻辑运算符*/
RELOP   [<]|[<][=]|[>]|[>][=]|[=][=]|[!][=]|[=]|[!]|[||]
/*各种括号*/
LP  \(
RP  \)
LB  \[
RB  \]
LC  \{
RC  \}
COM ,
END ;
/*数字*/
number [0-9]
/*字母*/
letter [a-zA-Z]
/*标识符，最多32个字符，下划线或者字符开头，可以由下划线或者数字或者字母组成*/
identifier (_|{letter})({letter}|{number}|_)*
ws  [ \r\f\v]+
hex [0-9a-fA-F]   
/*注释状态*/
%x CMNT
/*字符串状态*/
%x STRING
%%
\s			;
"//".*                          	printf("单行注释\n") ;          
"/*"			{cmnt_strt = yylineno; BEGIN CMNT;printf("开始多行注释\n");} /*记录注释开始的行号，进入注释状态*/
<CMNT>.		 ;
<CMNT>\n                           printf("注释换行\n") ;    
<CMNT>"*/"                        	{BEGIN INITIAL;printf("多行注释结束\n");} /*遇到第一个星号斜杠就回到初始状态*/
<CMNT><<EOF>>               	{printf("警告 注释未正确结束\n"); yyterminate();}
\"			{BEGIN STRING;printf("开始字符串:\n");}
<STRING>(\n)|(<<EOF>>)	{printf("警告 字符串未正确结束\n");BEGIN INITIAL;} 
<STRING>\\\"		printf("\\\"");/*防止被转义的"被<STRING>\"匹配*/
<STRING>\"		{BEGIN INITIAL;printf("\n结束字符串:\n");}
"int[]" 			printf("int数组%s\n", yytext);
"double[]" 		printf("double数组%s\n", yytext);
"char[]" 			printf("字符数组: %s\n", yytext);
{KEYWORD}   		printf("get keyword:%s\n",yytext);
{VARIABLE_TPYE} 		printf("get keyword:%s\n",yytext);
{OPT}			printf("get opt:%s\n",yytext);
{RELOP}			printf("get relop:%s\n",yytext);
{LP}			printf("get lp:%s\n",yytext);
{RP}    {
    printf("get rp:%s\n",yytext);
}
{LC}    {
    printf("get lc:%s\n",yytext);
}
{RC}    {
    printf("get rc:%s\n",yytext);
}
{LB}    {   
    printf("get lb:%s\n",yytext);
}
{RB}    {
    printf("get rb:%s\n",yytext);
}
{COM}   {
    printf("get com:%s\n",yytext);
}
{END}   {   
    printf("get end:%s\n",yytext);
}
[+\-]?[0][x|X]{hex}+ {printf("get hex number: %s\n", yytext);}
[+\-]?{number}+[lLuU]?             { printf("get  number: %s\n", yytext);}
[+\-]?{number}*\.({number})*([eE][+\-]?{number}*)?          printf("get float  number: %s\n", yytext);
{identifier}                            		printf("变量: %s\n", yytext);
{number}+({letter}|_)+	          {printf("Illegal identifier name: %s\n",yytext);}
[+\-]?{number}*\.{number}+([eE][+][-]{number})?          { printf("Illegal float num %s\n",yytext);}
.                                   {printf("Not match: %1s\n", yytext);}
%%
int main()
{
    yylex();
    return 0;
}