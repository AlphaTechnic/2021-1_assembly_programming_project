TITLE Summing the gaps between Array Values

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
	sub ebx, edx
	add eax, ebx
	add esi, TYPE array1
	loop SUMLOOP
	call DumpRegs
main ENDP
END main