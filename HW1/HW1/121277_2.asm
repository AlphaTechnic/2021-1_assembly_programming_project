TITLE Fibonacci Numbers
;Write a program that uses a loop to calculate the nth (n>2) value of the Fibonacci number sequence
;
;input :
;hw_2.inc
;



INCLUDE irvine32.inc
.data
INCLUDE hw2.inc

.code
main PROC
	mov ecx, fib
	dec ecx
	mov eax, 1
	mov ebx, 1
FIBOLOOP:
	add eax, ebx
	mov edx, eax	; Use edx register as temp
	mov eax, ebx
	mov ebx, edx
	
	loop FIBOLOOP
	call DumpRegs
main ENDP
END main