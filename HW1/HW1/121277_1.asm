TITLE Summing the gaps between Array Values
;Write a program with a loop and indexed addressing that calculates the sum of all the gaps
;between successive array elements. The array elements are doublewords, sequenced in nondecreasing
;order.
;
;input :
;hw1.inc
;


INCLUDE irvine32.inc
.data
INCLUDE hw1.inc

.code
main PROC
	mov ecx, LENGTHOF array1
	dec ecx
	mov esi, OFFSET array1
	mov eax, 0
SUMLOOP:
	mov edx, [esi]
	mov ebx, [esi+TYPE esi]
	sub ebx, edx				; ebx gets the difference between two adjacent terms
	add eax, ebx				; store result in eax
	add esi, TYPE array1		; tune esi
	loop SUMLOOP
	call DumpRegs
main ENDP
END main