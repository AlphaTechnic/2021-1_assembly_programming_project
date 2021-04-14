TITLE Copy a String in Re verse Order
;Write a program with a loop that copies a string from source to target , reversing the
;character order in the process , and print the target string to the console.
;
;input :
;hw4.inc
;


INCLUDE irvine32.inc
.data
INCLUDE hw4.inc

.code
main PROC
	mov esi, OFFSET source
	mov edi, OFFSET target
	mov ecx, SIZEOF source
	mov al, 0

L :
	mov [edi + ecx - 1], al
	mov al, [esi]
	inc esi
	loop L
	
	call DumpRegs

	mov edx, OFFSET target
	call WriteString
main ENDP
END main