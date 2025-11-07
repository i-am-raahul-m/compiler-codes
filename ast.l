%{
#include "ast.tab.h"
%}

%%
[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }
[ \t]       ;
\n          { return NEWLINE; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"("         { return LPAREN; }
")"         { return RPAREN; }
.           { return yytext[0]; }
%%

int yywrap() { return 1; }