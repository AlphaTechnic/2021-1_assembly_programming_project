TITLE Get frequencies
;Write a procedure named Get_frequencies that constructs a character frequency table. Input to the
;procedure should be a pointer to a string and a pointer to an array of 256 doublewords initialized
;to all zeros. Each array position is indexed by its corresponding ASCII code. When the procedure
;returns, each entry in the array contains a count of how many times the corresponding character
;occurred in the string.

INCLUDE Irvine32.inc

Get_frequencies PROTO,
    pString:PTR BYTE,   ; points to string
    pTable:PTR DWORD    ; points to frequency table

.data
target BYTE "AABBCCDDEEFF", 0
freqTable DWORD 256 DUP(0)

prompt1 BYTE "String : ", 0
prompt2 BYTE "Index      FreqTable", 0

.code
main PROC
    call display_string
    INVOKE Get_frequencies, ADDR target, ADDR freqTable
    call DisplayTable
    exit
main ENDP


display_string proc
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


;-------------------------------------------------------------
Get_frequencies PROC,
    pString:PTR BYTE,   ; points to string
    pTable:PTR DWORD    ; points to frequencey table
; Recieves : pString, pTable
; Returns : freqTable
;-------------------------------------------------------------
    mov esi, pString
    mov edi, pTable

L1: 
    mov eax, 0
    mov al, [esi]
    add esi, 1

    cmp al, 0     ; EOF check
    je THEEND 
    
    shl eax,2        ; multiply by 4
    inc DWORD PTR [edi + eax]    ; inc table[AL]
    jmp L1       ; repeat loop

THEEND:
    ret

Get_frequencies ENDP


;-------------------------------------------------------------
DisplayTable PROC
;
; Display the non-empty entries of the frequency table.
; This procedure was not required, but it makes it easier
; to demonstrate that Get_frequencies works.
;-------------------------------------------------------------

.data
    colonStr BYTE "      ",0
.code
    call Crlf
    mov ecx,LENGTHOF freqTable    ; entries to show
    mov esi,OFFSET freqTable
    mov ebx,0 ; index counter

 L1:    
    mov eax,[esi]   ; get frequency count
    cmp eax,0   ; count = 0?
    jna L2  ; if so, skip to next entry

    mov eax,ebx    ; display the index
    call Writehex
    mov edx, OFFSET colonStr    ; display ": "
    call WriteString
    mov eax, [esi]  ; show frequency count
    call WriteDec
    call Crlf

L2:   
    add esi,TYPE freqTable  ; point to next table entry
    inc ebx ; increment index
    loop L1

    call Crlf

    ret
    DisplayTable ENDP

END main