TITLE TEST code : My first Assembly Code

INCLUDE irvine32.inc

.code
main PROC
	mov eax, 20000h
	mov ebx, 10000h
	add eax, 5000h
	sub eax, ebx
	call DumpRegs
main ENDP
END main