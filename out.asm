section .text
	global _start
	extern out
	extern in
	extern say
	extern end_program
	extern exit

_start:
loop_1:
	call in
	push rbx
	call out
	jmp loop_1
loop_1_end:
	call end_program
