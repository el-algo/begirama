%{
#include <stdio.h>

int yylex(void);
int yyerror(char *s);

%}

/* declare tokens */
%token VAR EQUALS IDENTIFIER
%token NUMBER
%token ADD SUB MUL DIV MOD
%token MAX MIN
%token POP DUP SWAP DROP OVER
%token IF_POS IF_NEG IF_ZERO ELSE DO LOOP END
%token FUNC
%token IN OUT
%token EOL OTHER

%%

input: /* empty */
| input line
;

line: EOL
| comp_stmt EOL
| expr EOL          { printf("= %d\n", $1); }
;

stmt: comp_stmt '}'
| IF_POS '{' expr '}' END stmt
| IF_NEG '{' expr '}' END stmt
| IF_ZERO '{' expr '}' END stmt
| DO '{' '}' LOOP stmt
| expr stmt
;

comp_stmt: '{'
| comp_stmt stmt
;

expr: NUMBER        { $$ = $1;         }
| expr expr ADD     { $$ = $1 + $2;    }
| expr expr SUB     { $$ = $1 - $2;    }
| expr expr MUL     { $$ = $1 * $2;    }
| expr expr DIV     { $$ = $1 / $2;    }
| expr expr MOD     { $$ = $1 % $2;    }
| expr expr MAX     { $$ = $1 % $2;    }
| expr expr MIN     { $$ = $1 % $2;    }
| var_defs
;

var_defs: VAR IDENTIFIER
| IDENTIFIER EQUALS
;

%%
int main(int argc, char **argv)
{
    yyparse();
    printf("%d\n", yyparse());
}

int yyerror(char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
