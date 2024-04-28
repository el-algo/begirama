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
"max"	{ return MAX; }
"min"	{ return MIN; }

"pop"	{ return POP; }
"dup"	{ return DUP; }
"swap"	{ return SWAP; }
"drop"	{ return DROP; }
"over"	{ return OVER; }

"if_pos"	{ return IF_POS; }
"if_neg"	{ return IF_NEG; }
"if_zero"	{ return IF_ZERO; }
"else"	{ return ELSE; }

"do"	{ return DO; }
"loop"	{ return LOOP; }
"end"	{ return END; }

"in"	{ return IN; }
"out"	{ return OUT; }

";"		{ return EOL; }
\n		{ }
[ \t]	{ }
.		{ /*return OTHER;*/ }
