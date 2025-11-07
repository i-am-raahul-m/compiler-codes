%{
#include <stdio.h>
#include <stdlib.h>

typedef struct node {
    char op;
    int val;
    struct node *left, *right;
} Node;

Node* makeNode(char op, int val, Node* left, Node* right) {
    Node* n = (Node*)malloc(sizeof(Node));
    n->op = op;
    n->val = val;
    n->left = left;
    n->right = right;
    return n;
}

void printPostfix(Node* root) {
    if (!root) return;
    printPostfix(root->left);
    printPostfix(root->right);
    if (root->op == 'n')
        printf("%d ", root->val);
    else
        printf("%c ", root->op);
}

Node* root;

/* Forward declarations */
int yylex();
int yyerror(char* s);
%}

%union {
    int num;
    struct node* n;
}

%token <num> NUMBER
%token NEWLINE
%type <n> expr
%left PLUS MINUS
%left MUL DIV
%right UMINUS
%token LPAREN RPAREN

%%

program: /* empty */
       | program line
       ;

line: expr NEWLINE { root = $1; printPostfix(root); printf("\n"); }
    | NEWLINE      /* ignore empty lines */
    | error NEWLINE { yyerrok; }  /* error recovery */
    ;

expr:
      expr PLUS expr   { $$ = makeNode('+', 0, $1, $3); }
    | expr MINUS expr  { $$ = makeNode('-', 0, $1, $3); }
    | expr MUL expr    { $$ = makeNode('*', 0, $1, $3); }
    | expr DIV expr    { $$ = makeNode('/', 0, $1, $3); }
    | LPAREN expr RPAREN { $$ = $2; }
    | MINUS expr %prec UMINUS { $$ = makeNode('-', 0, makeNode('n', 0, NULL, NULL), $2); }
    | NUMBER { $$ = makeNode('n', $1, NULL, NULL); }
    ;

%%

int main() {
    return yyparse();
}

int yyerror(char* s) {
    printf("Error: %s\n", s);
    return 0;
}