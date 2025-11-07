%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);          /* prototype for lexer */
int yyerror(const char *); /* prototype for error handler */
%}

%token A B

%%
S : AB X BBA Y   { printf("String is Accepted.\n"); }
  ;

X : /* empty */
  | X BBAA
  ;

Y : /* empty */
  | Y BA
  ;

AB  : A B ;
BBA : B B A ;
BBAA: B B A A ;
BA  : B A ;
%%

int main() {
  printf("Enter string: ");
  yyparse();
  return 0;
}

int yyerror(const char *s) {
  printf("Invalid string\n");
  return 0;
}
