lang: lang.l lang.y
	bison -d -Wcounterexamples lang.y
	flex lang.l
	cc -o $@ lang.tab.c lex.yy.c -lfl
	./lang

bin: out.asm header.asm
	nasm -f elf64 -o out.o out.asm
	nasm -f elf64 -o header.o header.asm 
	ld -o final.bin out.o header.o
	./final.bin