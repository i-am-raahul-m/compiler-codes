%{
#include "three_addr.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
[0-9]+              { yylval.str = strdup(yytext); return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }

"+"  return '+';
"-"  return '-';
"*"  return '*';
"/"  return '/';
"="  return '=';
";"  return ';';
"("  return '(';
")"  return ')';

[ \t\r\n]+  ;
.            { fprintf(stderr, "Error: Unexpected character '%c'\n", yytext[0]); }
%%

int yywrap(void) { return 1; }
