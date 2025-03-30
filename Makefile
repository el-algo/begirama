# Default source file name
src=test.beg

# Build compiler rule
lang: lang.l lang.y
	bison -d -Wcounterexamples lang.y
	flex lang.l
	cc -o $@ lang.tab.c lex.yy.c -lfl

# Compile Begirama source file
comp: $(src)
	./lang $(src)
	nasm -g -f elf64 -o out.o out.asm
	nasm -g -f elf64 -o header.o header.asm 
	ld -o $(src).bin out.o header.o
