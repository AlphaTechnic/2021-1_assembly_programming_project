TITLE : Septenary to Decimal
;Write a program that transforms given positive integer (septenary number) (양의 정수)
;(7 진수) into an decimal number (10 진수). Since we did not learn the input function, you have
;to declare a specific variable var1 for the septenary number. After calculating decimal number,
;then insert that in to the EAX. At the end of your code, use DumpRegs function to check
;the EAX value. The following figure shows you the var1 format. (Other numbers will be used
;instead of 65 when scoring.)

include Irvine32.inc

.data
	var1 dword 0

	MAX_BUF_LEN = 10
	MAX_VALIDINPUT_LEN = 8

.code
main proc
retry:
	mov eax, 0
	mov ebx, 0

	mov edx, offset var1
	mov ecx, MAX_BUF_LEN
	call readstring
	
	cmp eax, 8
	ja retry
	mov ecx, eax

	mov esi, offset var1

L1:
	mov al, byte ptr [esi]	
	cmp al, 30h
	jb retry
	cmp al, 39h
	jbe zone1

	cmp al, 41h
	jb retry
	cmp al, 46h
	jbe zone2

	cmp al, 61h
	jb retry
	cmp al, 66h
	jbe zone3

zone1:
	shl ebx, 4

	sub al, 30h
	and al, 0Fh
	or bl, al

	add esi, 1

	sub ecx, 1
	cmp ecx, 0
	jne L1
	jmp THEEND

zone2:
	shl ebx, 4

	sub al, 37h
	and al, 0Fh
	or bl, al

	add esi, 1

	sub ecx, 1
	cmp ecx, 0
	jne L1
	jmp THEEND

zone3:
	shl ebx, 4

	sub al, 57h
	and al, 0Fh
	or bl, al

	add esi, 1

	sub ecx, 1
	cmp ecx, 0
	jne L1
	jmp THEEND

THEEND:
	exit

main endp
END main