%{
#include <stdio.h>

extern FILE *yyin;
extern int yylex(void);
void yyerror(const char *s);

%}
%define parse.error verbose

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
| stmt EOL
;

stmt: IF_ZERO else_body { printf("zero? else \n"); }
| IF_POS else_body      { printf("pos? else \n"); }
| IF_NEG else_body      { printf("neg? else \n"); }
| IF_ZERO cond_body     { printf("zero?\n"); }
| IF_POS cond_body      { printf("pos?\n"); }
| IF_NEG cond_body      { printf("neg?\n"); }
| expr                  { printf("MATH %d\n", $$); }
| DO loop_body          { printf("do loop\n"); }
;

cond_body: stmt END
;

else_body: stmt ELSE cond_body
;

loop_body: stmt LOOP
;

expr: NUMBER        { $$ = $1;         }
| expr expr ADD     { $$ = $1 + $2;    }
| expr expr SUB     { $$ = $1 - $2;    }
| expr expr MUL     { $$ = $1 * $2;    }
| expr expr DIV     { $$ = $1 / $2;    }
| expr expr MOD     { $$ = $1 % $2;    }
| expr expr MAX     { $$ = $1 % $2;    }
| expr expr MIN     { $$ = $1 % $2;    }
;

%%
int main(int argc, char **argv)
{
    yyin = fopen("test.beg", "r");
    yyparse();
    //printf("%d\n", yyparse());
}

void yyerror(const char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
