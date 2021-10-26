%{
void yyerror(char *s);
int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
int symbolsUsed[52];
int yylineno;
int getIsSymbolUsed(char symbol);
void setSymbolUsed(char symbol);
%}


%union {int num; char id; char* string;}
%start pascal_code
%token exit_command
%token <num> number
%token <string> string_regex
%token <id> assignment_operator 
%token <id> writeln
%token <id> begin_block
%token <id> end_block
%token <id> var_block_start
%token <id> integer_type
%token <id> type_assignment_operator;
%token <id> identifier
%token <id> IF THEN LE GE EQ NE OR AND ELSE CASE OF
%type <num> pascal_code var_block type_assignment_lines code_block lines exp 
%type <id> assignment
%type <id> print
%type <id> if_then_block if_then_else_block else_if_block
%type <id> switch_block case_body case_label case_else
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+''-'
%left '*''/'
%right UMINUS
%left '!'

%%

pascal_code : var_block code_block {;}

var_block : var_block_start type_assignment_lines {;}
 
type_assignment_lines : type_assignment_line {;}
                      | type_assignment_lines type_assignment_line {;}         
 
type_assignment_line : identifier type_assignment_operator integer_type ';' {setSymbolUsed($1);}

code_block : begin_block lines exit_command {;}
           | begin_block exit_command {;}

lines : line {;}
      | line lines {;} 

line    : assignment  {;}
        | print  {;}
        | if_then_else_block {;}
        | if_then_block {;}
        | switch_block {;}

if_then_else_block : if_then_block else_if_block {;} 
               
if_then_block : IF exp THEN line  {printf("mmm");} | IF exp THEN begin_block lines end_block {;}

else_if_block :   ELSE IF exp THEN line {;}
                | ELSE IF exp THEN begin_block lines end_block {;}
                | ELSE IF exp THEN line else_if_block {;}
                | ELSE IF exp THEN begin_block lines end_block else_if_block {;}
                | {;}
                | ELSE line {;}
                | ELSE begin_block lines end_block {;}

assignment : identifier assignment_operator exp ';' {if(!getIsSymbolUsed($1)){printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}}

print : writeln '(' string_regex ')' ';'  {;}
      | writeln '(' ')' ';'  {;}

switch_block : CASE '(' identifier ')' OF case_body end_block ';' {if(!getIsSymbolUsed($3)){printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}}

case_body   : case_label case_else {;}
            | case_label case_body {;}

case_label  : number ',' case_label {;}
            | number type_assignment_operator ';' {;}
            | number type_assignment_operator assignment {;}
            | number type_assignment_operator print {;}
            | number type_assignment_operator begin_block lines end_block ';' {;}

case_else   : {;}
            | ELSE line {;}
            | ELSE begin_block lines end_block {;}

exp : number {;}
    | identifier {if(!getIsSymbolUsed($1)){printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}}
    | '(' exp ')' {;}
    | exp '/' exp {;}
    | exp '*' exp {;}
    | exp '+' exp {;}
    | exp '-' exp {;}
    | exp '>' exp {;}
    | exp '<' exp {;}
    | exp LE exp {;}
    | exp GE exp {;}
    | exp EQ exp {;}
    | exp NE exp {;}
    | exp AND exp {;}
    | exp OR exp {;}
    | exp '!' exp {;}

%%


// a-z , A-z
int getId(char symbol)
{
    if(islower(symbol))
    {
        return symbol - 'a';
    }
    else{
        return symbol - 'A' + 26;
    }
}

int getIsSymbolUsed(char symbol)
{
    return symbolsUsed[getId(symbol)];
}

void setSymbolUsed(char symbol)
{
    symbolsUsed[getId(symbol)] = 1;
}


int main(void)
{
    int i;
    yylineno = 0;
    for(i = 0;i<52;i++)
    {
        symbolsUsed[i] = 0;
    }
    printf("%s\n",yyparse()?"":"Program compiled successfully");
}

void yyerror(char *s){fprintf(stderr,"%s %d\n",s, ++yylineno);}