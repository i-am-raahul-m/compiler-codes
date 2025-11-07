%{
#include <stdio.h>

int yylex(void);
void yyerror(char *s);
int aCount = 0, bCount = 0;
%}

%token A B

%%
start: str {
    if (aCount != bCount)
        printf("String accepted: m != n\n");
    else
        printf("String rejected: m = n\n");
};

str: str A { aCount++; }
   | str B { bCount++; }
   | /* empty */
   ;
%%

int main() {
    printf("Enter string (a's and b's): ");
    yyparse();
    return 0;
}

void yyerror(char *s) {
    // Just suppress error message for clean output
}
