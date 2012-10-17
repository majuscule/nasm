%macro print 2           ; Declare a macro to print a string, with two arguments
    mov rax,1            ; Put magic # for system call sys_write into rax
    mov rdi,1            ; Prepare arg 1 of sys_write, 1 - file descriptor of stdo
    mov rsi,%1           ; Prepare arg 2, a string reference
    mov rdx,%2           ; Prepare arg 3, string length, no deref. b/c constant 
    syscall              ; Call the kernel
%endmacro

section .data
    hello:     db  'Hello, world.',10   ; declare initialized string with linefeed char
    helloLen:  equ $-hello              ; declare and init. constant
    done:      db  0

section .text
    global _start        ; Declare program entry point

_print:
    push rbp             ; Prologue, save stack pointer
    mov rbp,rsp          ; Get base pointer (start of arguments)
    mov rbx,[rbp+16]     ; Get first argument (offset from base by the return address)
    print rbx,helloLen   ; Macro, replaced inline
    leave                ; Epilogue, equivalent to mov rsp,rbp; pop rbp
    ret                  ; Return control to caller

_start:
    cmp byte [done],1    ; Compare byte padded value of done with 1
    jg exit              ; Jump if greater than to exit

    mov byte [done], 1   ; Put 1 in done

    push hello           ; Push the last argument of _print onto the stack
    call _print          ; Call the function _print

exit:
    mov rax,60           ; The system call for exit (sys_exit)
    mov rdi,0            ; Exit with return code of 0 (no error)
    syscall

