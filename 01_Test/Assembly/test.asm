TITLE TEST code : My first Assembly Code

INCLUDE irvine32.inc

.data
	bigEndian byte 12h, 34h, 56h, 78h
	littleEndian dword ?
.code
main PROC
	push dword ptr bigEndian
	push dword ptr bigEndian + 1
	push dword ptr bigEndian + 2
	push dword ptr bigEndian + 3
	pop littleEndian +3
	pop littleEndian +2
	pop littleEndian +1
	pop littleEndian
	mov eax, littleEndian

	call dumpregs
main ENDP
END main
