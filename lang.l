/* recognize tokens for the calculator and print them out */
%{
# include <stdio.h>
# include "lang.tab.h"
%}
%option noyywrap

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
"main"  { return MAIN; }
"end_program"  { return END_PROGRAM; }

"do"	{ return DO; }
"loop"	{ return LOOP; }
"end"	{ return END; }

"in"	{ return IN; }
"out"	{ return OUT; }
"say"	{ return SAY; }
"exit"	{ return EXIT; }

\n		{ }
[ \t]	{ }
.		{ /*return OTHER;*/ }
