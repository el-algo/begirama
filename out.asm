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
puts_1:
loop_start_1:
	mov rax, [r12 - 8]
	cmp rax, 0
	jne cond_1
	sub r12, 8
	jmp loop_end_1
	jmp cond_end_1
cond_1:
cond_end_1:
	call say
	jmp loop_start_1
loop_end_1:
	ret
puts_ln_1:
	mov rax, 0
	mov [r12], rax
	add r12, 8
	mov rax, 10
	mov [r12], rax
	add r12, 8
	call puts_1
	ret

main:
	sub r12, 8
	mov rax, [r12]
	mov [r12], rax
	add r12, 8
	mov [r12], rax
	add r12, 8
	sub r12, 8
	mov rax, [r12]
	sub r12, 8
	mov rbx, [r12]
	imul rax, rbx
	mov [r12], rax
	add r12, 8
	call end_program
