%{
# include <stdio.h>
/* Get access to token types for return statements */
# include "lang.tab.h"
%}
/* Read only input files */
%option noyywrap

/* Arithmetic Operations */
/* Stack Operations */
/* Conditionals */
/* Main & End */
/* Loops */
/* I/O Instructions*/

%%
[0-9]+	{ yylval = atoi(yytext); return NUMBER; }
"+"		{ return ADD; }
"-"		{ return SUB; }
"*"		{ return MUL; }
"/"		{ return DIV; }
"%"		{ return MOD; }

"pop"	{ return POP; }
"dup"	{ return DUP; }
"swap"	{ return SWAP; }
"over"	{ return OVER; }
"drop"	{ return DROP; }
"hold"	{ return HOLD; }

"if_pos"	{ return IF_POS; }
"if_neg"	{ return IF_NEG; }
"if_zero"	{ return IF_ZERO; }
"else"	{ return ELSE; }
"end"	{ return END; }

"main"  { return MAIN; }
"end_program"  { return END_PROGRAM; }

"do"	{ return DO; }
"loop"	{ return LOOP; }
"break"	{ return BREAK; }

"in"	{ return IN; }
"out"	{ return OUT; }
"say"	{ return SAY; }
"exit"	{ return EXIT; }

\n		{ }
[ \t]	{ }
.		{ /*return OTHER;*/ }
