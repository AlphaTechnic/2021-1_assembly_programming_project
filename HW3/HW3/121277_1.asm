TITLE Summing the gaps between Array Values
;Make a program that sorts number pairs (X, Y). The program should sort all pairs based on X
;values and if two pairs’ X values are same, then sort it based on Y values. For sorting, you
;should differentiate the order on odd index pairs and even index pairs. The odd index pairs should
;be sorted in ascending order for X values and in descending order for Y values in case of same X
;values between pairs. The even index pairs should be sorted in descending order for X values and
;in ascending order for Y values in case of same X values.
;Assume that pairs are given like (0x51, 0x13), (0x1, 0x1), (0x2, 0x3), (0x1, 0x5), (0x51, 0x21), 
;(0x2, 0x1), (0x1, 0x2).
;
;input :
;hw3.inc
;


INCLUDE irvine32.inc
.data
	INCLUDE hw3.inc
	prompt1 byte "Before sort : ", 0
	prompt2 byte "After sort : ", 0
	prompt3 byte "Bye! ", 0
	seperator byte ", ", 0
	odd_iter dword 1 dup(?)
	even_iter dword 1 dup(?)

.code
main PROC
	; prompt1 출력
	mov edx, offset prompt1
	call Writestring
	; data 출력
	mov ecx, LenData
	sub ecx, 1
	mov esi, offset ArrData

	mov eax, [esi]
	call Writehex
	add esi, type ArrData
loop1:
	mov eax, [esi]
	mov edx, offset seperator
	call Writestring
	call Writehex
	add esi, type ArrData
	loop loop1

	call crlf


	mov eax, LenData
	ror eax, 1 ; CF 보고 짝수인지 홀수인지
	jc L_odd;

L_even:
	rol eax, 1 ; 원상복구
	shr eax, 1

	mov odd_iter, eax
	mov even_iter, eax

	jmp L1

L_odd:
	rol eax, 1 ; 원상복구
	add eax, 1
	shr eax, 1
	
	mov ebx, LenData
	sub ebx, eax

	mov odd_iter, eax
	mov even_iter, ebx

	
;-------------------------------------------------------
L1:
	call BubbleSort_oddind
	call BubbleSort_evenind	

THEEND:
	; prompt2 출력
	mov edx, offset prompt2
	call Writestring
	; data 출력
	mov ecx, LenData
	sub ecx, 1
	mov esi, offset ArrData

	mov eax, [esi]
	call Writehex
	add esi, type ArrData
loop2:
	mov eax, [esi]
	mov edx, offset seperator
	call Writestring
	call Writehex
	add esi, type ArrData
	loop loop2

	call crlf

	; prompt3 출력
	mov edx, offset prompt3
	call Writestring

	call crlf

main ENDP


;-----------------------------------------------------
; BubbleSort_oddind - Sort data with odd index. X : ascending, Y : descending
; Recieves - ArrData, odd_iter
; Returns -  nothing
;-----------------------------------------------------
BubbleSort_oddind PROC USES eax ecx esi
	mov ecx, odd_iter
	dec ecx
L1: 
	push ecx ; decrement count by 1
	mov esi, offset ArrData ; point to first value

L_x: ; x 값 비교
	mov ax, word ptr [esi + 2] ; get array value
	cmp ax, word ptr [esi+10] ; compare a pair of values
	jl nxt ; if [ESI+2]<[ESI+10], no exchange
	je L_incaseof_xeq ;
	
	mov eax, [esi]
	xchg eax, [esi+8] ; exchange the pair
	mov [esi], eax
	jmp nxt

L_incaseof_xeq: ; x가 같은 경우 y 정렬은 descending
	mov ax, word ptr [esi] ; get array value
	cmp ax, word ptr [esi+8] ; compare a pair of values
	jg nxt ; if [ESI]>[ESI+8], no exchange

	mov eax, [esi]
	xchg eax, [esi+8] ; exchange the pair
	mov [esi], eax

nxt: ; 다음 비교 대상으로 진행
	add esi, 8 ; move both pointers forward
	loop L_x ; inner loop
	pop ecx ; retrieve out loop count
	loop L1 ; else repeat outer loop

	ret
BubbleSort_oddind ENDP


;-----------------------------------------------------
; BubbleSort_evenind - Sort data with odd index. X : descending, Y : ascending
; Recieves - ArrData, even_iter
; Returns -  nothing
;-----------------------------------------------------
BubbleSort_evenind PROC USES eax ecx esi
	mov ecx, even_iter
	dec ecx
L1: 
	push ecx ; decrement count by 1
	mov esi, offset ArrData ; point to first value
	add esi, 4

L_x: ; x 값 비교
	mov ax, word ptr [esi + 2] ; get array value
	cmp ax, word ptr [esi+10] ; compare a pair of values
	jg nxt ; if [ESI+2]<[ESI+10], no exchange
	je L_incaseof_xeq ;
	
	mov eax, [esi]
	xchg eax, [esi+8] ; exchange the pair
	mov [esi], eax
	jmp nxt

L_incaseof_xeq: ; x가 같은 경우 y 정렬은 ascending
	mov ax, word ptr [esi] ; get array value
	cmp ax, word ptr [esi+8] ; compare a pair of values
	jl nxt ; if [ESI]>[ESI+8], no exchange

	mov eax, [esi]
	xchg eax, [esi+8] ; exchange the pair
	mov [esi], eax

nxt: ; 다음 비교 대상으로 진행
	add esi, 8 ; move both pointers forward
	loop L_x ; inner loop
	pop ecx ; retrieve out loop count
	loop L1 ; else repeat outer loop

	ret
BubbleSort_evenind ENDP

END main