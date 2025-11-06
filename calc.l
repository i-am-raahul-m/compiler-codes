%{
#include "calc.tab.h"
#include <stdlib.h>
%}

%%
[0-9]+          { yylval = atoi(yytext); return NUMBER; }
\n              { return EOL; }
[+\-*/()]       { return yytext[0]; }
[ \t]           ;
.               { printf("Invalid character: %s\n", yytext); }
%%

int yywrap(void) {
    return 1;
}
