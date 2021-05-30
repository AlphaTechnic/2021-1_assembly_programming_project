include Irvine32.inc

; Binary Multiplication
.code
main PROC
    mov     eax,42
    mov     ebx,20
    call    bitmul
                        ; EAX = 840
    exit
main ENDP
 
 
; Multiplies an unsigned 32 bit integer in EAX by EBX
; Receives: EAX = uint32, EBX = uint32
; Returns: EAX
bitmul PROC
    push    edx         ; save used registers
    push    ecx
    mov     edx, eax    ; store original multiplicand into EDX
    mov     ecx, 32     ; loop for 32 bits
    mov     eax, 0      ; eax will accumulate the result
 
BeginLoop:
    shr     edx, 1      ; shift lowest bit into carry flag
    jnc     DontAdd     ; jump if carry flag not set
    add     eax, ebx
DontAdd:
    shl     ebx, 1      ; shifting multiplies EBX by 2
    loop    BeginLoop
 
    pop     ecx         ; restore used registers
    pop     edx
    ret
bitmul ENDP
 
END main