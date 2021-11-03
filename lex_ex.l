%{
    #include<stdio.h>
    #include "nodes.h"
    #include "y.tab.h"
    int yyerror(char *);
    int yylineno;
%}

%%
"end."    {return exit_command;}
[ \t]     {;}
[\n]      {yylineno++;}
":"       {return type_assignment_operator;}
":="      {return assignment_operator;}
","       {return seperator;}
[+\-*/;<>()]     {return yytext[0];}
"writeln" {return writeln;}
"begin"   {return begin_block;}
"end"     {return end_block;}
"var"     {return var_block_start;}
"integer" {return integer_type;}
"if"    return IF;
"then"    return THEN;
"else"    return ELSE;
"case"    return CASE;
"of"      return OF;
"<="    return LE;
">="    return GE;
"=="    return EQ;
"!="    return NE;
"||"    return OR;
"&&"    return AND;
[_a-zA-Z][_a-zA-Z0-9]* {yylval.id = strdup(yytext); return identifier;}
0 {
 return number;
 }
[1-9][0-9]* {
 yylval.num = atoi(strdup(yytext));
 return number;
 } 
['^][ \t\n_a-zA-Z0-9+=-]*[$']      {yylval.string = yytext; return string_regex;}
.         {ECHO; yyerror("unexpected character");}
%%


int yywrap(void)
{
    return 1;
}
