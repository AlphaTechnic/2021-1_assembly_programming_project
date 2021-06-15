TITLE Get frequencies
;Write a procedure named Get_frequencies that constructs a character frequency table. Input to the
;procedure should be a pointer to a string and a pointer to an array of 256 doublewords initialized
;to all zeros. Each array position is indexed by its corresponding ASCII code. When the procedure
;returns, each entry in the array contains a count of how many times the corresponding character
;occurred in the string.

INCLUDE Irvine32.inc

Get_frequencies PROTO,
    pString:ptr byte,   
    pTable:ptr dword 

.data
    target byte "AAEBDCFBBC", 0 ; input data
    freqTable DWORD 256 DUP(0)

    prompt1 byte "String : ", 0
    prompt2 byte "Index      FreqTable", 0
    space byte "      ", 0

.code
main PROC
    call display_string

    INVOKE Get_frequencies, ADDR target, ADDR freqTable
    
    call display_table
    exit
main ENDP


;-------------------------------------------------------------------------------
display_string proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
    call Clrscr
    mov  edx, offset prompt1
    call WriteString
    mov  edx, offset target
    call WriteString
    call crlf
    call crlf

    mov  edx, offset prompt2
    call WriteString
display_string endp


;-------------------------------------------------------------------------------
Get_frequencies PROC,
    pString:ptr byte,   ; parameter string
    pTable:ptr dword    ; parameter table
; Recieves - pString, pTable
; Returns - freqTable
;-------------------------------------------------------------------------------
    mov esi, pString
    mov edi, pTable

L1: 
    mov eax, 0
    mov al, [esi]
    add esi, 1

    cmp al, 0     ; EOF check
    je THEEND 
    
    ; multiply by 4, 4byte 공간에 frequencies를 저장하기 위함 
    shl eax, 2        
    ; 해당 index의 count를 1 올린다.
    inc DWORD PTR [edi + eax]
    jmp L1

THEEND:
    ret

Get_frequencies ENDP


;-------------------------------------------------------------------------------
display_table PROC
; Display the non-empty entries of the frequency table.
;-------------------------------------------------------------------------------
    call Crlf
    mov ecx, length freqTable    
    mov esi, offset freqTable
    mov ebx, 0          ; ASCII == 0 부터 탐색

 L1:    
    mov eax, [esi]
    cmp eax, 0
    jz NXT              ; freq 0인 부분은 skip

print_table:
    mov eax, ebx    
    call Writehex
    mov edx, OFFSET space
    call WriteString
    mov eax, [esi]  ; show frequency count
    call WriteDec
    call Crlf

NXT:   
    add esi, type freqTable
    add ebx, 1
    loop L1

    call Crlf

    ret
display_table ENDP

END main