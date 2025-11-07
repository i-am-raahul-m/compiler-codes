%{
#include <stdio.h>
#include <string.h>
#include "optimizer.tab.h"
%}

%%
[0-9]+                 { yylval.str = strdup(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }

[ \t\r\n]+             ;   /* Ignore whitespace and newlines entirely */
.                      { return *yytext; }
%%

int yywrap(void) { return 1; }
