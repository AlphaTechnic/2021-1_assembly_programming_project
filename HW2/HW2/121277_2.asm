TITLE : Multiplication by add and shift

include Irvine32.inc

.data
prompt1 byte "Enter a Multiplier : ", 0
prompt2 byte "Enter a Multiplicand : ", 0
prompt3 byte "Produce : ", 0
prompt4 byte "Bye!", 0

.code
main PROC
	call Clrscr
L1:
	;; write prompt1 and read input
	call crlf				
	mov edx, offset prompt1
	call WriteString
	call Readhex
	jz nxt							; enter key�� �Է¹����� zf�� set�ȴ�.

	push eax
	
	;; write prompt2 and read input
	call crlf
	mov edx, offset prompt2
	call WriteString
	call Readhex
	jz nxt

	push eax
	
	
	;; multiplier in eax, multiplicand in ebx
	pop ebx
	pop eax
	
	call mul_by_add_and_shift

	;; write prompt2 and produce(answer)
	call crlf
	mov edx, offset prompt3
	call WriteString
	call Writehex
	call crlf
	jmp L1							; ����ڰ� ����Ű(enter key)�� �Է��ϱ� ������ loop�� ����.

nxt:
	call crlf
	mov edx, offset prompt4
	call WriteString
	call crlf

	exit
main ENDP


;-------------------------------------------------------------------------------
mul_by_add_and_shift PROC uses ecx ecx
; multiplier�� ���� multiplicand�� ���� add�� shift ������ �̿��Ͽ� ����Ѵ�.
; Receives: eax = multiplier, ebx = multiplicand
; Returns: eax

	mov edx, eax				; edx�� multiplier�� ����
	mov ecx, 32					; produce�� 32bit�� ���� �ʴ´ٴ� �����Ͽ� 32���� loop�� ����.
	mov eax, 0					; eax�� ������ ����� ����

L1:
	shr edx, 1					; lowest bit -> carry flag
								; multiplier�� lowest bit���� �ö󰡸鼭 ����
	jnc	L2						; jump if carry flag == 0
	add eax, ebx				; carry flag == 1�̶��, ebx(multiplicand)�� eax(produce)�� ������Ŵ

L2:
	shl ebx, 1					; multiplicand�� left shift 1
								; multiplier �� digit���� ���� ����� �������� ��ĭ�� 
								; �о� ���� ���� �����ϴ� �۾��̴�.
	loop L1
	ret
mul_by_add_and_shift ENDP
;-------------------------------------------------------------------------------

END main