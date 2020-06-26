%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int lineno = 1;
int cmnt_strt = 0; /*comment start*/
void print_float();
void check_inden();
void string_check();
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
%x CMNT
%%

{KEYWORD}   {
    printf("get keyword:%s\n",yytext);
}

{VARIABLE_TPYE}   {
    printf("get keyword:%s\n",yytext);
}

{OPT}   {
    printf("get opt:%s\n",yytext);
}
{RELOP} {
    printf("get relop:%s\n",yytext);
}
{LP}    {
    printf("get lp:%s\n",yytext);
}
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

"int[]" {printf("int数组%s\n", yytext);}
"double[]" {printf("double数组%s\n", yytext);}
"char[]" {printf("字符数组: %s\n", yytext);}

[+\-]?[0][x|X]{hex}+ {printf("get hex number: %s\n", yytext);}
[+\-]?{number}+[lLuU]?             { printf("get  number: %s\n", yytext);}
[+\-]?{number}*\.({number})*([eE][+\-]?{number}*)?          { print_float();}
{ws} ;

{identifier}                            {check_inden();}

{number}+({letter}|_)+	          {printf("Illegal identifier name: %s\n",yytext);}

[+\-]?{number}*\.{number}+([eE][+][-]{number})?          { printf("Illegal float num %s\n",yytext);}

\"[^\"\n]*\"                      {string_check();}

\"[^\"\n]*$                     {printf("Unterminated string: %s\n",yytext);}
"//".*                           ;                             
"/*"                              {cmnt_strt = yylineno; BEGIN CMNT;} /*记录注释开始的行号，进入注释状态*/
<CMNT>.|{ws}                      ;
<CMNT>\n                          {yylineno++;}
<CMNT>"*/"                        {BEGIN INITIAL;} /*遇到第一个星号斜杠就回到初始状态*/
<CMNT><<EOF>>                     {printf("Line %3d: Unterminated comment\n", cmnt_strt); yyterminate();}

.                                   {printf("Not match: %1s\n", yytext);}
%%

void check_inden(){
    if(strlen(yytext) > 31){
        printf("Error : the identifier is too long !\n");
        return;
    }

    printf("get identifier: %s\n", yytext);
    return;
}

void print_float(){
    printf("get float  number: %s\n", yytext);
}

void string_check(){
    if(yytext[yyleng-2]=='\\') /* 检查这个引号是不是转义字符 */
    {
         yyless(yyleng-1);       /* 如果是转义字符需要退回进行重新匹配 */
        //yymore();       /*下一次被匹配的字符串被添加在当前识别出的字符串后面*/
    }else{
                printf("get string:  %s\n", yytext);
                return ;
    }
}

int main()
{
    yylex();
    return 0;
}