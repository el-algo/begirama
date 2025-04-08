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
	mov rax, 20
	mov [r12], rax
	add r12, 8
	mov rax, 0
	mov [r12], rax
	add r12, 8
	sub r12, 8
	mov rbx, [r12]
	sub r12, 8
	mov rax, [r12]
	mov [r12], r13
	add r12, 8
	mov [r12], r14
	add r12, 8
	mov r13, rbx
	mov r14, rax
loop_start_2:
	cmp r13, r14
	jge loop_end_2
	mov rax, 20
	mov [r12], rax
	add r12, 8
	mov rax, 0
	mov [r12], rax
	add r12, 8
	sub r12, 8
	mov rbx, [r12]
	sub r12, 8
	mov rax, [r12]
	mov [r12], r13
	add r12, 8
	mov [r12], r14
	add r12, 8
	mov r13, rbx
	mov r14, rax
loop_start_3:
	cmp r13, r14
	jge loop_end_3
	mov rax, 0
	mov [r12], rax
	add r12, 8
	mov rax, 32
	mov [r12], rax
	add r12, 8
	mov rax, 42
	mov [r12], rax
	add r12, 8
	call puts_1
	inc r13
	jmp loop_start_3
loop_end_3:
	sub r12, 8
	mov r14, [r12]
	sub r12, 8
	mov r13, [r12]
	call puts_ln_1
	inc r13
	jmp loop_start_2
loop_end_2:
	sub r12, 8
	mov r14, [r12]
	sub r12, 8
	mov r13, [r12]
	call end_program
