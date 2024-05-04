%{
#include <stdio.h>

extern int yylex(void);
extern FILE *yyin;
extern FILE *yyout;
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
 { fprintf(yyout, "section .text\n\tglobal _start\n\textern out\n\textern in\n\textern say\n\n_start:\n"); }
 code
 END_PROGRAM
 { fprintf(yyout, "\n\tmov rax, 60\n\tmov rdi, 0\n\tsyscall\n"); }
 ;

code: expr code
| condition code
| do_loop code
| in_and_out code
| stack code
|
;


expr: NUMBER        { fprintf(yyout, "\tpush %d\n", $1); }
| expr expr ADD     { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tadd rax, rbx\n\tpush rax\n"); }
| expr expr SUB     { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tsub rax, rbx\n\tpush rax\n"); }
| expr expr MUL     { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tmul rbx\n\tpush rax\n"); }
| expr expr DIV     { fprintf(yyout, "\txor rdx, rdx\n\tpop rax\n\tpop rbx\n\tdiv rbx\n\tpush rax\n");  }
| expr expr MOD     { fprintf(yyout, "\txor rdx, rdx\n\tpop rbx\n\tpop rax\n\tdiv rbx\n\tpush rdx\n");  }
| expr expr MAX     { fprintf(yyout, "\t; max\n");  }
| expr expr MIN     { fprintf(yyout, "\t; min\n");  }
;


condition: { fprintf(yyout, "\tpop rax\n\tcmp rax, 0\n"); }
cond_type
{ fprintf(yyout, "cond_%d\n", conditionals); }
code
ELSE
{ fprintf(yyout, "\tjmp cond_end_%d\ncond_%d:\n", conditionals, conditionals); }
code
END
{ fprintf(yyout, "cond_end_%d:\n", conditionals++); }
;

cond_type: IF_ZERO { fprintf(yyout, "\tjne "); }
| IF_NEG           { fprintf(yyout, "\tjg "); }
| IF_POS           { fprintf(yyout, "\tjl "); }
;


do_loop: DO
{ fprintf(yyout, "loop_%d:\n", loops); }
code
LOOP
{ fprintf(yyout, "\tjmp loop_%d\n", loops++); }
;

in_and_out: IN { fprintf(yyout, "\tcall in\n"); }
| OUT { fprintf(yyout, "\tcall out\n"); }
| SAY { fprintf(yyout, "\tcall say\n"); };
;


stack: POP { fprintf(yyout, "\tpop rax\n"); }
| DUP      { fprintf(yyout, "\tpop rax\n\tpush rax\n\tpush rax\n"); }
| SWAP     { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tpush rax\n\tpush rbx\n"); }
| DROP     { fprintf(yyout, "\tmov rbx, rax\n\tpop rax\n\t mov rax, rbx\n"); }
| OVER     { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tpush rbx\n\tpush rax\n\tpush rbx\n"); }
;

%%
int main(int argc, char **argv)
{
    yyin = fopen("test.beg", "r");
    yyout = fopen("out.asm", "w");

    yyparse();

    fclose(yyin);
    fclose(yyout);
}

void yyerror(const char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
