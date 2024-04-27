/* recognize tokens for the calculator and print them out */
%{
# include "lang.tab.h"
%}

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

"func"	{ return FUNC; }

"in"	{ return IN; }
"out"	{ return OUT; }

"var"	{ return VAR; }
"="	{ return EQUALS; }
[a-zA-Z_][a-zA-Z_0-9]* { return IDENTIFIER; }

\n		{ return EOL; }
[ \t]	{ }
.		{ return OTHER; }
