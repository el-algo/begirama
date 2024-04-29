%{
#include <stdio.h>

extern FILE *yyin;
extern int yylex(void);
void yyerror(const char *s);

%}
%define parse.error verbose

/* declare tokens */
%token MAIN END_PROGRAM
%token NUMBER ADD SUB MUL DIV MOD
%token MAX MIN
%token POP DUP SWAP DROP OVER
%token IF_POS IF_NEG IF_ZERO ELSE THEN DO LOOP END
%token IN OUT SAY
%token EOL OTHER

%%

program:
  
| program mainfunc
;

mainfunc: func_start func_body;

func_start: MAIN { printf("section .text\n\tglobal _start\n\n_start:\n"); };

func_body: code END_PROGRAM { printf("\n\tmov rax, 60\n\tsyscall\n"); };

code: expr code
| condition code
| do_loop code
| in_and_out code
|
;

expr: NUMBER        { printf("\tpush %d\n", $1); }
| expr expr ADD     { printf("\tpop rax\n\tpop rbx\n\tadd rbx\n\tpush rax\n"); }
| expr expr SUB     { printf("\tpop rax\n\tpop rbx\n\tsub rbx\n\tpush rax\n"); }
| expr expr MUL     { printf("\tpop rax\n\tpop rbx\n\tmul rbx\n\tpush rax\n"); }
| expr expr DIV     { printf("\tpop rax\n\tpop rbx\n\tdiv rbx\n\tpush rax\n");  }
| expr expr MOD     { printf("\txor rdx, rdx\n\tpop rbx\n\tpop rax\n\tdiv rbx\n\tpush rdx\n");  }
| expr expr MAX     { printf("\tnot implemented\n");  }
| expr expr MIN     { printf("\tnot implemented\n");  }
;

condition: cond_type code cond_body cond_end;

cond_body: ELSE { printf("\tjmp cond_end\n\tcond:\n"); };

cond_end: code END { printf("cond_end:\n"); };

cond_type: IF_ZERO { printf("\tpop rax\n\tcmp rax, 0\n\tjne cond\n"); }
| IF_NEG { printf("\tpop rax\n\tcmp rax, 0\n\tjg cond\n"); }
| IF_POS { printf("\tpop rax\n\tcmp rax, 0\n\tjl cond\n"); }
;

do_loop: do_start loop_body { printf("jmp loop\n"); };

do_start: DO { printf("loop:\n"); };

loop_body: code LOOP;


in_and_out: IN { printf("\tscanf\n"); }
| OUT { printf("\tprint int\n"); }
| SAY { printf("\tprint char\n"); };
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
