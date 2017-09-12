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
  cons_frecuencia_base: db 'Frecuencia base: '
  cons_tam_frecuencia_base: equ $-cons_frecuencia_base
  cons_frecuencia_max: db 'Frecuencia max'
  cons_tam_frecuencia_max: equ $-cons_frecuencia_max
  cons_frecuencia_bus: db 'Frecuencia bus'
  cons_tam_frecuencia_bus: equ $-cons_frecuencia_bus



section .bss
  un_byte: resb 1
section .text
    global _start

_start:

	mov eax,0016h
        cpuid
        mov r8,rax
	;break1:
        impr_texto cons_frecuencia_base,cons_tam_frecuencia_base
        impr_texto cons_hex_header,cons_tam_hex_header

        mov edx,eax
        and edx,0xF000
	;break2:
	shr edx,12
        lea ebx,[tabla]
        mov al,dl
        xlat
        mov [un_byte],ax
        impr_texto un_byte,1
	break1:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 1
	mov rax,r8
        mov edx,eax
        and edx,0x0F00
        shr edx,8
        lea ebx,[tabla]
        mov al,dl
        xlat
        mov [un_byte],ax
        impr_texto un_byte,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 2
	mov rax,r8 
        mov edx,eax
        and edx,0x00F0 
        shr edx,4
        lea ebx,[tabla]
        mov al,dl
        xlat
        mov [un_byte],ax
        impr_texto un_byte,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 3
	mov rax,r8
        mov edx,eax
        and edx,0x000F
        lea ebx,[tabla]
        mov al,dl
        xlat
        mov [un_byte],ax
        impr_linea un_byte,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; base
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; max
        mov ebx,016h
        cpuid
        mov r8,rbx
        impr_texto cons_frecuencia_max,cons_tam_frecuencia_max
        impr_texto cons_hex_header,cons_tam_hex_header
        mov edx,ebx
        and edx,0xF000
        shr edx,12
        lea ebx,[tabla]
        mov bl,dl
        xlat
        mov [un_byte],bx
        impr_texto un_byte,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 1
        mov rbx,r8
        mov edx,ebx
        and edx,0x0F00
        shr edx,8
        lea ebx,[tabla]
        mov bl,dl
        xlat
        mov [un_byte],bx
        impr_texto un_byte,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 2
        mov rbx,r8
        mov edx,ebx
        and edx,0x00F0 
        shr edx,4
        lea ebx,[tabla]
        mov bl,dl
        xlat
        mov [un_byte],bx
        impr_texto un_byte,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 3
        mov rbx,r8
        mov edx,ebx
        and edx,0x000F
        lea ebx,[tabla]
        mov bl,dl
        xlat
        mov [un_byte],bx
        impr_linea un_byte,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov eax,1
        mov ebx,0
        int 0x80
