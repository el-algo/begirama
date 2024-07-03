global out, say, in, exit

section .bss
    res resd 1
    pos resd 1
    max_digits resb 16

section .text
; Prints the top of the stack
out:
    mov rax, [rsp + 8]
    xor rbx, rbx
    xor rcx, rcx

    mov rbx, 10         ; Division const

    test rax, rax
    jnl .a

    ; Make number positive for printing
    neg rax
    push rax

    ; Print '-'
    push 0x2D
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall
    add rsp, 8              ; Return stack pointer to origin
    
    pop rax
    xor rcx, rcx

    .a:
        xor rdx, rdx
        div rbx          ; Actual number / 10
        push rdx
        inc rcx         ; Count digits
        test rax, rax
        jnz .a
        mov [pos], rcx  ; Store total digits

    .b:
        pop rdx
        add rdx, '0'        ; Digits -> ASCII
        mov [res], dl

    .c:
        ; Print actual char
        mov rax, 1
        mov rdi, 1
        mov rsi, res
        mov rdx, 2
        syscall

        ; See progress
        mov rcx, [pos]
        dec rcx
        mov [pos], rcx
        cmp rcx, 0
        jnz .b

        ; Print \n
        push 0x0A
        mov rax, 1
        mov rdi, 1
        mov rsi, rsp
        mov rdx, 1
        syscall
        add rsp, 8          ; Return stack pointer to origin
    
        ret

say:
    add rsp, 8
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    sub rsp, 8              ; Return stack pointer to origin
    ret

in:
    push rax
    mov rax, 0
    mov rdi, 1
    mov rsi, max_digits
    mov rdx, 16
    syscall

    xor rbx, rbx

    mov al, byte[rsi]
    inc rsi
    cmp al, '-'
    je .next_digit

    ; The number is negative
    dec rsi
    mov rdi, 0

    .next_digit:
        mov al, byte[rsi]
        inc rsi

        cmp al, '0'
        jl done
        cmp al, '9'
        jg done

        sub al, '0'
        imul rbx, 10
        add rbx, rax
        jmp .next_digit

    done:
    cmp rdi, 0
    je in_final
    neg rbx

    in_final:
    pop rax
    ret

exit:
    mov rax, 60
    mov rdx, 0
    syscall