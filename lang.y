%{
#include <stdio.h>

extern FILE *yyin;
extern int yylex(void);
void yyerror(const char *s);

%}
%define parse.error verbose

/* declare tokens */
%token VAR EQUALS IDENTIFIER
%token NUMBER MAIN END_PROGRAM
%token ADD SUB MUL DIV MOD
%token MAX MIN
%token POP DUP SWAP DROP OVER
%token IF_POS IF_NEG IF_ZERO ELSE THEN DO LOOP END
%token FUNC
%token IN OUT
%token EOL OTHER

%%

program:
  
| program mainfunc
;

mainfunc: MAIN code END_PROGRAM;

code: expr code { printf("= %d\n", $$); }
| condition code
| do_loop code
|
;

condition: cond_type code ELSE code END;

cond_type: IF_ZERO { printf("zero?\n"); }
| IF_NEG { printf("neg?\n"); }
| IF_POS { printf("pos?\n"); }
;

do_loop: DO code LOOP { printf("do loop\n"); };

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
