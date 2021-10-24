%{
void yyerror(char *s);
#include <stdio.h>
#include <stdlib.h>
int symbolsUsed[52];
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
%type <num> pascal_code var_block type_assignment_lines code_block lines exp term
%type <id> assignment

%%

pascal_code : var_block code_block {;}

var_block : var_block_start type_assignment_lines {;}
 
type_assignment_lines : type_assignment_line {;}
                      | type_assignment_lines type_assignment_line {;}         
 
type_assignment_line : identifier type_assignment_operator integer_type ';' {setSymbolUsed($1);}

code_block : begin_block lines exit_command {;}
           | begin_block exit_command {;}

lines : assignment {;}
      | lines assignment {;}  

assignment : identifier assignment_operator exp ';' {if(!getIsSymbolUsed($1)){printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}}

exp : term  {;}
    | exp '+' term {;}
    | exp '-' term {;}

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
    for(i = 0;i<52;i++)
    {
        symbolsUsed[i] = 0;
    }
    printf("%s\n",yyparse()?"":"Program compiled successfully");
}

void yyerror(char *s){fprintf(stderr,"%s\n",s);}