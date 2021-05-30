TITLE : integer summation program

include Irvine32.inc
integercount = 3

.data
	prompt1 byte "Enter a signed integer : ", 0
	prompt2 byte "The sum of the integers is : ", 0
	array dword integercount dup(?)

.code
main proc
	call Clrscr
	mov esi, offset array
	mov ecx, integercount
	call PromptForIntegers
	call ArraySum
	call DisplaySum
main ENDP


;---------------------------------------------------------
PromptForIntegers PROC
	pushad
	mov edx, offset prompt1

L1:
	call WriteString
	call ReadInt
	call Crlf
	mov [esi], eax
	add esi, 4
	loop L1
L2:
	popad
	ret
PromptForIntegers ENDP
;---------------------------------------------------------


;---------------------------------------------------------
ArraySum PROC
	push esi
	push ecx
	mov eax, 0
L1:
	add eax, [esi]
	add esi, 4
	loop L1
L2:
	pop ecx
	pop esi
	ret
ArraySum ENDP
;---------------------------------------------------------


;---------------------------------------------------------
DisplaySum PROC
	push edx
	mov edx, offset prompt2
	call WriteString
	call WriteInt
	call Crlf
	pop edx
	ret
DisplaySum ENDP
;---------------------------------------------------------

END main