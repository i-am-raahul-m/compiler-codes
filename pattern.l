%{
#include "pattern.tab.h"
%}
%option noyywrap

%%
a   { return A; }
b   { return B; }
\n  { return 0; }
.   ;
%%
