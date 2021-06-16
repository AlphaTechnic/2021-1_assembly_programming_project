title : task1
include Irvine32.inc

.data
	prompt1 byte "Input : ", 0
	star byte "*", 0
.code
main proc
L1:
	mov edx, offset prompt1
	call writestring

	call readdec
	mov ecx, eax
	add ecx, 1
	
	mov eax, 0
	mov ebx, 1

L2:	
	mov edx, offset star
	call writestring

	add eax, 1
	cmp eax, ebx
	jb L2

	call crlf
	mov eax, 0
	add ebx, 1
	cmp ebx, ecx
	je THEEND
	jb L2


THEEND:
	ret
main ENDP

end main