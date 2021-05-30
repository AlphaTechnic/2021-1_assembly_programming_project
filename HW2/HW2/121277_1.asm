TITLE : septenary to decimal

include Irvine32.inc

.data
var1 byte "34123456", 0

.code
main proc
	mov esi, offset var1
	movzx ebx, byte ptr [esi]	;esi가 var1의 head부터 tail까지를 하나씩 가리키도록
	sub ebx, 30h				;char to int number (ascii of '0' is 30h)
	mov edx, 0					;edx에 계산 결과를 누적한다

	mov ecx, lengthof var1		;ecx for loop counter
	sub ecx, 2

L1:
	push edx					;현재까지의 계산 결과를 push
	call accumul_pow7

	pop ebx						
	add edx, ebx				;현재까지의 계산 결과에 새롭게 계산된 결과를 누적

	add esi, type var1			;esi가 next digit을 가리키도록 함
	movzx ebx, byte ptr [esi]
	sub ebx, 30h				;char to int number (ascii of '0' is 30h)

	sub ecx, 1					;loop counter handling
	cmp ecx, -1
	jnz L1

	mov eax, edx				;edx에 기록된 최종 계산결과를 eax에 저장
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