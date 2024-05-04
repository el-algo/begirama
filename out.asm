section .text
	global _start
	extern out
	extern in
	extern say

_start:
	push 1
	pop rax
	cmp rax, 0
	jne cond_1
	push 0
	jmp cond_end_1
cond_1:
	push 1
loop_1:
	call out
	jmp loop_1
cond_end_1:
	call out

	mov rax, 60
	mov rdi, 0
	syscall
