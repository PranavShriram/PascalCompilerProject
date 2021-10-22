%{
#include "definitions.h"
%}
%option nounput yylineno

%%

"var"               return _VAR;
"begin"             return _BEGIN;
"end"               return _END;
"if"                return _IF;
"then"              return _THEN;
"else"              return _ELSE;
"writeln"           return _WRITELN;

"."                 return _DOT;
":="                return _COLON_EQUAL;
":"                 return _COLON;
";"                 return _SEMICOLON;
"("                 return _OPEN_PARANTHESIS;
")"                 return _CLOSED_PARANTHESIS;
","                 return _COMMA;


"integer"           return _INTEGER;

[_a-zA-Z][_a-zA-Z0-9]*                      return _IDENTIFIER_REGEX;
[1-9][0-9]*				                    return _INTEGER_REGEX;
['^][ \t\n_a-zA-Z0-9+=-]*[$']               return _STRING_REGEX;
[ \t\n]					                    ;


"="                 return _EQUAL;
"<"                 return _LESSTHAN;
">"                 return _GREATERTHAN;
"<="                return _LESSTHAN_EQUAL;
">="                return _GREATERTHAN_EQUAL;
"+"                 return _PLUS;
"-"                 return _MINUS;
"*"                 return _MULTIPLY;
"/"                 return _DIVIDE;

.				    printf("unexpected character\n");



%%

int yywrap(void)
{
	return 1;
}