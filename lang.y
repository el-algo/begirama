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
| expr EOL          { printf("= %d\n", $1); }
;

expr: NUMBER        { $$ = $1;         }
| expr expr ADD     { $$ = $1 + $2;    }
| expr expr SUB     { $$ = $1 - $2;    }
| expr expr MUL     { $$ = $1 * $2;    }
| expr expr DIV     { $$ = $1 / $2;    }
| expr expr MOD     { $$ = $1 % $2;    }
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
