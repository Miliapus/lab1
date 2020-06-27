%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
%}
/*关键字*/
KEYWORD 		if|else|switch|case|default|while|return
/*布尔值*/
BOOL			TRUE|FALSE|True|False|true|false
/*基本类型*/
VARIABLE_TPYE 		int|double|float|void|char|bool
/*算数运算符*/
OPT 			"+"|"-"|"*"|"/"
/*比较运算符*/
CMOPT   			<|<=|>|>=|==|!=
/*赋值运算符*/
EQOPT 			{OPT}?=
/*布尔运算符*/
BOLOPT  			!|&&|\|\|
/*位运算符*/
BITOPT  			&|\||\^
/*字母*/
letter 			[a-zA-Z]
/*变量名或自定义类型，下划线或者字母开头，可以由下划线或者数字或者字母组成*/
identifier 			(_|{letter})(\w)*
hex 			[0-9a-fA-F]   
/*注释状态*/
%x 			CMNT
/*字符串状态*/
%x 			STRING
%%
\s			;
"//".*                          	printf("单行注释\n");          
"/*"			{BEGIN CMNT;printf("开始多行注释\n");} /*记录注释开始的行号，进入注释状态*/
<CMNT>.			 ;
<CMNT>\n                          	 printf("注释换行\n") ;    
<CMNT>"*/"                        	{BEGIN INITIAL;printf("多行注释结束\n");} /*遇到第一个星号斜杠就回到初始状态*/
<CMNT><<EOF>>               	{printf("警告 注释未正确结束\n"); yyterminate();}
\"			{BEGIN STRING;printf("开始字符串:\n");}
<STRING>\n		{printf("\n警告 字符串未正确结束\n");BEGIN INITIAL;} 
<STRING><<EOF>>	printf("警告 字符串未正确结束\n");
<STRING>\\\"		printf("\\\"");/*防止被转义的"被<STRING>\"匹配*/
<STRING>\"		{BEGIN INITIAL;printf("\n结束字符串:\n");}
{VARIABLE_TPYE}\[\]		printf("数组%s\n", yytext);
{KEYWORD}   		printf("关键字:%s\n",yytext);
{VARIABLE_TPYE} 		printf("基本类型:%s\n",yytext);
{OPT}			printf("算数运算符:%s\n",yytext);
{CMOPT}			printf("比较运算符:%s\n",yytext);
{EQOPT}			printf("赋值运算符:%s\n",yytext);
{BOLOPT}			printf("布尔运算符:%s\n",yytext);
{BITOPT}			printf("位运算符:%s\n",yytext);
{BOOL}			printf("布尔值:%s\n",yytext);
\(			printf("左括号 ( \n");
\)			printf("右括号 ) \n");
\[			printf("左中括号 [ \n");
\]			printf("右中括号 ] \n");
\{			printf("左大括号 { \n");
\}			printf("右大括号 } \n");
,   			printf("逗号 , \n");
;   			printf("分号 ; \n");
[+-]?[0][x|X]{hex}+ 		printf("十六进制数: %s\n", yytext);
[+-]?(\d)+[lLuU]?            	printf("整数: %s\n", yytext);
[+-]?(\d)*\.(\d)*([eE][+-]?(\d)*)?	printf("浮点数: %s\n", yytext);
{identifier}                            	printf("变量: %s\n", yytext);
(\d)+(\w)+		printf("非法变量名: %s\n",yytext);
[+-]?(\d)*\.(\d)+([eE][+][-](\d))?	printf("非法浮点数: %s\n",yytext);
.                                   	printf("不能匹配: %1s\n", yytext);
%%
int main()
{
    yylex();
    return 0;
}
int yywrap()
{
    return 1;
}