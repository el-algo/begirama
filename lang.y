%{
#include <stdio.h>

extern FILE *yyin;
extern int yylex(void);
void yyerror(const char *s);

int loops = 1;
int conditionals = 1;

%}
%define parse.error verbose

/* declare tokens */
%token MAIN END_PROGRAM
%token NUMBER ADD SUB MUL DIV MOD
%token MAX MIN
%token POP DUP SWAP DROP OVER
%token IF_POS IF_NEG IF_ZERO ELSE DO LOOP END
%token IN OUT SAY
%token EOL OTHER

%%

program:
  
| program mainfunc
;

mainfunc: MAIN
 { printf("section .text\n\tglobal _start\nextern printf\nextern scanf\n\n_start:\n"); }
 code
 END_PROGRAM
 { printf("\n\tmov rax, 60\n\tmov rdi, 0\n\tsyscall\n"); }
 ;

code: expr code
| condition code
| do_loop code
| in_and_out code
| stack code
|
;


expr: NUMBER        { printf("\tpush %d\n", $1); }
| expr expr ADD     { printf("\tpop rax\n\tpop rbx\n\tadd rbx\n\tpush rax\n"); }
| expr expr SUB     { printf("\tpop rax\n\tpop rbx\n\tsub rbx\n\tpush rax\n"); }
| expr expr MUL     { printf("\tpop rax\n\tpop rbx\n\tmul rbx\n\tpush rax\n"); }
| expr expr DIV     { printf("\tpop rax\n\tpop rbx\n\tdiv rbx\n\tpush rax\n");  }
| expr expr MOD     { printf("\txor rdx, rdx\n\tpop rbx\n\tpop rax\n\tdiv rbx\n\tpush rdx\n");  }
| expr expr MAX     { printf("\t; max\n");  }
| expr expr MIN     { printf("\t; min\n");  }
;


condition: { printf("\tpop rax\n\tcmp rax, 0\n"); }
cond_type
{ printf("cond_%d\n", conditionals); }
code
ELSE
{ printf("\tjmp cond_end\ncond_%d:\n", conditionals++); }
code
END
{ printf("cond_end:\n"); }
;

cond_type: IF_ZERO { printf("\tjne "); }
| IF_NEG           { printf("\tjg "); }
| IF_POS           { printf("\tjl "); }
;


do_loop: DO
{ printf("loop_%d:\n", loops); }
code
LOOP
{ printf("\tjmp loop_%d\n", loops++); }
;

in_and_out: IN { printf("\t; scanf\n"); }
| OUT { printf("\t; print int\n"); }
| SAY { printf("\t; print char\n"); };
;


stack: POP { printf("\tpop rax\n"); }
| DUP      { printf("\tpop rax\n\tpush rax\n\tpush rax\n"); }
| SWAP     { printf("\tpop rax\n\tpop rbx\n\tpush rax\n\tpush rbx\n"); }
| DROP     { printf("\tmov rbx, rax\n\tpop rax\n\t mov rax, rbx\n"); }
| OVER     { printf("\tpop rax\n\tpop rbx\n\tpush rbx\n\tpush rax\n\tpush rbx\n"); }
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
