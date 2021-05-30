TITLE Test

INCLUDE irvine32.inc

.data
arrayB BYTE 00h, 10h, 20h

.code
main PROC
	mov ax, word ptr arrayB
	call DumpRegs
main ENDP
END main