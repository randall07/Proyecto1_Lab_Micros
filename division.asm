
segment .data

segment .bss

segment .text

global _start

_start:

        xor edx, edx
        mov eax, 860h
        mov ebx, 540h    ; en EBX se guardan los 100 
        div ebx          ; Divide EAX (250) por EBX (100), y lo guarda en EDX

	break1:
	mov eax,1
	mov ebx,0
	int 0x80
