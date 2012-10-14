section .data
    hello:     db 'Hello, world.',10   ; declare initialized string with linefeed char
    helloLen:  equ $-hello             ; declare and init. constant
    done: db 0

section .text
    global _start

_start:
    movzx rax, byte [done]      ; Pad value of done to one byte and put in rax
    cmp rax,1                   ; Compare rax with 1
    jg myFirstASMLabel          ; Jump if greater than to myFirstASMLabel

    mov byte [done], 1

    mov rax,1            ; Put magic # for system call sys_write into rax
    mov rdi,1            ; Prepare arg 1 of sys_write, 1 - file descriptor of stdo
    mov rsi,hello        ; Prepare arg 2, reference to string hello
    mov rdx,helloLen     ; Prepare arg 3, string length, no deref. b/c constant 
    syscall              ; Call the kernel
;

myFirstASMLabel:
    mov rax,60            ; The system call for exit (sys_exit)
    mov rdi,0             ; Exit with return code of 0 (no error)
    syscall

