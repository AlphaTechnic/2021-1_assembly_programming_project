title : task3
include Irvine32.inc

.data
	prompt1 byte "Is this string palindrome? : ", 0
	yes byte "It's a palindrome!", 0
	nope byte "It's NOT a palindrome ", 0

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

	; esi - start
	; edi - end
	mov esi, offset source
	mov edi, offset source
	add edi, eax
	sub edi, 1


	mov ecx, eax
	cmp ecx, 1 ; 1글자인 경우 palindrom 처리
	je yesEND

	shr ecx, 1


L2:
	mov dl, byte ptr [esi]
	cmp dl, byte ptr [edi]
	jne nopeEND
	loop L2

yesEND:
	mov edx, offset yes
	call writestring
	call crlf
	ret

nopeEND:
	mov edx, offset nope
	call writestring
	call crlf
	ret
main ENDP

end main