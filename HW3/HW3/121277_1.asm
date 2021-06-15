TITLE Summing the gaps between Array Values
;Make a program that sorts number pairs (X, Y). The program should sort all pairs based on X
;values and if two pairs�� X values are same, then sort it based on Y values. For sorting, you
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
	seperator byte ", ", 0		; register�� ������ ������ �� ������
	odd_iter dword 1 dup(?)		; Ȧ�� ��° index�� �ִ� data ����
	even_iter dword 1 dup(?)	; ¦�� ��° index�� �ִ� data ����

.code
main PROC 
prompt1_print:
	call Clrscr
	mov edx, offset prompt1
	call Writestring

data_print:
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

	; ¦�� index �ڷᰳ���� �����, Ȧ�� index �ڷᰳ���� ����� ���� 
	mov eax, LenData
	ror eax, 1					; CF ���� ¦������ Ȧ������ ����
	jc L_odd;

L_even:
	rol eax, 1					; ror ���󺹱�
	shr eax, 1					
								
	mov odd_iter, eax			; Ȧ��index data ���� = LenData / 2
	mov even_iter, eax			; ¦��index data ���� = LenData / 2

	jmp L1

L_odd:
	rol eax, 1					; ror ���󺹱�
	add eax, 1
	shr eax, 1
	
	mov ebx, LenData			
	sub ebx, eax

	mov odd_iter, eax			; Ȧ��index data ���� = LenData / 2
	mov even_iter, ebx			; ¦��index data ���� = (LenData + 1) / 2

	
;-------------------------------------------------------------------------------
L1:
	call BubbleSort_oddind
	call BubbleSort_evenind	

THEEND:
	; prompt2 ���
	mov edx, offset prompt2
	call Writestring
	; data ���
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

	; prompt3 ���
	mov edx, offset prompt3
	call Writestring

	call crlf
	exit

main ENDP


;-------------------------------------------------------------------------------
; BubbleSort_oddind - Sort data with odd index. X : ascending, Y : descending
; Recieves - ArrData, odd_iter
; Returns -  nothing
;-------------------------------------------------------------------------------
BubbleSort_oddind proc uses eax ecx esi
	mov ecx, odd_iter
	sub ecx, 1
L1: 
	push ecx					; loop counter, decrement count by 1
	mov esi, offset ArrData		; point to first value

L_x: ; x �� ���Ͽ� ascending ����, 8 byte �������� ����Ǿ� ����
	mov ax, word ptr [esi+ 2]	; get array value
	cmp ax, word ptr [esi+10]	; compare a pair of values
	jl nxt						; if [ESI+2]<[ESI+10], no exchange
	je L_incaseof_xeq ;
	
	mov eax, [esi]
	xchg eax, [esi+8]			; exchange the pair
	mov [esi], eax
	jmp nxt

L_incaseof_xeq: ; x�� ���� ��� y ������ descending
	mov ax, word ptr [esi]		; get array value
	cmp ax, word ptr [esi+8]	; compare a pair of values
	jg nxt						; if [ESI]>[ESI+8], no exchange

	mov eax, [esi]
	xchg eax, [esi+8]			; exchange the pair
	mov [esi], eax

nxt:							; ���� �� ������� ����
	add esi, 8					; move both pointers forward
	loop L_x					; inner loop
	pop ecx						; retrieve out loop count
	loop L1						; else repeat outer loop

	ret
BubbleSort_oddind ENDP


;-------------------------------------------------------------------------------
; BubbleSort_evenind - Sort data with odd index. X : descending, Y : ascending
; Recieves - ArrData, even_iter
; Returns -  nothing
;-------------------------------------------------------------------------------
BubbleSort_evenind proc uses eax ecx esi
	mov ecx, even_iter
	sub ecx, 1
L1: 
	push ecx					; loop counter, decrement count by 1
	mov esi, offset ArrData ; point to first value
	add esi, 4

L_x: ; x �� ���Ͽ� descending ����, 8 byte �������� ����Ǿ� ����
	mov ax, word ptr [esi+ 2]	; get array value
	cmp ax, word ptr [esi+10]	; compare a pair of values
	jg nxt						; if [ESI+2]>[ESI+10], no exchange
	je L_incaseof_xeq
	
	mov eax, [esi]
	xchg eax, [esi+8]			; exchange the pair
	mov [esi], eax
	jmp nxt

L_incaseof_xeq: ; x�� ���� ��� y ������ ascending
	mov ax, word ptr [esi]		; get array value
	cmp ax, word ptr [esi+8]	; compare a pair of values
	jl nxt						; if [ESI]<[ESI+8], no exchange

	mov eax, [esi]
	xchg eax, [esi+8]			; exchange the pair
	mov [esi], eax

nxt:							; ���� �� ������� ����
	add esi, 8					; move both pointers forward
	loop L_x					; inner loop
	pop ecx						; retrieve out loop count
	loop L1						; else repeat outer loop

	ret
BubbleSort_evenind ENDP

END main