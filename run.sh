#!/bin/bash  

yacc -d $2
lex $1 
gcc lex.yy.c y.tab.c -o fun
./fun < a.in