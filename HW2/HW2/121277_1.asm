TITLE : Septenary to Decimal

include Irvine32.inc

.data
var1 byte "65", 0

.code
main proc
	mov esi, offset var1
	movzx ebx, byte ptr [esi]	; esi가 var1의 head부터 tail까지를 하나씩 가리키도록
	sub ebx, 30h				; char to int number (ascii of '0' is 30h)
	mov edx, 0					; edx에 계산 결과를 누적한다

	mov ecx, lengthof var1		; ecx for loop counter
	sub ecx, 2

L1:
	call accumul_pow7

	add esi, type var1			; esi가 next digit을 가리키도록 함
	movzx ebx, byte ptr [esi]
	sub ebx, 30h				; char to int number (ascii of '0' is 30h)

	sub ecx, 1					; loop counter handling
	cmp ecx, -1
	jnz L1
nxt:
	mov eax, edx				; edx에 기록된 최종 계산결과를 eax에 저장
	call dumpregs
main ENDP


;-------------------------------------------------------------------------------
accumul_pow7 PROC
;
; digit과 digit의 자릿수에 맞는 7의 거듭제곱을 곱한다
; Recieves : ebx - digit의 값
; Returns : edx - 계산 결과의 누적합
;-------------------------------------------------------------------------------
	push edx					; 현재까지의 계산 결과를 push
	push ecx
	
	mov eax, 1
	mov edx, 7

L1:								; digit의 자리수에 맞는 7의 거듭제곱을 eax에 생성
	cmp ecx, 0
	jz L2

	mov edx, 7
	mul edx
	loop L1

L2:								; L1 루프에서의 계산 결과를 digit 값과 곱함
	mul ebx						
	mov edx, eax

	pop ecx
	pop ebx						
	add edx, ebx				; 현재까지의 계산 결과에 새롭게 계산된 결과를 edx에 누적
	ret
accumul_pow7 ENDP
;-------------------------------------------------------------------------------

END main