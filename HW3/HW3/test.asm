INCLUDE Irvine32.inc

.data
msgMenu BYTE "---- Boolean Calculator ----------",0dh,0ah
   BYTE "1. x AND y" ,0dh,0ah
   BYTE "2. x OR y" ,0dh,0ah
   BYTE "3. NOT x" ,0dh,0ah
   BYTE "4. x XOR y" ,0dh,0ah
   BYTE "5. Exit program"
   BYTE 0dh,0ah,0dh,0ah,0

msgAND BYTE "Boolean AND",0dh,0ah,0dh,0ah,0
msgOR BYTE "Boolean OR",0dh,0ah,0dh,0ah,0
msgNOT BYTE "Boolean NOT",0dh,0ah,0dh,0ah,0
msgXOR BYTE "Boolean XOR",0dh,0ah,0dh,0ah,0

msgOperand1 BYTE "Input the first 32-bit hexadecimal operand: ",0
msgOperand2 BYTE "Input the second 32-bit hexadecimal operand: ",0
msgResult BYTE "The 32-bit hexadecimal result is: ",0

caseTable BYTE '1'                               ;lookup value
       DWORD _AND_op
EntrySize = ($ - caseTable)
   BYTE '2'
   DWORD _OR_op
   BYTE '3'
   DWORD _NOT_op
   BYTE '4'
   DWORD _XOR_op
NumberOfEntries = ($ - caseTable) / EntrySize

.code
main PROC

   ; Show menu in a loop
Menu:
   mov edx, OFFSET msgMenu
   call WriteString

L1:   
   call ReadChar ;reads to AL
   call IsOpt ;checks AL
   JNZ L1 ;if not opt, try again

   Call ChooseProcedure
   jc Quit
   jmp Menu

Quit:
   exit
main ENDP

;------------------------------------------------
ChooseProcedure PROC
;
; Selects a procedure from the caseTable
; Receives: AL is the number of operation the user entered
; Returns: if CF set, exit; else continue
;------------------------------------------------
   cmp al, '5'
   je LQuit
   mov ebx,OFFSET caseTable
   mov ecx,NumberOfEntries
LStart:
   cmp al,[ebx]
   jne LNext
   call NEAR PTR [ebx + TYPE caseTable]       ;in case label size changes
   jmp LEnd
LNext:
   add ebx,EntrySize
   loop LStart
LQuit:
   stc
LEnd:
   ret
ChooseProcedure ENDP

;------------------------------------------------
_AND_op PROC
;
; Performs a boolean AND operation
; Receives: Nothing
; Returns: Nothing
;------------------------------------------------
   mov edx, OFFSET msgAND
   call PromptHex
   AND eax, ebx
   call PrintRes
   ret
_AND_op ENDP

;------------------------------------------------
_OR_op PROC
;
; Performs a boolean OR operation
; Receives: Nothing
; Returns: Nothing
;------------------------------------------------
   mov edx, OFFSET msgOR
   call PromptHex
   OR eax, ebx
   call PrintRes
   ret

_OR_op ENDP

;------------------------------------------------
_NOT_op PROC
;
; Performs a boolean NOT operation.
; Receives: Nothing
; Returns: Nothing
;------------------------------------------------
   mov edx, OFFSET msgNOT
   call WriteString
   mov edx, OFFSET msgOperand1
   call WriteString
   call ReadHex           ; outputs to eax
   NOT eax
   call PrintRes
   ret
_NOT_op ENDP

;------------------------------------------------
_XOR_op PROC
;
; Performs an Exclusive-OR operation
; Receives: Nothing
; Returns: Nothing
;------------------------------------------------
   mov edx, OFFSET msgXOR
   call PromptHex
   XOR eax, ebx
   call PrintRes
   ret
_XOR_op ENDP

;-----------------------------------------------
IsOpt PROC
;
; Determines whether the character in AL is
; a valid menu option character
; Receives: AL = character
; Returns: ZF=1 if AL contains a valid decimal
; digit; otherwise, ZF=0.
;-----------------------------------------------
   cmp al,'1'
   jb ID1
   cmp al,'5'
   ja ID1
   test ax,0        ; set ZF = 1
ID1: ret
IsOpt ENDP

;-----------------------------------------------
PromptHex PROC
;
; Prompts user to enter two 32bit hex numbers
; Receives: edx - message name from calling program
; Return: EBX = first value, EAX = Second value
;-----------------------------------------------
   call WriteString
   mov edx, OFFSET msgOperand1
   call WriteString
   call ReadHex           ; outputs to eax
   mov ebx, eax
   mov edx, OFFSET msgOperand2
   call WriteString
   call ReadHex
   ret
PromptHex ENDP

;------------------------------------------------
PrintRes PROC
;
; Receives: eax - Value to print
; Returns: Sets CF = 1 to signal end of program
;------------------------------------------------
   mov edx, OFFSET msgResult
   call WriteString
   call WriteHex
   call CrLf
   ret
PrintRes ENDP

END main;