#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int symbolTableSize = 0;
struct symbolTable
{
          char *label;
          struct symbolTable *next;
};
struct symbolTable *first,*last;

int search(char *str)
{
          int i,flag=0;
         
          struct symbolTable *p;
          p = first;
          for(i = 0;i < symbolTableSize;i++)
          {
                   if(strcmp(p->label,str)==0)
                   {
                             flag=1;
                   }
                   p=p->next;
          }
          return flag;
}

void insert(char *str)
{
          int flag;
   
          flag = search(str);
          printf("Adding %s to symbol table\n", str);

          if(flag)
          {
                printf("The label already exists. Duplicate cant be inserted\n");
                exit(EXIT_FAILURE);
          }
          else
          {
                   struct symbolTable *p;
                   p = malloc(sizeof(struct symbolTable));
                   p->label = str;
                   p->next = NULL;
                   if(symbolTableSize==0)
                   {
                             first=p;
                             last=p;
                   }
                   else
                   {
                             last->next=p;
                             last=p;
                   }
                   symbolTableSize++;
          }

}