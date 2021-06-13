TITLE : Word matching
;Make a program that takes a string and a word as inputs from the user and searches
;the word in the string. If a word is in the string, delete it from the string. If it finds the word
;in the string, it prints “Found”, else it prints “Not found”. Note that it is not searching for
;the matching characters but searching for the corresponding word. For example, suppose a
;string is “I am a teacher.” and a word for search is “tea”. Now the string has four words; I,
;am, a, teacher. Now the searched word, “tea” is not there. So, your program has to say, “Not
;found”.

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
	ans_esi dword 0						; text 내에 pat이 위치한 그 다음 byte 주소를 저장

.code
main proc
L1:
	; prompt1 출력
	mov edx, offset prompt1
	call Writestring

	; text 입력받음
	mov edx, offset text
	mov ecx, MAX_BUF_LEN				; buf의 길이를 여유있게 45 정도로 설정
	call readstring
	jz THEEND							; enter key - 종료조건

	call Crlf
	cmp eax, MAX_INPUT_LEN				; 입력받은 text의 길이가 40 초과인 경우 다시 입력을 받음
	ja L1								
	mov lenoftext, eax					; text 길이 저장
	
L2:
	; prompt2 출력
	mov edx, offset prompt2
	call Writestring

	; pat 입력받음
	mov edx, offset pat					
	mov ecx, MAX_BUF_LEN				; buf의 길이를 여유있게 45 정도로 설정
	call readstring
	jz THEEND							; enter key - 종료조건

	call Crlf
	cmp eax, MAX_INPUT_LEN				; 입력받은 pat의 길이가 40 초과인 경우 다시 입력을 받음
	ja L2
	mov lenofpat, eax					; pattern 길이 저장


;-------------------------------------------------------------------------------
; 문자열 일치를 판단하는 알고리즘의 type을 3가지로 분류하고, 각각에 해당하는 proc을 작성 
; firstfind - text의 가장 첫 부분에서 matching이 되는 경우
;			- [pattern->20h(space)]의 구조가 text에 있다면, true로 판단한다.
; middlefind - text의 중간 부분에서 matching이 되는 경우
;			 - [20h->pattern->20h]의 구조가 text에 있다면, true로 판단한다.
; lastfind - text의 마지막 부분에서 matching이 되는 경우
;		   - [20h->pattern]의 구조가 text에 있다면, true로 판단한다.
;-------------------------------------------------------------------------------

	mov ecx, eax						; ecx holds a len(pat)
	mov esi, offset text				; esi - text 탐색용도
	mov edi, offset pat					; edi - pat 탐색용도

FIRST:
	call firstfind
	cmp eax, 1							; eax - firstfind 함수 수행의 true / false 여부가 저장됨
	je OK

	cmp byte ptr [esi + 1], 0			; firstfind 수행만으로 text의 모든 문자열 탐색을 마친 경우 
	je FAIL

	mov edx, lenoftext
	sub edx, ecx						; edx holds len(text) - len(pat) : loop counter로 기능하게 함

MIDDLE:
	call middlefind						
	cmp eax, 1							; eax - middlefind 함수 수행의 true / false 여부가 저장됨
	je OK

	add esi, 1							; esi 증가
	sub edx, 1							; edx(loop counter) 1 감소
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
	; ans1 출력
	mov edx, offset ans1
	call Writestring
	call crlf
	call crlf

	; changed prompt 출력
	mov edx, offset prompt3
	call Writestring


;-------------------------------------------------------------------------------
; text내에 위치한 pat을 삭제한다.
; ans_esi에 위치한 char을 ans_esi - len(pat) 위치에 옮긴다.
; ans_esi를 1 올려, 같은 작업을 반복한다. (text의 끝에 위치한 null char를 옮길 때까지)
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
	
	cmp byte ptr [edi], 0				; edi가 가리키는 값이 null char이 되면 loop 종료
	jne MOVE_CHAR
L3:
	mov al, byte ptr [edi]
	mov byte ptr [esi], al				; null char까지 옮겨준다.


	; 삭제를 완료한 text 출력
	mov edx, offset text
	call Writestring
	call crlf
	call crlf 

	jmp L1								; 다시 사용자의 입력을 기다린다.


FAIL:
	; ans2 출력
	mov edx, offset ans2
	call Writestring
	call crlf
	call crlf 

	; changed prompt 와 text(변화 없음) 출력
	mov edx, offset prompt3
	call Writestring
	mov edx, offset text
	call Writestring
	call crlf
	call crlf 

	jmp L1								; 다시 사용자의 입력을 기다린다.


THEEND:
	exit
main ENDP



;-------------------------------------------------------------------------------
; firstfind - text의 가장 첫 부분에서 matching이 되는 경우
;			- [pattern->20h(space)]의 구조가 text에 있다면, true로 판단한다.
; Recieves - esi(text의 가장 첫 부분), edi(pat의 가장 첫부분)
; Returns -  eax (매칭 성공 여부 true / false)
;-------------------------------------------------------------------------------
firstfind PROC
	push esi
	push edi
	push ecx
	
L1:
	mov bx, 00
	mov bh, byte ptr [esi]				; bh와 bl에 char를 옮겨와 비교
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl							; bh와 bl이 다르다면 false
	jne F		
	cmp ecx, 0							; 조건1. pattern in text
	je nxt
	loop L1

nxt:
	cmp byte ptr [esi], 20h				; 조건2. pattern->20h(space)의 구조
	je T
nxt2:
	cmp byte ptr [esi], 0				; 조건2. 혹은 null char가 있는 경우
	je T

F:
	mov eax, 0							; 함수 수행의 결과를 eax에 기록

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1							; 함수 수행의 결과를 eax에 기록
	mov ans_esi, esi					; pattern이 매칭된 부분 다음 자리를 ans_esi에 기록

	pop ecx
	pop edi
	pop esi
	ret
firstfind ENDP
;---------------------------------------------------------


;-------------------------------------------------------------------------------
; middlefind - text의 중간 부분에서 matching이 되는 경우
;			 - [20h->pattern->20h]의 구조가 text에 있다면, true로 판단한다.
; Recieves - esi(text의 중간 어딘가), edi(pat의 가장 첫부분)
; Returns -  eax (매칭 성공 여부 true / false)
;-------------------------------------------------------------------------------
middlefind PROC
	push esi
	push edi
	push ecx

	cmp byte ptr [esi], 20h				; 조건1. esi 위치에 20h(space)가 있을 것
	jne F
	add esi, 1
	
L1:
	mov bx, 00							
	mov bh, byte ptr [esi]				
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl							; 조건2. pattern in text
	jne F
	loop L1

nxt:
	cmp byte ptr [esi], 20h				; 조건3. pattern 뒤에 20h(space)
	je T

F:
	mov eax, 0							; 함수 수행의 결과를 eax에 기록

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1							; 함수 수행의 결과를 eax에 기록
	mov ans_esi, esi					; pattern이 매칭된 부분 다음 자리를 ans_esi에 기록

	pop ecx
	pop edi
	pop esi
	ret
middlefind ENDP
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
; lastfind - text의 마지막 부분에서 matching이 되는 경우
;		   - [20h->pattern]의 구조가 text에 있다면, true로 판단한다.
; Recieves - esi(text - len(pat) - 1), edi(pat의 가장 첫부분)
; Returns -  eax (매칭 성공 여부 true / false)
;-------------------------------------------------------------------------------
lastfind PROC
	push esi
	push edi
	push ecx

	cmp byte ptr [esi], 20h				; 조건1. esi 위치에 20h(space)가 있을 것
	jne F
	add esi, 1
	
L1:
	mov bx, 00
	mov bh, byte ptr [esi]
	mov bl, byte ptr [edi]
	add esi, 1
	add edi, 1
	
	cmp bh, bl							; 조건2. pattern in text
	jne F
	cmp ecx, 1
	je T
	loop L1


F:
	mov eax, 0							; 함수 수행의 결과를 eax에 기록

	pop ecx
	pop edi
	pop esi
	ret
T:
	mov eax, 1							; 함수 수행의 결과를 eax에 기록
	mov ans_esi, esi					; pattern이 매칭된 부분 다음 자리를 ans_esi에 기록

	pop ecx
	pop edi
	pop esi
	ret
lastfind ENDP
;---------------------------------------------------------

END main
