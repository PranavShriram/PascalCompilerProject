%{
void yyerror(char *s);
int yylex();
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdarg.h>
#include "nodes.h"
int symbolsUsed[52];
int yylineno;
int getIsSymbolUsed(char symbol);
void setSymbolUsed(char symbol);

nodeType *opr(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
nodeType *assignDataType(int i);
nodeType *assignString(char *str);
void freeNode(nodeType *p); 
enum operatorVals{ELSE_IF, SEMICOLON};
%}


%union {int num; char id; char* string; nodeType *nPtr; /* node pointer */ }
%start pascal_code
%token exit_command
%token <num> number
%token <string> string_regex
%token <id> assignment_operator 
%token <id> seperator
%token <id> writeln
%token <id> begin_block
%token <id> end_block
%token <id> var_block_start
%token <id> integer_type
%token <id> type_assignment_operator;
%token <id> identifier
%token <id> IF THEN LE GE EQ NE OR AND ELSE CASE OF
%type <nPtr> data_type   
%type <nPtr> pascal_code var_block type_assignment_lines code_block lines exp  line type_assignment_line
%type <nPtr> assignment
%type <nPtr> print
%type <nPtr> if_then_block if_then_else_block else_if_block
%type <nPtr> switch_block case_body case_label case_else
%type <nPtr> string_val
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE
%left '+''-'
%left '*''/'
%right UMINUS
%left '!'

%%

pascal_code : var_block code_block {$$ = opr(begin_block, 2, $1, $2);}

var_block : var_block_start type_assignment_lines {$$ = $2;}
 
type_assignment_lines : type_assignment_line {$$ = $1;}
                      | type_assignment_lines type_assignment_line {enum operatorVals op = SEMICOLON;$$ = opr(op, 2, $1, $2);}         
 
type_assignment_line : identifier type_assignment_operator data_type ';' {$$ = opr(type_assignment_operator, 2, $1, $3);setSymbolUsed($1);}

data_type : integer_type {$$ = assignDataType(integer_type);}

code_block : begin_block lines exit_command {;}
           | begin_block exit_command {;}

lines : line {$$ = $1;}
      | lines line  {enum operatorVals op = SEMICOLON;$$ = opr(op, 2, $1, $2);} 

line    : assignment  {$$ = $1;}
        | print  {$$ = $1;}
        | if_then_else_block {$$ = $1;}
        | if_then_block {$$ = $1;}
        | switch_block {$$ = $1;}

if_then_else_block : if_then_block else_if_block {enum operatorVals op = SEMICOLON;$$ = opr(op, 2, $1, $2);} 
               
if_then_block : IF exp THEN line  {$$ = opr(IF, 2, $2, $4);} | IF exp THEN begin_block lines end_block {$$ = opr(IF, 2, $2, $4);} 

else_if_block :   ELSE IF exp THEN line {enum operatorVals op = ELSE_IF;$$ = opr(op, 2, $3, $5);} 
                | ELSE IF exp THEN begin_block lines end_block {enum operatorVals op = ELSE_IF;$$ = opr(op, 2, $3, $6);} 
                | ELSE IF exp THEN line else_if_block {enum operatorVals op = ELSE_IF;$$ = opr(op, 3, $3, $5, $6);}
                | ELSE IF exp THEN begin_block lines end_block else_if_block {enum operatorVals op = ELSE_IF;$$ = opr(op, 3, $3, $6, $8);}
                | {;}
                | ELSE line {$$ = opr(ELSE, 1, $2);}
                | ELSE begin_block lines end_block {$$ = opr(ELSE, 1, $3);}

assignment : identifier assignment_operator exp ';' {$$ = opr(assignment_operator, 2, $1, $3);if(!getIsSymbolUsed($1)){printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}}

print : writeln '(' string_val ')' ';'  {$$ = opr(writeln, 1, $3);}

string_val : string_regex {$$ = assignString($1);}

switch_block : CASE '(' identifier ')' OF case_body end_block ';' {if(!getIsSymbolUsed($3)){$$ = opr(CASE, 2, $3, $6);printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}}

case_body   : case_label case_else {enum operatorVals op = SEMICOLON;$$ = opr(op, 2, $1, $2);}
            | case_label case_body {enum operatorVals op = SEMICOLON;$$ = opr(op, 2, $1, $2);}

case_label  : number seperator case_label {$$ = opr(seperator, 2, $1, $3);}
            | number type_assignment_operator ';' {$$ = opr(type_assignment_operator, 2, $1, NULL);}
            | number type_assignment_operator assignment {$$ = opr(type_assignment_operator, 2, $1, $3);}
            | number type_assignment_operator print {$$ = opr(type_assignment_operator, 2, $1, $3);}
            | number type_assignment_operator begin_block lines end_block ';' {$$ = opr(type_assignment_operator, 2, $1, $4);}

case_else   : {;}
            | ELSE line {;}
            | ELSE begin_block lines end_block {;}

exp : number {$$ = con($1);}
    | identifier {if(!getIsSymbolUsed($1)){printf("%c not declared\nsyntax error\n",$1);exit(EXIT_FAILURE);}$$ = id($1);}
    | '(' exp ')' {$$ = $2;}
    | exp '/' exp {$$ = opr('/', 2, $1, $3);}
    | exp '*' exp {$$ = opr('*', 2, $1, $3);}
    | exp '+' exp {$$ = opr('+', 2, $1, $3);}
    | exp '-' exp {$$ = opr('-', 2, $1, $3);}
    | exp '>' exp {$$ = opr('>', 2, $1, $3);}
    | exp '<' exp {$$ = opr('<', 2, $1, $3);}
    | exp LE exp {$$ = opr(LE, 2, $1, $3);}
    | exp GE exp {$$ = opr(GE, 2, $1, $3);}
    | exp EQ exp {$$ = opr(EQ, 2, $1, $3);}
    | exp NE exp {$$ = opr(NE, 2, $1, $3);}
    | exp AND exp {$$ = opr(AND, 2, $1, $3);}
    | exp OR exp {$$ = opr(OR, 2, $1, $3);}
    | exp '!' exp {$$ = opr('!', 2, $1, $3);}

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

//Function for assigning value to constants and create pointer
nodeType *con(int value) {
    nodeType *p;
    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
    yyerror("out of memory");
    /* copy information */
    p->type = typeCon;
    p->con.value = value;
    return p;
}

//Function for assigning value to identifiers and create pointer
nodeType *id(int i) {
    nodeType *p;
    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
    yyerror("out of memory");
    /* copy information */
    p->type = typeId;
    p->id.i = i;
    return p;
}

//Function for assigning data type and create pointer
nodeType *assignDataType(int i) {
    nodeType *p;
    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
    yyerror("out of memory");
    /* copy information */
    p->type = typeData;
    p->dType.dataType = i;
    return p;
}

//Function for assigning value to string and create pointer
nodeType *assignString(char *str) {
    nodeType *p;
    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
    yyerror("out of memory");
    /* copy information */
    p->type = typeData;
    p->str.stringVal = str;
    return p;
}

//Function for creating operation and create pointer
nodeType *opr(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;
    /* allocate node */
    if ((p = malloc(sizeof(nodeType))) == NULL)
    yyerror("out of memory");
    if ((p->opr.op = malloc(nops * sizeof(nodeType))) == NULL)
    yyerror("out of memory");
    /* copy information */
    p->type = typeOpr;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
    p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void yyerror(char *s){fprintf(stderr,"%s %d\n",s, ++yylineno);}

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

