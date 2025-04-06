%{
# include <stdio.h>
#include "symbol_table.h"
/* Get access to token types for return statements */
# include "lang.tab.h"
%}

%option noyywrap
%x COMMENT

/* Comments */
/* Arithmetic Operations */
/* Stack Operations */
/* Conditionals */
/* Loops */
/* I/O Instructions*/
/* Define and call words */
/* Whitespace and unrecognized characters */

%%

"/*"        { BEGIN(COMMENT); } 
<COMMENT>"*/" { BEGIN(INITIAL); }
<COMMENT>.|\n { }

[-]?[0-9]+	{
    yylval.num = atoi(yytext);
    return NUMBER;
}
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
"rot" { return ROT; }

"if_pos"	{ return IF_POS; }
"if_neg"	{ return IF_NEG; }
"if_zero"	{ return IF_ZERO; }
"else"	{ return ELSE; }
"end"	{ return END; }

"do"	{ return DO; }
"while" { return WHILE; }
"loop"	{ return LOOP; }
"break"	{ return BREAK; }

"in"	{ return IN; }
"out"	{ return OUT; }
"say"	{ return SAY; }
"exit"	{ return EXIT; }

":"		{ return COLON; }
"."		{ return PERIOD; }
"main"  { return MAIN; }
[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.id = strdup(yytext);
    return IDENTIFIER;
}

[ \t\r]+	{ }
\n		    { }
.		{ fprintf(stderr, "Unrecognized character: %s\n", yytext); }
