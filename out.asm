section .bss
	datastack resq 1024
section .text
	global _start
	extern out
	extern in
	extern say
	extern end_program
	extern exit

_start:
	lea r12, [datastack]
	jmp main
fib_iter_1:
	mov rax, 0
	mov [r12], rax
	add r12, 8
	mov rax, 1
	mov [r12], rax
	add r12, 8
	mov rax, [r12 - 8]
	mov rbx, [r12 - 16]
	mov rcx, [r12 - 24]
	mov [r12 - 8], rcx
	mov [r12 - 16], rax
	mov [r12 - 24], rbx
	mov rax, 0
	mov [r12], rax
	add r12, 8
	sub r12, 8
	mov r13, [r12]
	sub r12, 8
	mov r14, [r12]
loop_start_1:
	cmp r13, r14
	jge loop_end_1
	sub r12, 8
	mov rax, [r12]
	sub r12, 8
	mov rbx, [r12]
	mov [r12], rbx
	add r12, 8
	mov [r12], rax
	add r12, 8
	mov [r12], rbx
	add r12, 8
	sub r12, 8
	mov rax, [r12]
	sub r12, 8
	mov rbx, [r12]
	add rax, rbx
	mov [r12], rax
	add r12, 8
	sub r12, 8
	mov rax, [r12]
	sub r12, 8
	mov rbx, [r12]
	mov [r12], rax
	add r12, 8
	mov [r12], rbx
	add r12, 8
	call out
	inc r13
	jmp loop_start_1
loop_end_1:
	sub r12, 8
	ret

main:
	mov rax, 10
	mov [r12], rax
	add r12, 8
	call fib_iter_1
	call end_program
