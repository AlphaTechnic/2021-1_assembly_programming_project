
include Irvine32.inc

.data
MAX = 80                     ;max chars to read
stringIn BYTE MAX+1 DUP (?)  ;room for null

.code
main PROC
      mov  edx,OFFSET stringIn
      mov  ecx,MAX            ;buffer size - 1
      call ReadString

    call dumpregs
	exit
main ENDP
END main