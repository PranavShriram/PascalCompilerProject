%{
    #include<stdio.h>
    #include "y.tab.h"
    int yyerror(char *);
%}

%%
"end."    {return exit_command;}
[a-zA-z]  {yylval.id = yytext[0]; return identifier;}
[0-9]+    {yylval.num = atoi(yytext); return number;}
[ \t\n]   {;}
":"       {return type_assignment_operator;}
":="      {return assignment_operator;}
[+\-*/;<>()]     {return yytext[0];}
"begin"   {return begin_block;}
"end"     {return end_block;}
"var"     {return var_block_start;}
"integer" {return integer_type;}
"if"    return IF;
"then"    return THEN;
"else"    return ELSE;
"<="    return LE;
">="    return GE;
"=="    return EQ;
"!="    return NE;
"||"    return OR;
"&&"    return AND;
.         {ECHO; yyerror("unexpected character in line number");}
%%


int yywrap(void)
{
    return 1;
}
