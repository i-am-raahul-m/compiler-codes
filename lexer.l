%{
#include <stdio.h>
#include <string.h>
%}

%%
if|else|for|while|int|double  { printf("%s --> Keyword\n", yytext); }
[_A-Za-z][_A-Za-z0-9]*  { printf("%s --> Identifier\n", yytext); }
[0-9]+(\.[0-9]+)?  { printf("%s --> Number\n", yytext); }
[\{\}\[\]\(\),;]   { printf("%s --> Symbol\n", yytext); }
("++"|"--"|"+"|"-"|"*"|"/")  { printf("%s --> Operator\n", yytext); }
[ \t\n]+  ;
.  { printf("%s --> Invalid Token\n", yytext); }
%%

int main(int argc, char *argv[]) {
    if (argc != 2) return 1;
    yyin = fopen(argv[1], "r");
    if (!yyin) { perror("fopen"); return 1; }
    yylex();
    fclose(yyin);
    return 0;
}

int yywrap() {
    return 1;
}
