TITLE : septenary to decimal

include Irvine32.inc

.data
var1 byte "34123456", 0

.code
main proc
	mov esi, offset var1
	movzx ebx, byte ptr [esi]	;esi�� var1�� head���� tail������ �ϳ��� ����Ű����
	sub ebx, 30h				;char to int number (ascii of '0' is 30h)
	mov edx, 0					;edx�� ��� ����� �����Ѵ�

	mov ecx, lengthof var1		;ecx for loop counter
	sub ecx, 2

L1:
	push edx					;��������� ��� ����� push
	call accumul_pow7

	pop ebx						
	add edx, ebx				;��������� ��� ����� ���Ӱ� ���� ����� ����

	add esi, type var1			;esi�� next digit�� ����Ű���� ��
	movzx ebx, byte ptr [esi]
	sub ebx, 30h				;char to int number (ascii of '0' is 30h)

	sub ecx, 1					;loop counter handling
	cmp ecx, -1
	jnz L1

	mov eax, edx				;edx�� ��ϵ� ���� ������� eax�� ����
	call dumpregs
main ENDP


;---------------------------------------------------------
accumul_pow7 PROC
	push ecx
	
	mov eax, 1
	mov edx, 7

L1:

	cmp ecx, 0
	jz L2

	mov edx, 7
	mul edx
	loop L1

L2:
	mul ebx
	add edx, eax

	pop ecx
	ret
accumul_pow7 ENDP
;---------------------------------------------------------

END main