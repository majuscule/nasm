section .data
    hello:     db 'Hello, world.',10   ; declare initialized string with linefeed char
    helloLen:  equ $-hello             ; declare and init. constant
    done: db 0

section .text
    global _start

_start:
    movzx eax, byte [done]      ; Pad value of done to one byte and put in eax
    cmp eax,1                   ; Compare eax with 1
    jg myFirstASMLabel          ; Jump if greater than to myFirstASMLabel

    mov byte [done], 1

    mov eax,4            ; Put magic # for system call sys_write into eax
    mov ebx,1            ; Prepare arg 1 of sys_write, 1 - file descriptor of stdo
    mov ecx,hello        ; Prepare arg 2, reference to string hello
    mov edx,helloLen     ; Prepare arg 3, string length, no deref. b/c constant 
    int 80h              ; Call the kernel
;

myFirstASMLabel:
    mov eax,1            ; The system call for exit (sys_exit)
    mov ebx,0            ; Exit with return code of 0 (no error)
    int 80h

