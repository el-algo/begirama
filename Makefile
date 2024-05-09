lang: lang.l lang.y
	bison -d -Wcounterexamples lang.y
	flex lang.l
	cc -o $@ lang.tab.c lex.yy.c -lfl

bin: out.asm header.asm
	./lang test.beg
	nasm -f elf64 -o out.o out.asm
	nasm -f elf64 -o header.o header.asm 
	ld -o final.bin out.o header.o
