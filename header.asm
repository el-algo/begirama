global out, say, in

section .bss
    res resd 1
    pos resd 1
    max_digits resb 11

section .text
; Prints the top of the stack
out:
    mov rax, [rsp + 8]
    xor rbx, rbx
    xor rcx, rcx

    mov rbx, 10         ; Division const
        
    .a:
        xor rdx, rdx
        div bx          ; Actual number / 10
        push rdx
        inc rcx         ; Count digits
        test rax, rax
        jnz .a
        mov [pos], rcx  ; Store total digits

    .b:
        pop rdx
        add rdx, '0'        ; Digits -> ASCII
        mov [res], dl

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
    mov rax, 0
    mov rdi, 0
    mov rsi, max_digits
    mov rdx, 11
    syscall

    call say
    ret