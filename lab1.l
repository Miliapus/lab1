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

KEYWORD (else)|(if)|(return)|(while)|(true)|(false)
VARIABLE_TPYE (int)|(double)|(float)|(void)|(char)

OPT [+]|[-]|[*]|[/]
RELOP   [<]|[<][=]|[>]|[>][=]|[=][=]|[!][=]|[=]|[!]|[||]
LP  \(
RP  \)
LB  \[
RB  \]
LC  \{
RC  \}
COM ,
END ;
letter [a-zA-Z]
/*标识符，最多32个字符，下划线或者字符开头，可以由下划线或者数字或者字母组成*/
identifier (_|{letter})({letter}|{digit}|_)*
digit [0-9]

ws  [ \t\r\f\v]+
hex [0-9a-fA-F]   
%x CMNT
%%

{KEYWORD}   {
    printf("\tget keyword:%10s\n",yytext);
}

{VARIABLE_TPYE}   {
    printf("\tget keyword:%10s\n",yytext);
}

{OPT}   {
    printf("\tget opt:%10s\n",yytext);
}
{RELOP} {
    printf("\tget relop:%10s\n",yytext);
}
{LP}    {
    printf("\tget lp:%10s\n",yytext);
}
{RP}    {
    printf("\tget rp:%10s\n",yytext);
}
{LC}    {
    printf("\tget lc:%10s\n",yytext);
}
{RC}    {
    printf("\tget rc:%10s\n",yytext);
}
{LB}    {   
    printf("\tget lb:%10s\n",yytext);
}
{RB}    {
    printf("\tget rb:%10s\n",yytext);
}
{COM}   {
    printf("\tget com:%10s\n",yytext);
}
{END}   {   
    printf("\tget end:%10s\n",yytext);
}

"int[]" {printf("\tget array: %10s\n", yytext);}
"double[]" {printf("\tget array: %10s\n", yytext);}
"char[]" {printf("\tget array: %10s\n", yytext);}

[+\-]?[0][x|X]{hex}+ {printf("\tget hex number: %10s\n", yytext);}
[+\-]?{digit}+[lLuU]?             { printf("\tget  number: %10s\n", yytext);}
[+\-]?{digit}*\.({digit})*([eE][+\-]?{digit}*)?          { print_float();}
{ws} ;

{identifier}                            {check_inden();}

{digit}+({letter}|_)+	          {printf("\tIllegal identifier name: %s\n",yytext);}

[+\-]?{digit}*\.{digit}+([eE][+][-]{digit})?          { printf("\tIllegal float num %s\n",yytext);}

\"[^\"\n]*\"                      {string_check();}

\"[^\"\n]*$                     {printf("\tUnterminated string: %s\n",yytext);}
"//".*                           ;                             
"/*"                              {cmnt_strt = yylineno; BEGIN CMNT;} /*记录注释开始的行号，进入注释状态*/
<CMNT>.|{ws}                      ;
<CMNT>\n                          {yylineno++;}
<CMNT>"*/"                        {BEGIN INITIAL;} /*遇到第一个星号斜杠就回到初始状态*/
<CMNT><<EOF>>                     {printf("Line %3d: Unterminated comment\n", cmnt_strt); yyterminate();}

.                                   {printf("\tNot match: %1s\n", yytext);}
%%

void check_inden(){
    if(strlen(yytext) > 31){
        printf("Error : the identifier is too long !\n");
        return;
    }

    printf("\tget identifier: %10s\n", yytext);
    return;
}

void print_float(){

    printf("\tget float  number: %10s\n", yytext);
}

void string_check(){
    if(yytext[yyleng-2]=='\\') /* 检查这个引号是不是转义字符 */
    {
         yyless(yyleng-1);       /* 如果是转义字符需要退回进行重新匹配 */
        //yymore();       /*下一次被匹配的字符串被添加在当前识别出的字符串后面*/
    }else{
                printf("\tget string: \t %10s\n", yytext);
                return ;
    }
}

int main()
{
    yylex();
    return 0;
}