%{
%}

%s S1 S2 S3 S4

%%
<INITIAL>a BEGIN S2;
<INITIAL>b BEGIN S4;
<INITIAL>\n BEGIN INITIAL;

<S1>a BEGIN S2;
<S1>b BEGIN S4;
<S1>\n BEGIN INITIAL; printf("Rejected\n");

<S2>a BEGIN S1;
<S2>b BEGIN S3;
<S2>\n BEGIN INITIAL; printf("Rejected\n");

<S3>a BEGIN S4;
<S3>b BEGIN S2;
<S3>\n BEGIN INITIAL; printf("Accepted\n");

<S4>a BEGIN S3;
<S4>b BEGIN S1;
<S4>\n BEGIN INITIAL; printf("Rejected\n");
%%

int main(int argc, char *argv[]) {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}