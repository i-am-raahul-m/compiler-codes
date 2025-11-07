/* codegen.y: The yacc parser file */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
void yyerror(char const *s);
int yylex(void);
%}

%union {
    char *var;
}

%token <var> ID
%token ASSIGN

%%

program:
      /* empty */
    | program statement
    ;

statement:
      /* Arithmetic operations */
      ID ASSIGN ID '+' ID '\n' {
          printf("\tMOV AX, %s\n", $3);
          printf("\tADD AX, %s\n", $5);
          printf("\tMOV %s, AX\n\n", $1);
          free($1); free($3); free($5);
      }

    | ID ASSIGN ID '-' ID '\n' {
          printf("\tMOV AX, %s\n", $3);
          printf("\tSUB AX, %s\n", $5);
          printf("\tMOV %s, AX\n\n", $1);
          free($1); free($3); free($5);
      }

    | ID ASSIGN ID '*' ID '\n' {
          printf("\tMOV AX, %s\n", $3);
          printf("\tMOV BX, %s\n", $5);
          printf("\tMUL AX BX\n");
          printf("\tMOV %s, AX\n\n", $1);
          free($1); free($3); free($5);
      }

    | ID ASSIGN ID '/' ID '\n' {
          printf("\tMOV AX, %s\n", $3);
          printf("\tMOV BX, %s\n", $5);
          printf("\tDIV AX BX\n");
          printf("\tMOV %s, AX\n\n", $1);
          free($1); free($3); free($5);
      }

      /* ✅ Handle simple assignments like a := b or a := 10 */
    | ID ASSIGN ID '\n' {
          printf("\tMOV %s, %s\n\n", $1, $3);
          free($1); free($3);
      }

      /* Ignore blank lines or malformed input */
    | '\n'
    | error '\n' { yyerrok; }
    ;

%%

int main() {
    yyin = fopen("optimized.txt", "r");
    if (!yyin) {
        perror("optimized.txt");
        return 1;
    }

    printf("--- Assembly ---\n\n");
    yyparse();
    printf("--- End of Assembly ---\n");

    fclose(yyin);
    return 0;
}

void yyerror(char const *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}
