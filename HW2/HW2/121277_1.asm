TITLE : Septenary to Decimal

include Irvine32.inc

.data
var1 byte "65", 0

.code
main proc
	mov esi, offset var1
	movzx ebx, byte ptr [esi]	; esi�� var1�� head���� tail������ �ϳ��� ����Ű����
	sub ebx, 30h				; char to int number (ascii of '0' is 30h)
	mov edx, 0					; edx�� ��� ����� �����Ѵ�

	mov ecx, lengthof var1		; ecx for loop counter
	sub ecx, 2

L1:
	call accumul_pow7

	add esi, type var1			; esi�� next digit�� ����Ű���� ��
	movzx ebx, byte ptr [esi]
	sub ebx, 30h				; char to int number (ascii of '0' is 30h)

	sub ecx, 1					; loop counter handling
	cmp ecx, -1
	jnz L1
nxt:
	mov eax, edx				; edx�� ��ϵ� ���� ������� eax�� ����
	call dumpregs
main ENDP


;-------------------------------------------------------------------------------
accumul_pow7 PROC
;
; digit�� digit�� �ڸ����� �´� 7�� �ŵ������� ���Ѵ�
; Recieves : ebx - digit�� ��
; Returns : edx - ��� ����� ������
;-------------------------------------------------------------------------------
	push edx					; ��������� ��� ����� push
	push ecx
	
	mov eax, 1
	mov edx, 7

L1:								; digit�� �ڸ����� �´� 7�� �ŵ������� eax�� ����
	cmp ecx, 0
	jz L2

	mov edx, 7
	mul edx
	loop L1

L2:								; L1 ���������� ��� ����� digit ���� ����
	mul ebx						
	mov edx, eax

	pop ecx
	pop ebx						
	add edx, ebx				; ��������� ��� ����� ���Ӱ� ���� ����� edx�� ����
	ret
accumul_pow7 ENDP
;-------------------------------------------------------------------------------

END main