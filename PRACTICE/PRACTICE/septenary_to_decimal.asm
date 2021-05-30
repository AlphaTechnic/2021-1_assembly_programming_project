TITLE : sptenary to decimal

include Irvine32.inc

.data
	var1 dw 123h
	decimal db 15 dup ('$')

.code
main proc
	mov ax, var1
	lea edx, decimal
	call SEPTTODEC

	lea dx, decimal
	mov ah, 9 
	int 21h
	mov ah, 4ch
	int 21h
main ENDP
	



;------------------------------------------------------------------
SEPTTODEC PROC 
	mov cx,0 
	mov bx,10

L1: mov dx,0
	div bx ; EAX will store quotient and DX will store remainder
	ADD dl, 30h ; Add 30H in order to make it an ASCII character

	push dx ; temporarily store DX value to stack
	inc cx

	mov cx,15 ; assuming user may input upto 15 digits ie max. length of array
	cmp eax, 9 ; continue dividing EAX till the value stored is greater than 9
	jg L1

	add al, 30h
	mov dl, al ; converting the last remainder to character array and storing in array register DI

L2: pop eax
	inc dl ; increment destination pointer
	MOV dl, al
	LOOP L2
	ret
	MOV AX, DI ; Copy contents from DI to EAX register
SEPTTODEC ENDP

end main