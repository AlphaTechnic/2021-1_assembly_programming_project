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

.code
main PROC
	;debug
	mov esi, offset ArrData
	mov bx, word ptr [esi]
	add esi, type ax
	mov ax, word ptr [esi]
	;add esi, type ax
	;mov ax, word ptr [esi]
	;add esi, type ax
	;mov bx, word ptr [esi]

	mov eax, LenData
	ror al, 1 ; CF 보고 짝수인지 홀수인지
	jc L_odd;
	jc L_even;
	rol al, 1 ; 원상복구

L_odd:
	rol al, 1 ; 원상복구

L_even:
	rol al, 1 ; 원상복구

	call dumpregs

main ENDP

END main