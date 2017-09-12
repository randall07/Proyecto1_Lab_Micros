section .data
nombre_archivo: dw '/sys/class/block/sda/size'
tam_nombre_archivo: equ $-nombre_archivo

section .bss
contenido_archivo: resb 10
y: resb 100
section .text
	global _start

_start:
	
	mov ebx,nombre_archivo 
	mov eax,5 ; utilizado para abrir el archivo, se hace llamada al sistema eax=5
	mov ecx,0
	;mov edx,y
	int 80h

	mov eax,3 ; se lee el archivo
	mov ebx,eax
	mov ecx,contenido_archivo
	mov edx,y
	int 80h
	
	mov eax,4  ; se escribe en pantallla
	mov ebx,1
	mov ecx,contenido_archivo
	;mov edx,y
	int 80h
	
	mov eax,200h
	mov ebx,56h
	mul ebx
	int 80h
	
	break1:
	mov eax,1
	mov ebx,0
	int 0x80
