%{
void yyerror(char *s);
#include <stdio.h>
#include <stdlib.h>
int symbolsUsed[52];
int yylineno;
int getIsSymbolUsed(char symbol);
void setSymbolUsed(char symbol);
%}


%union {int num; char id;}
%start pascal_code
%token exit_command
%token <num> number
%token <id> assignment_operator 
%token <id> begin_block
%token <id> end_block
%token <id> var_block_start
%token <id> integer_type
%token <id> type_assignment_operator;
%token <id> identifier
%token <id> IF THEN LE GE EQ NE OR AND ELSE
%type <num> pascal_code var_block type_assignment_lines code_block lines exp term
%type <id> assignment
%type <id> if_then_block if_then_else_block else_if_block
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

line  : assignment  {;}
        | if_then_else_block {;}
        | if_then_block {;}
        | if_then_block lines {;}
        | if_then_else_block lines {;}    

if_then_else_block : if_then_block else_if_block ELSE line{printf("hello");} 
                    | if_then_block else_if_block ELSE begin_block lines end_block{;} 
                    | if_then_block ELSE begin_block lines end_block{;} 
                    | if_then_block ELSE line{;} 

if_then_block : IF exp THEN line  {;} | IF exp THEN begin_block lines end_block {;}

else_if_block :   ELSE IF exp THEN line {printf("here");}
                | ELSE IF exp THEN begin_block lines end_block {printf("here2");}
                | ELSE IF exp THEN line else_if_block {printf("here3");}
                | ELSE IF exp THEN begin_block lines end_block else_if_block {printf("here4");}

assignment : identifier assignment_operator exp ';' {if(!getIsSymbolUsed($1)){printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}}

exp : term  {;}
    | '(' exp ')' {;}
    | exp '/' term {;}
    | exp '*' term {;}
    | exp '+' term {;}
    | exp '-' term {;}
    | exp '>' term {;}
    | exp '<' term {;}
    | exp LE term {;}
    | exp GE term {;}
    | exp EQ term {;}
    | exp NE term {;}
    | exp AND term {;}
    | exp OR term {;}
    | exp '!' term {;}

term : number {setSymbolUsed($1);}
     | identifier {if(!getIsSymbolUsed($1)){printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}}
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