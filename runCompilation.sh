#!/bin/bash  
yacc -d yacc.y
lex lex_ex.l
gcc lex.yy.c y.tab.c -o fun
./fun < correctInput.in
./fun < wrongInput.in