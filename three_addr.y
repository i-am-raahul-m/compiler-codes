%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(char *);
int temp_count = 0;

char* new_temp() {
    char* temp = (char*)malloc(sizeof(char) * 4);
    sprintf(temp, "t%d", temp_count++);
    return temp;
}
%}

%union {
    char* str;
}

%token <str> ID NUM
%type  <str> stmt expr term factor

%left '+' '-'
%left '*' '/'

%%
program:
    | stmt_list
    ;

stmt_list:
      stmt
    | stmt_list stmt
    ;

stmt:
    ID '=' expr ';'   { printf("%s = %s\n", $1, $3); }
    ;

expr:
      expr '+' term   { $$ = new_temp(); printf("%s = %s + %s\n", $$, $1, $3); }
    | expr '-' term   { $$ = new_temp(); printf("%s = %s - %s\n", $$, $1, $3); }
    | term            { $$ = $1; }
    ;

term:
      term '*' factor { $$ = new_temp(); printf("%s = %s * %s\n", $$, $1, $3); }
    | term '/' factor { $$ = new_temp(); printf("%s = %s / %s\n", $$, $1, $3); }
    | factor          { $$ = $1; }
    ;

factor:
      '(' expr ')'    { $$ = $2; }
    | ID              { $$ = $1; }
    | NUM             { $$ = $1; }
    ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    extern FILE *yyin;
    yyin = fopen("code.txt", "r");
    if (!yyin) {
        perror("code.txt");
        exit(1);
    }
    printf("Three Address Code:\n");
    yyparse();
    fclose(yyin);
    return 0;
}
