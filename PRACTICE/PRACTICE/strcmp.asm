include Irvine32.inc
.stack 200h

.data

message1 db "Enter the text here: $"
text db 150,151 dup(0)
message2 db 10,13,"Enter the word that you want to find: $"
find db 20,21 dup(0)
yesmessage db 10,13,"Found$"
nomessage db 10,13,"Not found$"

.code
Start:

;Display message and key in strings


mov si, offset text
mov di, offset find

mov dx,offset message1
mov ah,09h
int 21h

mov dx,si
mov ah,0Ah
int 21h

mov ax,seg message2
mov ds,ax

mov dx,offset message2
mov ah,09h
int 21h

mov dx,di
mov ah,0Ah
int 21h

;compare strings
mov bx,00

mov bl,text+1
mov bh,find+1

cmp bl,bh
jne L1

add si,2
add di,2

L2:mov bl,byte ptr[si]
cmp byte ptr[di],bl
jne L1
inc si
inc di
cmp byte ptr[di],"$"
jne L2
mov ah,09h
mov dx,offset yesmessage
int 21h
L1:mov ah,09h
mov dx,offset nomessage
int 21H

mov ax,4c00h
int 21h
end start