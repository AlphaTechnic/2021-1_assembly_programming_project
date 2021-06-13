TITLE : Word matching
;Make a program that takes a string and a word as inputs from the user and searches
;the word in the string. If a word is in the string, delete it from the string. If it finds the word
;in the string, it prints ��Found��, else it prints ��Not found��. Note that it is not searching for
;the matching characters but searching for the corresponding word. For example, suppose a
;string is ��I am a teacher.�� and a word for search is ��tea��. Now the string has four words; I,
;am, a, teacher. Now the searched word, ��tea�� is not there. So, your program has to say, ��Not
;found��.

include Irvine32.inc

.data
	prompt1 byte "Type_A_String : ", 0
	prompt2 byte "A_Word_for_Search : ", 0
	prompt3 byte "Changed : ", 0
	ans1 byte "Found", 0
	ans2 byte "Not Found", 0

	MAX_BUF_LEN = 45
	MAX_INPUT_LEN = 40
	text byte 45 DUP(?)
	pat byte 45 dup(?)
	lenoftext dword 0
	lenofpat dword 0
	ans_esi dword 0						; text ���� pat�� ��ġ�� �� ���� byte �ּҸ� ����

.code
main proc
L1:
	; prompt1 ���
	mov edx, offset prompt1
	call Writestring

	; text �Է¹���
	mov edx, offset text
	mov ecx, MAX_BUF_LEN				; buf�� ���̸� �����ְ� 45 ������ ����
	call readstring
	jz THEEND							; enter key - ��������

	call Crlf
	cmp eax, MAX_INPUT_LEN				; �Է¹��� text�� ���̰� 40 �ʰ��� ��� �ٽ� �Է��� ����
	ja L1								
	mov lenoftext, eax					; text ���� ����
	
L2:
	; prompt2 ���
	mov edx, offset prompt2
	call Writestring

	; pat �Է¹���
	mov edx, offset pat					
	mov ecx, MAX_BUF_LEN				; buf�� ���̸� �����ְ� 45 ������ ����
	call readstring
	jz THEEND							; enter key - ��������

	call Crlf
	cmp eax, MAX_INPUT_LEN				; �Է¹��� pat�� ���̰� 40 �ʰ��� ��� �ٽ� �Է��� ����
	ja L2
	mov lenofpat, eax					; pattern ���� ����


;-------------------------------------------------------------------------------
; ���ڿ� ��ġ�� �Ǵ��ϴ� �˰����� type�� 3������ �з��ϰ�, ������ �ش��ϴ� proc�� �ۼ� 
; firstfind - text�� ���� ù �κп��� matching�� �Ǵ� ���
;			- [pattern->20h(space)]�� ������ text�� �ִٸ�, true�� �Ǵ��Ѵ�.
; middlefind - text�� �߰� �κп��� matching�� �Ǵ� ���
;			 - [20h->pattern->20h]�� ������ text�� �ִٸ�, true�� �Ǵ��Ѵ�.
; lastfind - text�� ������ �κп��� matching�� �Ǵ� ���
;		   - [20h->pattern]�� ������ text�� �ִٸ�, true�� �Ǵ��Ѵ�.
;-------------------------------------------------------------------------------

	mov ecx, eax						; ecx holds a len(pat)
	mov esi, offset text				; esi - text Ž���뵵
	mov edi, offset pat					; edi - pat Ž���뵵

FIRST:
	call firstfind
	cmp eax, 1							; eax - firstfind �Լ� ������ true / false ���ΰ� �����
	je OK

	cmp byte ptr [esi + 1], 0			; firstfind ���ุ���� text�� ��� ���ڿ� Ž���� ��ģ ��� 
	je FAIL

	mov edx, lenoftext
	sub edx, ecx						; edx holds len(text) - len(pat) : loop counter�� ����ϰ� ��

MIDDLE:
	call middlefind						
	cmp eax, 1							; eax - middlefind �Լ� ������ true / false ���ΰ� �����
	je OK

	add esi, 1							; esi ����
	sub edx, 1							; edx(loop counter) 1 ����
	cmp edx, 0
	jne MIDDLE

LAST:
	sub esi, 1
	call lastfind
	cmp eax, 1
	je OK

	jmp FAIL
;-------------------------------------------------------------------------------

OK:
	; ans1 ���
	mov edx, offset ans1
	call Writestring
	call crlf
	call crlf

	; changed prompt ���
	mov edx, offset prompt3
	call Writestring


;-------------------------------------------------------------------------------
; text���� ��ġ�� pat�� �����Ѵ�.
; ans_esi�� ��ġ�� char�� ans_esi - len(pat) ��ġ�� �ű��.
; ans_esi�� 1 �÷�, ���� �۾��� �ݺ��Ѵ�. (text�� ���� ��ġ�� null char�� �ű� ������)
;-------------------------------------------------------------------------------
	mov edi, ans_esi	
	mov esi, edi
	
	mov ebx, [lenofpat]
	sub esi, ebx						; esi holds ans_esi - len(pat)
										; edi holds ans_esi

MOVE_CHAR:
	mov al, byte ptr [edi]
	mov byte ptr [esi], al
	add esi, 1
	add edi, 1
	
	cmp byte ptr [edi], 0				; edi�� ����Ű�� ���� null char�� �Ǹ� loop ����
	jne MOVE_CHAR
L3:
	mov al, byte ptr [edi]
	mov byte ptr [esi], al				; null char���� �Ű��ش�.


	; ������ �Ϸ��� text ���
	mov edx, offset text
	call Writestring
	call crlf
	call crlf 

	jmp L1								; �ٽ� ������� �Է��� ��ٸ���.


FAIL:
	; ans2 ���
	mov edx, offset ans2
	call Writestring
	call crlf
	call crlf 

	; changed prompt �� text(��ȭ ����) ���
	mov edx, offset prompt3
	call Writestring
	mov edx, offset text
	call Writestring
	call crlf
	call crlf 

	jmp L1								; �ٽ� ������� �Է��� ��ٸ���.


THEEND:
	exit
main ENDP



;-------------------------------------------------------------------------------
; firstfind - text�� ���� ù �κп��� matching�� �Ǵ� ���
;			- [pattern->20h(space)]�� ������ text�� �ִٸ�, true�� �Ǵ��Ѵ�.
; Recieves - esi(text�� ���� ù �κ�), edi(pat�� ���� ù�κ�)
; Returns -  eax (��Ī ���� ���� true / false)
;-------------------------------------------------------------------------------
firstfind PROC
	push esi
	push edi
	push ecx
	
L1:
	mov bx, 00
	mov bh, byte ptr [esi]				; bh�� bl�� char�� �Űܿ� ��
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl							; bh�� bl�� �ٸ��ٸ� false
	jne F		
	cmp ecx, 0							; ����1. pattern in text
	je nxt
	loop L1

nxt:
	cmp byte ptr [esi], 20h				; ����2. pattern->20h(space)�� ����
	je T
nxt2:
	cmp byte ptr [esi], 0				; ����2. Ȥ�� null char�� �ִ� ���
	je T

F:
	mov eax, 0							; �Լ� ������ ����� eax�� ���

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1							; �Լ� ������ ����� eax�� ���
	mov ans_esi, esi					; pattern�� ��Ī�� �κ� ���� �ڸ��� ans_esi�� ���

	pop ecx
	pop edi
	pop esi
	ret
firstfind ENDP
;---------------------------------------------------------


;-------------------------------------------------------------------------------
; middlefind - text�� �߰� �κп��� matching�� �Ǵ� ���
;			 - [20h->pattern->20h]�� ������ text�� �ִٸ�, true�� �Ǵ��Ѵ�.
; Recieves - esi(text�� �߰� ���), edi(pat�� ���� ù�κ�)
; Returns -  eax (��Ī ���� ���� true / false)
;-------------------------------------------------------------------------------
middlefind PROC
	push esi
	push edi
	push ecx

	cmp byte ptr [esi], 20h				; ����1. esi ��ġ�� 20h(space)�� ���� ��
	jne F
	add esi, 1
	
L1:
	mov bx, 00							
	mov bh, byte ptr [esi]				
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl							; ����2. pattern in text
	jne F
	loop L1

nxt:
	cmp byte ptr [esi], 20h				; ����3. pattern �ڿ� 20h(space)
	je T

F:
	mov eax, 0							; �Լ� ������ ����� eax�� ���

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1							; �Լ� ������ ����� eax�� ���
	mov ans_esi, esi					; pattern�� ��Ī�� �κ� ���� �ڸ��� ans_esi�� ���

	pop ecx
	pop edi
	pop esi
	ret
middlefind ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
; lastfind - text�� ������ �κп��� matching�� �Ǵ� ���
;		   - [20h->pattern]�� ������ text�� �ִٸ�, true�� �Ǵ��Ѵ�.
; Recieves - esi(text - len(pat) - 1), edi(pat�� ���� ù�κ�)
; Returns -  eax (��Ī ���� ���� true / false)
;-------------------------------------------------------------------------------
lastfind PROC
	push esi
	push edi
	push ecx

	cmp byte ptr [esi], 20h				; ����1. esi ��ġ�� 20h(space)�� ���� ��
	jne F
	add esi, 1
	
L1:
	mov bx, 00
	mov bh, byte ptr [esi]
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl							; ����2. pattern in text
	jne F
	cmp ecx, 1
	je T
	loop L1


F:
	mov eax, 0							; �Լ� ������ ����� eax�� ���

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1							; �Լ� ������ ����� eax�� ���
	mov ans_esi, esi					; pattern�� ��Ī�� �κ� ���� �ڸ��� ans_esi�� ���

	pop ecx
	pop edi
	pop esi
	ret
lastfind ENDP
;---------------------------------------------------------

END main
