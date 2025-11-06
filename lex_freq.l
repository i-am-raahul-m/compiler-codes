%{
#include <stdio.h>
#include <string.h>

int count = 0;
char word[100];
%}

%%
[A-Za-z]+ {
    if (strcmp(yytext, word) == 0) count++;
}
. ;
[ \n\t]+ ;
%%

int main(int argc, char *argv[]) {
    if (argc != 3) return 1;
    yyin = fopen(argv[1], "r");
    strcpy(word, argv[2]);
    yylex();
    printf("Count of word %s is %d\n", word, count);
    fclose(yyin);
    return 0;
}

int yywrap() {
    return 1;
}