include Irvine32.inc


.data

prompt1 byte "Type_A_String : ", 0
prompt2 byte "A_Word_for_Search : ", 0
prompt3 byte "Changed : ", 0
ans1 byte "Found", 0
ans2 byte "Not Found", 0

MAX = 40
text byte 45 DUP(?)
find byte 45 dup(?)
lenoftext dword 0
lenoffind dword 0
ans_esi dword 0

.code
main proc
L0:
	; msg1 출력
	mov edx, offset prompt1
	call Writestring

	; text 입력받음
	mov edx, offset text
	mov ecx, 50
	call readstring
	call Crlf
	mov lenoftext, eax
	
	cmp eax, 0
	je theend


	; msg2 출력
	mov edx, offset prompt2
	call Writestring

	; find 입력받음
	mov edx, offset find
	mov ecx, 50
	call readstring
	call Crlf
	mov lenoffind, eax

	cmp eax, 0
	je theend

	mov ecx, eax
	mov esi, offset text
	mov edi, offset find

	call firstfind
	cmp eax, 1
	je ok

	mov edx, lenoftext
	sub edx, ecx       ;edx holds len(text) - len(find)


L1:
	call middlefind
	cmp eax, 1
	je ok

	add esi, 1
	sub edx, 1
	cmp edx, 0
	jne L1


	sub esi, 1
	call lastfind
	cmp eax, 1
	je ok


	jmp fail


ok:
	; ans1 출력
	mov edx, offset ans1
	call Writestring
	call crlf
	call crlf

	; changed 출력
	mov edx, offset prompt3
	call Writestring


	mov edi, ans_esi	
	mov esi, edi
	
	mov ebx, [lenoffind]
	sub esi, ebx
	add edi, 1

L2:
	mov al, byte ptr [edi]
	mov byte ptr [esi], al
	add esi, 1
	add edi, 1
	
	cmp byte ptr [edi], 0
	jne L2
L3:
	mov al, byte ptr [edi]
	mov byte ptr [esi], al


	; 삭제를 완료한 text 출력
	mov edx, offset text
	call Writestring
	call crlf
	call crlf 

	jmp L0

fail:
	; ans2 출력
	mov edx, offset ans2
	call Writestring
	call crlf
	call crlf 

	mov edx, offset prompt3
	call Writestring
	mov edx, offset text
	call Writestring
	call crlf
	call crlf 

	jmp L0


theend:
	exit
main ENDP
;---------------------------------------------------------
firstfind PROC
	push esi
	push edi
	push ecx
	
L1:
	mov bx, 00
	mov bh, byte ptr [esi]
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl
	jne F
	cmp ecx, 0
	je nxt
	loop L1

nxt:
	cmp byte ptr [esi], 20h
	je T



F:
	mov eax, 0

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1
	mov ans_esi, esi

	pop ecx
	pop edi
	pop esi
	ret
firstfind ENDP
;---------------------------------------------------------


;---------------------------------------------------------
middlefind PROC
	push esi
	push edi
	push ecx

	cmp byte ptr [esi], 20h
	jne F
	add esi, 1
	
L1:
	mov bx, 00
	mov bh, byte ptr [esi]
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl
	jne F
	cmp ecx, 0
	je nxt
	loop L1

nxt:
	cmp byte ptr [esi], 20h
	je T



F:
	mov eax, 0

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1
	mov ans_esi, esi

	pop ecx
	pop edi
	pop esi
	ret
middlefind ENDP
;---------------------------------------------------------


;---------------------------------------------------------
lastfind PROC
	push esi
	push edi
	push ecx

	cmp byte ptr [esi], 20h
	jne F
	add esi, 1
	
L1:
	mov bx, 00
	mov bh, byte ptr [esi]
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl
	jne F
	cmp ecx, 1
	je T
	loop L1


F:
	mov eax, 0

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1
	mov ans_esi, esi

	pop ecx
	pop edi
	pop esi
	ret
lastfind ENDP
;---------------------------------------------------------

END main