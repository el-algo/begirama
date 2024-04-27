lang: lang.l lang.y
	bison -d -Wcounterexamples lang.y
	flex lang.l
	cc -o $@ lang.tab.c lex.yy.c -lfl