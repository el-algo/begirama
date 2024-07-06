section .text
	global _start
	extern out
	extern in
	extern say
	extern end_program
	extern exit

_start:
	call in
	push rbx
	pop rax
	call in
	push rbx
	pop rax
	push rax
	push rax
	pop rax
	pop rbx
	mul rbx
	push rax
	call out
	call end_program
