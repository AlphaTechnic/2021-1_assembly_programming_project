TITLE Get frequencies
;Make a program that functions as a simple Boolean calculator for 32-bit integers. 
;It should display a menu that asks the user to make a selection from the following list:
;   1. x AND y
;   2. x OR y
;   3. NOT x
;   4. X XOR y
;   5. Exit program
;When the user makes a choice, call a procedure that displays the name of the operation about
;to be performed. You must implement this procedure using the ***Table-Driven Selection***
;technique, shown in Section 6.5.4 in textbook.

INCLUDE Irvine32.inc

.data
    target byte "AAEBDCFBBC", 0 ; input data
    freqTable DWORD 256 DUP(0)

    prompt_menu byte   "1. x AND y", 0dh, 0ah,
                   "2. x OR y", 0dh, 0ah,
                   "3. NOT x", 0dh, 0ah,
                   "4. x XOR y", 0dh, 0ah,
                   "5. Exit Program", 0dh, 0ah, 0dh, 0ah, 0
    prompt_choose byte "Choose Calculation Mode : ", 0
    prompt_modechange byte "Do you want to change the mode(Y/N)? : ", 0
    prompt_x byte "Enter x : ", 0
    prompt_y byte "Enter y : ", 0
    prompt_resultAND byte "Result of x AND y : ", 0
    prompt_resultOR byte "Result of x OR y : ", 0
    prompt_resultNOT byte "Result of NOT x : ", 0
    prompt_resultXOR byte "Result of x XOR y : ", 0
    prompt_bye byte "Bye!", 0

    CaseTable dword 1
        dword and_func

        EntrySize = $ - CaseTable
        
        dword 2
        dword or_func
        dword 3
        dword not_func
        dword 4
        dword xor_func
        dword 5
        dword exit_func
    NumberOfEntries = ($ - CaseTable) / EntrySize
    
    YN_MAX_BUF_LEN = 10         ; Y / N answer buf
    YN_MAX_VALID_INPUT_LEN = 1
    answer word 0

    STRING_MAX_BUF_LEN = 10            ; input string buf
	STRING_MAX_VALID_INPUT_LEN = 8
    enter_val dword 0
    

.code
main PROC
    call Clrscr

menu :
    call crlf
    mov edx, offset prompt_menu
    call writestring

L1:
    mov edx, offset prompt_choose
    call writestring
    
    call readdec
    call validation
    jnz L1

    push eax ; mode 저장

exec_fun:
    call choose_func ; returns selected item number in the al register
    call check_answer;
    jc menu

re_exec:
    pop eax
    jmp exec_fun

    exit
main ENDP


;-------------------------------------------------------------------------------
validation proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
    cmp eax, 1
    jb THEEND
    cmp eax, 5
    ja THEEND

    call crlf
    test ax, 0  ; ZF를 set하여 외부로 '정상적인 input'임을 알려줌
THEEND:
    ret
validation endp


;-------------------------------------------------------------------------------
choose_func proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
    mov esi, offset CaseTable
    mov ecx, NumberOfEntries

L1:
    cmp eax, [esi]
    jne nxt

    call near ptr [esi + type CaseTable]
    jmp THEEND

nxt:
    add esi, EntrySize
    loop L1

THEEND:
    ret
choose_func endp


;-------------------------------------------------------------------------------
check_answer proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
    call crlf
    call crlf
L1:
    mov edx, offset prompt_modechange
    call writestring

    mov edx, offset answer
    mov ecx, YN_MAX_BUF_LEN
    call readstring
    
    cmp eax, YN_MAX_VALID_INPUT_LEN
    jne L1

    cmp byte ptr [edx], 59h
    je END_y
    cmp byte ptr [edx], 79h
    je END_y
    cmp byte ptr [edx], 4Eh
    je END_n
    cmp byte ptr [edx], 6Eh
    je END_n
    jmp L1

END_y:
    stc     ; set CF = 1 -> change mode
    ret
END_n:
    call crlf
    clc     ; set CF = 0 -> not change mode
    ret
check_answer endp




;-------------------------------------------------------------------------------
and_func proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
enter_x:
    mov edx, offset prompt_x
    call writestring
    
    call get_val
    jc enter_x
    mov ebx, eax        ; edx : x buffer

enter_y:
    mov edx, offset prompt_y
    call writestring
   
    call get_val
    jc enter_y          ; eax : x buffer

    mov edx, offset prompt_resultAND
    call writestring
    
    ;calculate
    and eax, ebx;
    call writehex

THEEND:
    ret

and_func endp

;-------------------------------------------------------------------------------
or_func proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
 enter_x:
    mov edx, offset prompt_x
    call writestring
    
    call get_val
    jc enter_x
    mov ebx, eax        ; ebx : x buffer

enter_y:
    mov edx, offset prompt_y
    call writestring
   
    call get_val
    jc enter_y          ; eax : x buffer

    mov edx, offset prompt_resultAND
    call writestring
    
    ;calculate
    or eax, ebx;
    call writehex

THEEND:
    ret
or_func endp

;-------------------------------------------------------------------------------
not_func proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
 enter_x:
    mov edx, offset prompt_x
    call writestring
    
    call get_val
    jc enter_x
    mov ebx, eax        ; ebx : x buffer

    mov edx, offset prompt_resultNOT
    call writestring

    ;calculate
    not eax;
    call writehex

THEEND:
    ret
not_func endp

;-------------------------------------------------------------------------------
xor_func proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
 enter_x:
    mov edx, offset prompt_x
    call writestring
    
    call get_val
    jc enter_x
    mov ebx, eax        ; ebx : x buffer

enter_y:
    mov edx, offset prompt_y
    call writestring
   
    call get_val
    jc enter_y          ; eax : x buffer

    mov edx, offset prompt_resultXOR
    call writestring
    
    ;calculate
    xor eax, ebx;
    call writehex

THEEND:
    ret
xor_func endp



;-------------------------------------------------------------------------------
get_val proc uses ebx
; Display the string input by data segment.
;-------------------------------------------------------------------------------
B:
	mov eax, 0
	mov ebx, 0

	mov edx, offset enter_val
	mov ecx, STRING_MAX_BUF_LEN
	call readstring
	
	cmp eax, STRING_MAX_VALID_INPUT_LEN  ;STRING_MAX_VALID_INPUT_LEN = 8
	ja FAIL
    cmp eax, 0
    je FAIL
	mov ecx, eax

	mov esi, offset enter_val

L1:
	mov al, byte ptr [esi]	
	cmp al, 30h
	jb FAIL
	cmp al, 39h
	jbe zone1

	cmp al, 41h
	jb FAIL
	cmp al, 46h
	jbe zone2

	cmp al, 61h
	jb FAIL
	cmp al, 66h
	jbe zone3
    
    jmp FAIL 

zone1:                  ; ascii 30h ~ 39h ('0' ~ '9')
	shl ebx, 4

	sub al, 30h
	and al, 0Fh
	or bl, al

	add esi, 1

	sub ecx, 1
	cmp ecx, 0
	jne L1
	jmp SUCCESS

zone2:                  ; ascii 41h ~ 46h ('A' ~ 'F')
	shl ebx, 4

	sub al, 37h
	and al, 0Fh
	or bl, al

	add esi, 1

	sub ecx, 1
	cmp ecx, 0
	jne L1
	jmp SUCCESS

zone3:                  ; ascii 61h ~ 66h ('a' ~ 'f')
	shl ebx, 4

	sub al, 57h
	and al, 0Fh
	or bl, al

	add esi, 1

	sub ecx, 1
	cmp ecx, 0
	jne L1
	jmp SUCCESS

FAIL:
    stc
	ret
SUCCESS:
    mov eax, ebx
    clc
    ret

get_val endp


;-------------------------------------------------------------------------------
exit_func proc
; Display the string input by data segment.
;-------------------------------------------------------------------------------
    exit
exit_func endp

END main