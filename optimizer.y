%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern FILE *yyin;

/* ---------- Helper Utilities ---------- */

char* make_str(const char *s) {
    char *buf = malloc(strlen(s) + 5);
    strcpy(buf, s);
    return buf;
}

int is_number(const char *s) {
    for (int i = 0; s[i]; i++)
        if (!isdigit(s[i])) return 0;
    return 1;
}

int needs_paren_for_mul(const char *s) {
    return (strchr(s, '+') || strchr(s, '-'));
}

int needs_paren_for_add(const char *s) {
    return (strchr(s, '*') || strchr(s, '/'));
}

char *wrap_if_needed(const char *s, int need_paren) {
    if (!need_paren) return strdup(s);
    char *r = malloc(strlen(s) + 3);
    sprintf(r, "(%s)", s);
    return r;
}

int yylex(void);
int yyerror(char *s);
%}

%union {
    char* str;
}

%token <str> NUMBER ID
%type  <str> expr

%left '+' '-'
%left '*' '/'
%right UMINUS
%%

program:
      program stmt
    | /* empty */
    ;

stmt:
      ID '=' expr ';'   { printf("%s = %s\n", $1, $3); free($1); free($3); }
    | expr ';'          { printf("%s\n", $1); free($1); }
    ;

expr:
      expr '+' expr {
          if (is_number($1) && is_number($3)) {
              int val = atoi($1) + atoi($3);
              char buf[50]; sprintf(buf, "%d", val);
              $$ = make_str(buf);
              free($1); free($3);
          } else if (!strcmp($1, "0")) {
              $$ = $3; free($1);
          } else if (!strcmp($3, "0")) {
              $$ = $1; free($3);
          } else {
              char *a = wrap_if_needed($1, needs_paren_for_add($1));
              char *b = wrap_if_needed($3, needs_paren_for_add($3));
              char buf[200]; sprintf(buf, "%s+%s", a, b);
              $$ = make_str(buf);
              free(a); free(b); free($1); free($3);
          }
      }

    | expr '-' expr {
          if (is_number($1) && is_number($3)) {
              int val = atoi($1) - atoi($3);
              char buf[50]; sprintf(buf, "%d", val);
              $$ = make_str(buf);
              free($1); free($3);
          } else if (!strcmp($3, "0")) {
              $$ = $1; free($3);
          } else {
              char *a = wrap_if_needed($1, needs_paren_for_add($1));
              char *b = wrap_if_needed($3, needs_paren_for_add($3));
              char buf[200]; sprintf(buf, "%s-%s", a, b);
              $$ = make_str(buf);
              free(a); free(b); free($1); free($3);
          }
      }

    | expr '*' expr {
          if (is_number($1) && is_number($3)) {
              int val = atoi($1) * atoi($3);
              char buf[50]; sprintf(buf, "%d", val);
              $$ = make_str(buf);
              free($1); free($3);
          } else if (!strcmp($1, "1")) {
              $$ = $3; free($1);
          } else if (!strcmp($3, "1")) {
              $$ = $1; free($3);
          } else if (!strcmp($1, "0") || !strcmp($3, "0")) {
              $$ = make_str("0"); free($1); free($3);
          } else if (!strcmp($1, "2")) {
              char *b = wrap_if_needed($3, needs_paren_for_mul($3));
              char buf[200]; sprintf(buf, "%s<<1", b);
              $$ = make_str(buf);
              free(b); free($1); free($3);
          } else if (!strcmp($3, "2")) {
              char *a = wrap_if_needed($1, needs_paren_for_mul($1));
              char buf[200]; sprintf(buf, "%s<<1", a);
              $$ = make_str(buf);
              free(a); free($1); free($3);
          } else {
              char *a = wrap_if_needed($1, needs_paren_for_mul($1));
              char *b = wrap_if_needed($3, needs_paren_for_mul($3));
              char buf[200]; sprintf(buf, "%s*%s", a, b);
              $$ = make_str(buf);
              free(a); free(b); free($1); free($3);
          }
      }

    | expr '/' expr {
          if (is_number($1) && is_number($3) && atoi($3) != 0) {
              int val = atoi($1) / atoi($3);
              char buf[50]; sprintf(buf, "%d", val);
              $$ = make_str(buf);
              free($1); free($3);
          } else if (!strcmp($3, "1")) {
              $$ = $1; free($3);
          } else if (!strcmp($3, "2")) {
              char *a = wrap_if_needed($1, needs_paren_for_mul($1));
              char buf[200]; sprintf(buf, "%s>>1", a);
              $$ = make_str(buf);
              free(a); free($1); free($3);
          } else {
              char *a = wrap_if_needed($1, needs_paren_for_mul($1));
              char *b = wrap_if_needed($3, needs_paren_for_mul($3));
              char buf[200]; sprintf(buf, "%s/%s", a, b);
              $$ = make_str(buf);
              free(a); free(b); free($1); free($3);
          }
      }

    | NUMBER { $$ = $1; }
    | ID     { $$ = $1; }
    | '-' expr %prec UMINUS {
          char buf[100]; sprintf(buf, "-%s", $2);
          $$ = make_str(buf);
          free($2);
      }
    | '(' expr ')' { $$ = $2; }
    ;
%%

int yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

int main() {
    yyin = fopen("three_addr.txt", "r");
    if (!yyin) {
        perror("three_addr.txt");
        return 1;
    }
    printf("Optimized Code Output:\n");
    yyparse();
    fclose(yyin);
    return 0;
}
