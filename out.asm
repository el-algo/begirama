section .text
	global _start
	extern out
	extern in
	extern say
	extern exit

_start:
	push 0
	push 10
	push 33
	push 100
	push 108
	push 114
	push 111
	push 119
	push 32
	push 111
	push 108
	push 108
	push 101
	push 72
loop_1:
	mov rax, [rsp]
	cmp rax, 0
	jne cond_1
	jmp loop_1_end
	jmp cond_end_1
cond_1:
	call say
	pop rax
cond_end_1:
	jmp loop_1
loop_1_end:
	call exit
