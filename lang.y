%{
#include <stdio.h>

extern int yylex(void);
extern FILE *yyin;
extern FILE *yyout;
void yyerror(const char *s);

int loops = 1;
int breaks = 1;
int conditionals = 1;

%}
%define parse.error verbose

/* declare tokens */
%token MAIN END_PROGRAM
%token NUMBER ADD SUB MUL DIV MOD
%token POP DUP SWAP OVER DROP HOLD
%token IF_POS IF_NEG IF_ZERO ELSE END DO LOOP BREAK
%token IN OUT SAY EXIT
%token EOL OTHER

%%

/* Starter rule */
program:
  
| program mainfunc
;


/* Main function */
mainfunc: MAIN
 { fprintf(yyout, "section .text\n\tglobal _start\n"); }
 { fprintf(yyout, "\textern out\n\textern in\n\textern say\n"); }
 { fprintf(yyout, "\textern end_program\n\textern exit\n\n_start:\n"); }
 code
 END_PROGRAM
 { fprintf(yyout, "\tcall end_program\n"); }
;


/* Body */
code: expr code
| condition code
| do_loop code
| in_and_out code
| stack code
| break code
|
;


/* Arithmetic Operations */
expr: NUMBER    { fprintf(yyout, "\tpush %d\n", $1); }
| ADD           { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tadd rax, rbx\n\tpush rax\n"); }
| SUB           { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tsub rax, rbx\n\tpush rax\n"); }
| MUL           { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tmul rbx\n\tpush rax\n"); }
| DIV           { fprintf(yyout, "\txor rdx, rdx\n\tpop rax\n\tpop rbx\n\tdiv rbx\n\tpush rax\n");  }
| MOD           { fprintf(yyout, "\txor rdx, rdx\n\tpop rbx\n\tpop rax\n\tdiv rbx\n\tpush rdx\n");  }
;


/* Conditional rule */
condition:      { fprintf(yyout, "\tmov rax, [rsp]\n\tcmp rax, 0\n"); }
 cond_type      { fprintf(yyout, "cond_%d\n", conditionals); }
 code           { fprintf(yyout, "\tjmp cond_end_%d\ncond_%d:\n", conditionals, conditionals); }
 else
 END            { fprintf(yyout, "cond_end_%d:\n", conditionals++); }
;

/* Types of conditionals */
cond_type: IF_ZERO { fprintf(yyout, "\tjne "); }
| IF_NEG           { fprintf(yyout, "\tjg "); }
| IF_POS           { fprintf(yyout, "\tjl "); }
;

/* Else statement */
else: ELSE code
|
;


/* Infinite loop */
do_loop: DO
{ fprintf(yyout, "loop_%d:\n", loops); }
code
LOOP
{ fprintf(yyout, "\tjmp loop_%d\nloop_%d_end:\n", loops, loops); loops++;}
;


/* Break out of loop instruction */
break: BREAK { fprintf(yyout, "\tjmp loop_%d_end\n", breaks++); };


/* I/O Instructions. */
in_and_out: IN { fprintf(yyout, "\tcall in\n\tpush rbx\n"); }
| OUT { fprintf(yyout, "\tcall out\n"); }
| SAY { fprintf(yyout, "\tcall say\n"); }
| EXIT { fprintf(yyout, "\tcall exit\n"); }
;


/* Stack Operations */
stack: POP { fprintf(yyout, "\tpop rax\n"); }
| DUP      { fprintf(yyout, "\tpop rax\n\tpush rax\n\tpush rax\n"); }
| SWAP     { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tpush rax\n\tpush rbx\n"); }
| OVER     { fprintf(yyout, "\tpop rax\n\tpop rbx\n\tpush rbx\n\tpush rax\n\tpush rbx\n"); }
| DROP     { fprintf(yyout, "\tadd rsp, 8\n"); }
| HOLD     { fprintf(yyout, "\tsub rsp, 8\n"); }
;

%%
int main(int argc, char **argv)
{
    // Open the source file in read mode
    yyin = fopen(argv[1], "r");
    yyout = fopen("out.asm", "w");

    // Parse source file
    yyparse();

    // Close the input and output files
    fclose(yyin);
    fclose(yyout);
}

void yyerror(const char *s)
{
    fprintf(stderr, "error: %s\n", s);
}
