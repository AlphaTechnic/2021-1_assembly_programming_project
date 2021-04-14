TITLE Exponential Power
;Make a program to calculate the
;value of "X to the power of Y" and "Y to the power of X".
;Store each result into EAX and EBX respectively and
;then print contents of the registers using DumpRegs;
;
;input :
;hw_3.inc
;



INCLUDE irvine32.inc

.data
INCLUDE hw3.inc
outer_loop_count DWORD ?
x_power_y DWORD ?
y_power_x DWORD ?

.code
main PROC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; get x_power_y
	mov edx, 0
	mov x_power_y, 1
	mov ecx, Y

outer_loop:
	mov outer_loop_count, ecx
	mov ecx, X

inner_loop:
	add edx, x_power_y
	loop inner_loop

	mov x_power_y, edx			 ; record the power of x
	mov edx, 0
	mov ecx, outer_loop_count
	loop outer_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; get y_power_x
	mov edx, 0
	mov y_power_x, 1
	mov ecx, X

outer_loop2:
	mov outer_loop_count, ecx
	mov ecx, Y

inner_loop2:
	add edx, y_power_x
	loop inner_loop2

	mov y_power_x, edx
	mov edx, 0
	mov ecx, outer_loop_count	 ; record the power of y
	loop outer_loop2

	mov eax, x_power_y
	mov ebx, y_power_x

	call DumpRegs
main ENDP
END main