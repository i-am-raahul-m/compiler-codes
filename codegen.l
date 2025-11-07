/* codegen.l: The lexer file */
%{
#include "codegen.tab.h"
#include <string.h>
#include <stdio.h>
extern YYSTYPE yylval;
FILE *yyin;
%}

%%
[0-9]+                 { yylval.var = strdup(yytext); return ID; }  /* Treat numbers same as identifiers */
[a-zA-Z][a-zA-Z0-9]*   { yylval.var = strdup(yytext); return ID; }

"="                   { return ASSIGN; }
"+"                    { return '+'; }
"-"                    { return '-'; }
"*"                    { return '*'; }
"/"                    { return '/'; }
"\n"                   { return '\n'; }
[ \t]+                 ;  /* Ignore whitespace */
.                      { fprintf(stderr, "Error: Unknown character '%s'\n", yytext); }
%%

int yywrap(void) { return 1; }
