title : task2
include Irvine32.inc

.data
	prompt1 byte "Type_A_String_To_Reverse : ", 0
	prompt2 byte "Reversed_String : ", 0
	bye byte "Bye! ", 0
	source byte 200 dup(?)
	target byte 200 dup(?)
.code
main proc
L1:
	mov edx, offset prompt1
	call writestring

	mov edx, offset source
	mov ecx, 200
	call readstring
	cmp eax, 0
	je THEEND
	cmp eax, 40		; 글자 수 40 넘으면 입력 다시 받음
	ja L1

	mov esi, offset source
	mov edi, offset target
	mov ecx, eax
	add ecx, 1
	mov al, 0

L2:
	call read_from_mem_and_display
	jmp L1

THEEND:
	mov edx, offset bye
	call writestring
	call crlf
	ret
main ENDP


;-------------------------------------
read_from_mem_and_display proc
L2:
	mov [edi + ecx - 1], al
	mov al, [esi]
	add esi, 1
	loop L2


	mov edx, offset prompt2
	call writestring

	mov edx, offset target
	call writestring
	call crlf
	ret

read_from_mem_and_display endp
;-------------------------------------


end main