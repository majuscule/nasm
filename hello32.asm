%macro print 2           ; Declare a macro to print a string, with two arguments
    mov eax,4            ; Put magic # for system call sys_write into rax
    mov edi,1            ; Prepare arg 1 of sys_write, 1 - file descriptor of stdo
    mov esi,%1           ; Prepare arg 2, a string reference
    mov edx,%2           ; Prepare arg 3, string length, no deref. b/c constant 
    int 80h              ; Call the kernel
%endmacro

section .data
    hello:     db  'Hello, world.',10   ; declare initialized string with linefeed char
    helloLen:  equ $-hello              ; declare and init. constant
    done:      db  0

section .text
    global _start        ; Declare program entry point

_print:
    push ebp             ; Prologue, save stack pointer
    mov ebp,esp          ; Get base pointer (start of arguments)
    mov ebx,[ebp+8]      ; Get first argument (offset from base by the return address)
    print ebx,helloLen   ; Macro, replaced inline
    leave                ; Epilogue, equivalent to mov esp,ebp; pop ebp
    ret                  ; Return control to caller

_start:
    cmp byte [done],1    ; Compare byte padded value of done with 1
    jg exit              ; Jump if greater than to exit

    mov byte [done], 1   ; Put 1 in done

    push hello           ; Push the last argument of _print onto the stack
    call _print          ; Call the function _print

exit:
    mov eax,1            ; The system call for exit (sys_exit)
    mov edi,0            ; Exit with return code of 0 (no error)
    int 80h


