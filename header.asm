global out, say, in, end_program, exit

section .bss
    res resd 1
    pos resd 1
    max_digits resb 16

section .text
; Prints the top of the stack
out:
    sub r12, 8
    mov rax, [r12]      ; get value from data stack

    push rbx
    push rcx
    push rdx
    xor rbx, rbx
    xor rcx, rcx
    mov rbx, 10         ; base 10

    test rax, rax
    jnl .a

    ; If negative, make positive and print '-'
    neg rax
    push rax

    push 0x2D           ; '-'
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    add rsp, 8

    pop rax
    xor rcx, rcx

.a:
    xor rdx, rdx
    div rbx             ; rax / 10 -> quotient in rax, remainder in rdx
    push rdx            ; save digit
    inc rcx             ; digit count
    test rax, rax
    jnz .a
    mov [pos], rcx

.b:
    pop rdx
    add dl, '0'         ; to ASCII
    mov [res], dl

    ; print char
    mov rax, 1
    mov rdi, 1
    mov rsi, res
    mov rdx, 1
    syscall

    mov rcx, [pos]
    dec rcx
    mov [pos], rcx
    cmp rcx, 0
    jnz .b

    ; print newline
    push 0x0A
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    add rsp, 8

    add r12, 8
    pop rdx
    pop rcx
    pop rbx
    ret


say:
    sub r12, 8
    mov rax, [r12]      ; get ASCII character

    push rbx
    push rcx
    push rdx

    push rax
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    add rsp, 8

    pop rdx
    pop rcx
    pop rbx
    ret


in:
    ; Read from stdin into buffer
    mov rax, 0          ; syscall: read
    mov rdi, 0          ; stdin
    mov rsi, max_digits ; buffer
    mov rdx, 16         ; max bytes
    syscall

    ; Parsing the number
    xor rbx, rbx        ; rbx will hold the result
    xor rdi, rdi        ; rdi = 0 -> positive, 1 -> negative

    mov r8, max_digits  ; r8 = pointer
    mov al, [r8]
    cmp al, '-'
    jne .parse_digits
    inc r8              ; skip '-'
    mov rdi, 1          ; mark as negative

.parse_digits:
    xor rcx, rcx        ; clear digit temp

.next_digit:
    mov al, [r8]
    cmp al, 0x0A        ; newline?
    je .done_parsing
    cmp al, 0
    je .done_parsing
    cmp al, '0'
    jl .done_parsing
    cmp al, '9'
    jg .done_parsing

    sub al, '0'
    movzx rcx, al
    imul rbx, rbx, 10
    add rbx, rcx

    inc r8
    jmp .next_digit

.done_parsing:
    cmp rdi, 0
    je .positive
    neg rbx

.positive:
    mov [r12], rbx
    add r12, 8
    ret


end_program:
    mov rax, 60
    mov rdx, 0
    syscall


exit:
    mov rdx, rax
    mov rax, 60
    syscall