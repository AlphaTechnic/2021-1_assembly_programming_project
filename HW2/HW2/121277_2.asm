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
	jz nxt							; enter key를 입력받으면 zf가 set된다.

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
	jmp L1							; 사용자가 종료키(enter key)를 입력하기 전까지 loop를 돈다.

nxt:
	call crlf
	mov edx, offset prompt4
	call WriteString
	call crlf

	exit
main ENDP


;-------------------------------------------------------------------------------
mul_by_add_and_shift PROC uses ecx ecx
; multiplier의 값과 multiplicand의 곱을 add와 shift 연산을 이용하여 계산한다.
; Receives: eax = multiplier, ebx = multiplicand
; Returns: eax

	mov edx, eax				; edx에 multiplier값 저장
	mov ecx, 32					; produce는 32bit를 넘지 않는다는 가정하에 32번의 loop을 돈다.
	mov eax, 0					; eax에 곱셉의 결과를 저장

L1:
	shr edx, 1					; lowest bit -> carry flag
								; multiplier의 lowest bit부터 올라가면서 접근
	jnc	L2						; jump if carry flag == 0
	add eax, ebx				; carry flag == 1이라면, ebx(multiplicand)를 eax(produce)에 누적시킴

L2:
	shl ebx, 1					; multiplicand를 left shift 1
								; multiplier 각 digit과의 곱셈 결과를 왼쪽으로 한칸씩 
								; 밀어 쓰는 것을 재현하는 작업이다.
	loop L1
	ret
mul_by_add_and_shift ENDP
;-------------------------------------------------------------------------------

END main