%macro impr_texto 2     ;recibe 2 parametros
        mov rax,1       ;sys_write
        mov rdi,1       ;std_out
        mov rsi,%1      ;primer parametro: Texto
        mov rdx,%2      ;segundo parametro: Tamano texto
        syscall
%endmacro

%macro impr_linea 2     ;recibe 2 parametros
        mov rax,1       ;sys_write
        mov rdi,1       ;std_out
        mov rsi,%1      ;primer parametro: Texto
        mov rdx,%2      ;segundo parametro: Tamano texto
        syscall
  mov rax,1     ;sys_write
        mov rdi,1       ;std_out
        mov rsi,cons_nueva_linea        ;primer parametro: Texto
        mov rdx,1       ;segundo parametro: Tamano texto
        syscall
%endmacro

section .data
  cons_nueva_linea: db 0xa
  tabla: db "0123456789ABCDEF",0
  cons_hex_header: db ' 0x'
  cons_tam_hex_header: equ $-cons_hex_header
  cons_cores: db 'cores: '
  cons_tam_cores: equ $-cons_cores



section .bss
  un_byte: resb 1
section .text
    global _start

_start:

	mov eax,04h
        cpuid
        mov r8,rax
	impr_texto cons_cores,cons_tam_cores
        impr_texto cons_hex_header,cons_tam_hex_header

        mov edx,eax
        and edx,0xF0000000
	shr edx,28
	lea ebx,[tabla]
        mov al,dl
        xlat
        mov [un_byte],ax
        impr_texto un_byte,1
	
	mov edx,eax
        and edx,0x0C000000
        shr edx,24
	add edx,02h
        lea ebx,[tabla]
        mov al,dl
        xlat
        mov [un_byte],ax
        impr_linea un_byte,1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov eax,1
        mov ebx,0
        int 0x80

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
