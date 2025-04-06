%{
#include <stdio.h>
#include "symbol_table.h"

extern int yylex(void);
extern FILE *yyin;
extern FILE *yyout;
void yyerror(const char *s);

int loop_count = 1;
int conditionals = 1;

void _push(const char* reg);
void _pop(const char* reg);
void emit_push(FILE* f, const char* reg);
void emit_pop(FILE* f, const char* reg);
%}

%define parse.error verbose

%union {
    int num;
    char* id;
}

/* Declare tokens */
%token MAIN
%token <num> NUMBER
%token ADD 
%token SUB
%token MUL
%token DIV
%token MOD
%token POP
%token DUP
%token SWAP
%token OVER
%token DROP
%token HOLD
%token ROT
%token IF_POS
%token IF_NEG
%token IF_ZERO
%token ELSE
%token END
%token DO
%token WHILE
%token LOOP
%token BREAK
%token IN
%token OUT
%token SAY
%token EXIT
%token <id> IDENTIFIER
%token COLON
%token PERIOD

%%

/// -----------------------------------
/// Starter rule
/// -----------------------------------
program:
     program { 
        fprintf(yyout, 
        "section .bss\n\tdatastack resq 1024\n"
        "section .text\n\tglobal _start\n"
        "\textern out\n\textern in\n\textern say\n"
        "\textern end_program\n\textern exit\n"
        "\n_start:"
        "\n\tlea r12, [datastack]"
        "\n\tjmp main\n");
    }
     definitions
     main-word
    | /* empty */
;


/// -----------------------------------
/// Word definitions
/// -----------------------------------
definitions: 
      define_word definitions
    | /* empty */
;


/// -----------------------------------
/// Main function
/// -----------------------------------
main-word:
    MAIN COLON { 
        fprintf(yyout, "\nmain:\n");
    }
    code
    END {
        fprintf(yyout, "\tcall end_program\n");
    }
;


/// -----------------------------------
/// Body
/// -----------------------------------
code:
      expr        code
    | condition   code
    | while_loop  code
    | do_loop     code
    | in_and_out  code
    | stack       code
    | break       code
    | call_word   code
    | /* empty */
;


/// -----------------------------------
/// Arithmetic Operations
/// -----------------------------------
expr: 
    NUMBER {
        fprintf(yyout, "\tmov rax, %d\n", $1);
        _push("rax");
    }
    | ADD {
        _pop("rax");
        _pop("rbx");
        fprintf(yyout, "\tadd rax, rbx\n");
        _push("rax");
    }
    | SUB {
        _pop("rbx");
        _pop("rax");
        fprintf(yyout, "\tsub rax, rbx\n");
        _push("rax");
    }
    | MUL {
        _pop("rax");
        _pop("rbx");
        fprintf(yyout, "\timul rax, rbx\n");
        _push("rax");
    }
    | DIV { 
        fprintf(yyout, "\txor rdx, rdx\n");
        _pop("rbx");
        _pop("rax");
        fprintf(yyout, "\tidiv rbx\n");
        _push("rax");
    }
    | MOD {
        fprintf(yyout, "\txor rdx, rdx\n");
        _pop("rbx");
        _pop("rax");
        fprintf(yyout, "\tidiv rbx\n");
        _push("rdx");
    }
;


/// -----------------------------------
/// Conditionals
/// -----------------------------------
condition:
    { 
        fprintf(yyout,
        "\tmov rax, [r12 - 8]\n"
        "\tcmp rax, 0\n");
    }
    cond_type {
        fprintf(yyout, "cond_%d\n", conditionals);
    }
    code {
        fprintf(yyout, "\tjmp cond_end_%d\n", conditionals);
        fprintf(yyout, "\tcond_%d\n", conditionals);
    }
    else
    END {
        fprintf(yyout, "cond_end_%d:\n", conditionals++);
    }
;


/// -----------------------------------
/// Types of conditionals
/// -----------------------------------
cond_type:
      IF_ZERO { fprintf(yyout, "\tjne "); }
    | IF_NEG { fprintf(yyout, "\tjg "); }
    | IF_POS { fprintf(yyout, "\tjl "); }
;


/// -----------------------------------
/// Else rule
/// -----------------------------------
else:
     ELSE code
    |
;

/// -----------------------------------
/// Finite loop
/// -----------------------------------
while_loop:
    WHILE  {
        // Start -> r13
        // Limit -> r14
        fprintf(yyout,
        "\tsub r12, 8\n\tmov r13, [r12]\n"
        "\tsub r12, 8\n\tmov r14, [r12]\n");

        // Label to start of the loop
        fprintf(yyout, "loop_start_%d:\n", loop_count);

        // Compare i < limit
        fprintf(yyout,
        "\tcmp r13, r14\n"
        "\tjge loop_end_%d\n",
        loop_count);
    }
    code
    LOOP {
        // Increment i
        fprintf(yyout, "\tinc r13\n");
        fprintf(yyout, "\tjmp loop_start_%d\n", loop_count);
        fprintf(yyout, "loop_end_%d:\n", loop_count);
        loop_count++;
    }
;


/// -----------------------------------
/// Infinite loop
/// -----------------------------------
do_loop:
    DO {
        fprintf(yyout, "loop_start_%d:\n", loop_count);
    }
    code
    LOOP {
        fprintf(yyout, "\tjmp loop_start_%d\n", loop_count);
        fprintf(yyout, "loop_end_%d:\n", loop_count);
        loop_count++;
    }
;

/// -----------------------------------
/// Break out of loop instruction
/// -----------------------------------
break: 
    BREAK { fprintf(yyout, "\tjmp loop_end_%d\n", loop_count); }
;


/// -----------------------------------
/// I/O Instructions
/// -----------------------------------
in_and_out:
      IN { fprintf(yyout, "\tcall in\n"); }
    | OUT { fprintf(yyout, "\tcall out\n"); }
    | SAY { fprintf(yyout, "\tcall say\n"); }
    | EXIT { fprintf(yyout, "\tcall exit\n"); }
;


/// -----------------------------------
/// Stack Operations
/// -----------------------------------
stack:
      POP { _pop("rax"); }
    | DUP { 
        _pop("rax");
        _push("rax");
        _push("rax");
    }
    | SWAP { 
        _pop("rax");
        _pop("rbx");
        _push("rax");
        _push("rbx");
    }
    | OVER {
        _pop("rax");
        _pop("rbx");
        _push("rbx");
        _push("rax");
        _push("rbx"); 
    }
    | DROP { fprintf(yyout, "\tsub r12, 8\n"); }
    | HOLD { fprintf(yyout, "\tadd r12, 8\n"); }
    | ROT {
        fprintf(yyout,
        "\tmov rax, [r12 - 8]\n"
        "\tmov rbx, [r12 - 16]\n"
        "\tmov rcx, [r12 - 24]\n"
        "\tmov [r12 - 8], rcx\n"
        "\tmov [r12 - 16], rax\n"
        "\tmov [r12 - 24], rbx\n");
    }
;

/// -----------------------------------
/// Define words
/// -----------------------------------
define_word:
    IDENTIFIER COLON {
        Symbol* symbol = define_symbol($1);
        fprintf(yyout, "%s:\n", symbol->label);
    }
    code
    END { 
        fprintf(yyout, "\tret\n");
        free($1);
    }
;

/// -----------------------------------
/// Call words
/// -----------------------------------
call_word:
    IDENTIFIER PERIOD { 
        Symbol* symbol = lookup_symbol($1);
        if (!symbol) {
            fprintf(stderr, "Undefined word: %s\n", $1);
            exit(1);
        }
    
        // Use the latest version of the label
        fprintf(yyout, "\tcall %s\n", symbol->label);
        free($1);
    }
;

%%
int main(int argc, char **argv)
{
    // Open the source file in read mode
    yyin = fopen(argv[1], "r");
    yyout = fopen("out.asm", "w");

    // Parse source file
    yyparse();

    // Clean up memory
    free_symbol_table();

    // Close the input and output files
    fclose(yyin);
    fclose(yyout);
}

void yyerror(const char *s)
{
    fprintf(stderr, "Error: %s\n", s);
}

// Push wrapper function
void _push(const char* reg)
{
    emit_push(yyout, reg);
}

// Pop wrapper function
void _pop(const char* reg)
{
    emit_pop(yyout, reg);
}

// Uses r12 as the stack pointer
void emit_push(FILE* f, const char* reg)
{
    fprintf(f,
        "\tmov [r12], %s\n"
        "\tadd r12, 8\n",
        reg
    );
}

// Uses r12 as the stack pointer
void emit_pop(FILE* f, const char* reg)
{
    fprintf(f,
        "\tsub r12, 8\n"
        "\tmov %s, [r12]\n",
        reg
    );
}
