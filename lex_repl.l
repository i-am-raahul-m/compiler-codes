%{
#include <stdio.h>
#include <string.h>

int count = 0;
char word[100];
char repl[100];
char content[1000];
%}

%%
[A-Za-z]+ {
    if (strcmp(yytext, word) == 0) {
        count++;
        strcat(content, repl);
    }
    else strcat(content, yytext);
}
[ \n\t] {strcat(content, yytext);}
. { strcat(content, yytext); }
%%

int main(int argc, char *argv[]) {
    if (argc != 4) return 1;
    strcpy(word, argv[2]);
    strcpy(repl, argv[3]);
    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        printf("Error: Cannot open file %s\n", argv[1]);
        return 1;
    }
    yylex();
    printf("Replaced %d times.\n", count);
    fclose(yyin);
    FILE *in = fopen(argv[1], "w");
    fprintf(in, "%s", content);
    fclose(in);
    return 0;
}

int yywrap() {
    return 1;
}