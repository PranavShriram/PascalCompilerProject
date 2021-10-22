#include <stdio.h>
#include "definitions.h"

extern int yylex();
extern int yylineno;
extern char* yytext;

int main(void) {

    int tokens[5000];
    int idx = 0;

    int token = yylex();
    tokens[idx] = token;
    idx++;

    if(token == _VAR) {

        token = yylex();
        tokens[idx] = token;
        idx++;

        while(token != _BEGIN) {

            if(token != _IDENTIFIER_REGEX) {
                printf("Syntax error in line %d, Expected an identifier but found %s\n", yylineno, yytext);
				return 1;
            }

            token = yylex();
            tokens[idx] = token;
            idx++;

            if(token != _COLON) {
                printf("Syntax error in line %d, Expected a ':' but found %s\n", yylineno, yytext);
                return 1;
            }

            token = yylex();
            tokens[idx] = token;
            idx++;

            if(token != _INTEGER) {
                printf("Syntax error in line %d, Expected a keyword but found %s\n", yylineno, yytext);
                return 1;
            }

            token = yylex();
            tokens[idx] = token;
            idx++;

            if(token != _SEMICOLON) {
                printf("Syntax error in line %d, Expected ';' but found %s\n", yylineno, yytext);
                return 1;
            }

            token = yylex();
            tokens[idx] = token;
            idx++;
        }

        printf("variables initialization is successfully parsed\n");

        while(token) {
            token = yylex();
            tokens[idx] = token;
            idx++;
        }

    }
    else {

        while(token) {
            token = yylex();
            tokens[idx] = token;
            idx++;
        }
    }

    printf("The tokens are: \n");

    for(int i = 0; i < idx; i++) {
        printf("%d\n",tokens[i]);
    }

}