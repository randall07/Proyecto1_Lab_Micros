;######################## INFO #### #################################
;-------------------------  MACRO #1  ----------------------------------
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------
;-------------------------  MACRO #2  ----------------------------------
;Macro-2: impr_linea.
;	Imprime un mensaje que se pasa como parametro y un salto de linea
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_linea 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
  mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,cons_nueva_linea	;primer parametro: Texto
	mov rdx,1	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------
;-------------------------  MACRO #3  ----------------------------------
;Macro-3: impr_registro.
;       Imprime un registro de 64 bits en ASCII
;       Recibe 1 parametro de entrada:
;               %1 es el registro que se va a imprimir. Se debe pasar como 4 bytes
;-----------------------------------------------------------------------
%macro impr_registro 0  ;No recibe parametros
        ;Primero se imprime el encabezado de texto:
        mov rax,1       ;sys_write
        mov rdi,1       ;std_out
        mov rsi,cons_header     ;primer parametro: Texto
        mov rdx,cons_tam_header ;segundo parametro: Tamano texto
        syscall
        			;El dato se va a guardar en R9 para trabajarlo
        mov r9,[mi_registro]
        			;Para imprimir los 64 bits como caracteres ASCII se debe hacer un loop.
        			;Los 64 bits almacenan 8 nibbles, osea que se debe repetir 8 veces.
        			;Para hacer las repeticiones, usamos el registro R8
        mov r8,0x8
        loop:
                mov r10,r9
                		;lookup con XLAT
                and r10,0x0000000F
                mov rdx,r10
                lea ebx,[tabla]
                mov al,dl
                xlat
                		;Cada nibble se mueve a una direccion de memoria
                mov [un_ascii],ax
                		;y el contenido se imprime
                mov rax,1       ;sys_write
                mov rdi,1       ;std_out
                mov rsi,un_ascii        ;primer parametro: Texto
                mov rdx,1       ;segundo parametro: Tamano texto
                ;bp02:
                syscall
                		;shift r9 en 4 bits a la derecha para movernos al siguiente nibble
                shr r9,4
                		;Decrementar el contador almacenado en CL. Cuando se llega a cero, se term$
                		;la ejecucion de la macro
                dec r8
                jnz loop
	_finalizar_programa1:
        mov rax,1       ;sys_write
        mov rdi,1       ;std_out
        mov rsi,cons_nueva_linea        ;primer parametro: Texto
        mov rdx,1       ;segundo parametro: Tamano texto
        syscall

%endmacro
;------------------------- FIN DE MACRO --------------------------------

;===============================================================================
;Segmento de datos, Declaracion de variables estaticas (ubicadas en memoria)
section .data
  cons_header: db 'Contenido del registro: 0x'
   cons_tam_header: equ $-cons_header

  cons_header2: db 'ascii->'
   cons_tam_header2: equ $-cons_header2

  cons_header3: db 'Bloques->'
   cons_tam_header3: equ $-cons_header3


 cons_nueva_linea: db 0xa
  tabla: db "0123456789ABCDEF",0

  cons_hex_header: db ' 0x'
   cons_tam_hex_header: equ $-cons_hex_header

  cons_fabricante: db 'Fabricante: '
   cons_tam_fabricante: equ $-cons_fabricante
  cons_stepping: db 'Stepping - Numero revision: '
   cons_tam_stepping: equ $-cons_stepping
  cons_familia: db 'Familia: '
   cons_tam_familia: equ $-cons_familia
  cons_modelo: db 'Modelo: '
   cons_tam_modelo: equ $-cons_modelo
  cons_tipo_cpu: db 'Tipo de procesador: '
   cons_tam_tipo_cpu: equ $-cons_tipo_cpu
  cons_modelo_ext: db 'Modelo extendido: '
   cons_tam_modelo_ext: equ $-cons_modelo_ext
  cons_familia_ext: db 'Familia extendida: '
   cons_tam_familia_ext: equ $-cons_familia_ext
  cons_brandid: db 'Brand id: '
   cons_tam_brandid: equ $-cons_brandid
;cache
  cons_conf_proce_cache: db 'Conf proc Cache1: '
   cons_tam_conf_proce_cache: equ $-cons_conf_proce_cache
  cons_conf_proce_cache2: db 'Conf proc Cache2: '
   cons_tam_conf_proce_cache2: equ $-cons_conf_proce_cache2
  cons_conf_proce_cache3: db 'Conf proc Cache3: '
   cons_tam_conf_proce_cache3: equ $-cons_conf_proce_cache3
  cons_conf_proce_cache4: db 'Conf proc Cache4: '
   cons_tam_conf_proce_cache4: equ $-cons_conf_proce_cache4
;frecuencia
  cons_frec_base: db 'Frecuencia Procesador: '
   cons_tam_frec_base: equ $-cons_frec_base

  cons_unidades_frec: db '  Unidades: '
   cons_tam_unidades_frec: equ $-cons_unidades_frec
;cores
  cons_cores: db 'Numero de cores por package: '
   cons_tam_cores: equ $-cons_cores
;thread
  cons_thread: db 'Numero de threads por cache: '
   cons_tam_thread: equ $-cons_thread
;memoria ram
  cons_ram_total: db 'Memoria RAM total: '
   cons_tam_ram_total: equ $-cons_ram_total
  cons_ram_disp: db 'Memoria RAM disponible: '
   cons_tam_ram_disp: equ $-cons_ram_disp

;archivos
 nombre_archivo1: db '/sys/block/sda/size',0
  tam_nombre_archivo1: equ $-nombre_archivo1
;espacio en disco
 cons_esp_disco: db 'Espacio total del disco: '
  cons_tam_esp_disco: equ $-cons_esp_disco

 nombre_archivo2: db '/sys/block/sda/sda1/size',0
  tam_nombre_archivo2: equ $-nombre_archivo2

 cons_esp_disp_disco: db 'Espacio disponible del disco: '
  cons_tam_esp_disp_disco: equ $-cons_esp_disp_disco

section .bss
  mi_registro: resb 4
   un_ascii: resb 1

  resultado: resb 50

  fabricante_id:resd 12	 ;Identificacion del fabricante (vendor) [12 Double]
  version:	resd 4   ;Version
  features:	resd 4   ;Features o funcionalidades
  stepping:	resb 1
  un_byte:	resb 1

  contenido_archivo1: resb 10
  contenido_archivo2: resb 10

;===================================================================================
;Segmento de codigo
section .text
    global _start
    names	db	'FPU  VME  DE   PSE  TSC  MSR  PAE  MCE  CX8  APIC RESV SEP  MTRR PGE  MCA  CMOV PAT PSE3 PSN  CLFS RESV DS   ACPI MMX FXSR SSE  SSE2 SS   HTT  TM   RESV PBE '
;------------------------------Inicio de codigo-------------------------------------
_start:

;==============info del preocesador===============================

;Primera parte: Identificacion del fabricante

mov eax,0 ;Cargando EAX=0: Leer la identificacion del fabricante
cpuid     ;Llamada a CPUID

;El ID de fabricante se compone de 12 bytes que se almacenan en este orden:
;          1) Primeros 4 bytes en EBX
;          2) Siguientes 4 bytes en EDX
;          3) Ultimos 4 bytes en ECX
          mov [fabricante_id],ebx
          mov [fabricante_id+4],edx
          mov [fabricante_id+8],ecx
;Ahora se imprime el ID del fabricante usando la macro impr_linea
	impr_texto cons_fabricante,cons_tam_fabricante
        impr_linea fabricante_id,12
;-------------------------------------------------------------------------------
;Cargando EAX=1: Leer informacion y features del CPU
;Las funcionalidades del procesador se retornan en EAX con este formato:
; EAX = 0xHGFEDCBA (Cada letra representa 4 bits)
; Donde:
;			A = Stepping
;			B = Model
;			C = Familia
;			D = Tipo
;			E = Modelo extendido
;			F = Familia extendida
;			G-H = No se utilizan

;Primero se calcula el stepping (Nibble menos significativo)
						;Llamar a CPUID con EAX=1 para solicitar los features del CPU
			mov eax,1
			cpuid
			_break1:
			;R8 se usa como referencia con el valor precargado. No debe sobre-escribirse
			mov r8,rax
						;Imprimir los encabezados
			impr_texto cons_stepping,cons_tam_stepping
			impr_texto cons_hex_header,cons_tam_hex_header
			mov rax,r8
			mov edx,eax		;EAX se va a copiar a EDX para poder hacer calculos sin perder los datos de EAX
			and edx,0x000F		;Nos interesa el nibble mas bajo de EDX (Stepping) - Se filtra con una mascara
			lea ebx,[tabla]		;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			mov al,dl		;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			xlat
			mov [un_byte],ax	; el resultado se guarda en "un_byte"
			impr_linea un_byte,1	;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir

;Ahora se pasa a calcular el modelo (Segundo nibble menos significativo)
						;Imprimir los encabezados
			impr_texto cons_modelo,cons_tam_modelo
			impr_texto cons_hex_header,cons_tam_hex_header
			mov rax,r8		;Se recuperan los valores de CPUID
			mov edx,eax
			and edx,0x00F0		;Nos interesa el segundo nibble mas bajo de EDX (Modelo) - Se filtra con una mascara
			shr edx,4		;y con un corrimiento (shift) a la derecha por 4 bits
			lea ebx,[tabla]		;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			mov al,dl		;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			xlat
			mov [un_byte],ax	;El resultado se guarda en "un_byte"
			impr_linea un_byte,1	;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir

;Ahora se pasa a calcular la Familia (Tercer nibble)
			impr_texto cons_familia,cons_tam_familia
			impr_texto cons_hex_header,cons_tam_hex_header
			mov rax,r8		;Se recuperan los valores de CPUID
			mov edx,eax
			and edx,0x0F00		;Nos interesa el tercer nibble mas bajo de EDX (Modelo) - Se filtra con una mascara
			shr edx,8		;y con un corrimiento (shift) a la derecha por 8 bits
			lea ebx,[tabla]		;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			mov al,dl		;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			xlat
			mov [un_byte],ax	;El resultado se guarda en "un_byte"
			impr_linea un_byte,1	;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir

;Ahora se pasa a calcular el tipo de procesador
			impr_texto cons_tipo_cpu,cons_tam_tipo_cpu
			impr_texto cons_hex_header,cons_tam_hex_header
			mov rax,r8		;Se recuperan los valores de CPUID
			mov edx,eax
			and edx,0xF000		;Nos interesa el cuarto nibble mas bajo de EDX (Tipo) - Se filtra con una mascara
			shr edx,12		;y con un corrimiento (shift) a la derecha por 12 bits
			lea ebx,[tabla]		;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			mov al,dl		;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			xlat
			mov [un_byte],ax	;El resultado se guarda en "un_byte"
			impr_linea un_byte,1

; se calcula el modelo extendido del procesador
			impr_texto cons_modelo_ext,cons_tam_modelo_ext
			impr_texto cons_hex_header,cons_tam_hex_header
			mov rax,r8		;Se recuperan los valores de CPUID
			shr rax,4		;Para poder trabajar el 5to nibble, es necesario hacer un corrimiento a Rax antes de procesarlo con las mascaras en EDX
			mov edx,eax
			and edx,0xF000		;Nos interesa el cuarto nibble de EDX (Modelo Ext) - Se filtra con una mascara
			shr edx,12		;y con un corrimiento (shift) a la derecha por 12 bits
			lea ebx,[tabla]		;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			mov al,dl		;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			xlat
			mov [un_byte],ax	;El resultado se guarda en "un_byte"
			impr_linea un_byte,1	;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir

;se calcula el familia extendido del procesador ()
                        impr_texto cons_familia_ext,cons_tam_familia_ext
                        impr_texto cons_hex_header,cons_tam_hex_header
                                                ;Se recuperan los valores de CPUID
                        mov rax,r8
                        shr rax,12
                        mov edx,eax
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

			mov rax,r8
                        shr rax,8
                        mov edx,eax
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;Finalmente se calcula el Brand id del procesador (con ebx=1 en (7:0))

                        mov ebx,1
                        cpuid
                        _break2:              ;Imprimir los encabezados
                        mov r8,rax
			impr_texto cons_brandid,cons_tam_brandid
                        impr_texto cons_hex_header,cons_tam_hex_header
                        mov rax,r8
                        mov edx,ebx
                        and edx,0x00F0
			shr edx,4
			lea ebx, [tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

			mov rax,r8
                        mov edx,ebx
                        and edx,0x000F
                        lea ebx, [tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1


;==================info cache con EAX=2========================================================
                        mov eax,2
                        cpuid
                        _break3:
                        mov r8,rax

;Primero se calcula la configuracion del procesador de la  cache(0 a 7 bits)
      			impr_texto cons_conf_proce_cache,cons_tam_conf_proce_cache
                        impr_texto cons_hex_header,cons_tam_hex_header
                        mov rax,r8
			mov edx,eax
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
			mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
			_break4:
			mov rax,r8
			mov edx,eax
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;se calcula la configuracion del procesador de la  cache(8 a 15 bits)
                        impr_texto cons_conf_proce_cache2,cons_tam_conf_proce_cache2
                        impr_texto cons_hex_header,cons_tam_hex_header
                        mov rax,r8
                        mov edx,eax
                        and edx,0xF000
			shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rax,r8
                        mov edx,eax
                        and edx,0x0F00
                        shr edx,8
	 	        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;se calcula la configuracion del procesador de la  cache(16 a 23 bits)
                        impr_texto cons_conf_proce_cache3,cons_tam_conf_proce_cache3
                        impr_texto cons_hex_header,cons_tam_hex_header
			mov rax,r8
			shr rax,8
			mov edx,eax
                        and edx,0x0000F000
                        shr edx,12
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rax,r8
                        shr rax,4
                        mov edx,eax
			and edx,0x0000F000
                        shr edx,12
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;se calcula la configuracion del procesador de la  cache(24 a 31 bits)
                        impr_texto cons_conf_proce_cache4,cons_tam_conf_proce_cache4
                        impr_texto cons_hex_header,cons_tam_hex_header
                        mov rax,r8
			shr rax,16
                        mov edx,eax
			and rax,0x0000F000
                        shr edx,12
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rax,r8
                        shr rax,12
                        mov edx,eax
			and edx,0x0000F000
                        shr edx,12
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;======================================Info frecuencia cpu ===============================================
			xor rax,rax
			mov rax, 0x80000004
			cpuid
                        mov r8,rcx
                        _break5:
;Primero se calcula la configuracion del procesador de la  cache(7 a 0 bits)
                        impr_texto cons_frec_base,cons_tam_frec_base
                        impr_texto cons_header2,cons_tam_header2
;1
			mov rcx,r8
                        mov edx,ecx
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;2
                        mov rcx,r8
                        mov edx,ecx
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;3
                        mov rcx,r8
                        mov edx,ecx
                        and edx,0xF000
			shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;4
                        mov rcx,r8
                        mov edx,ecx
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;5
			mov rcx,r8
  			shr rcx,16
                        mov edx,ecx
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;6
                        mov rcx,r8
                        shr rcx,16
                        mov edx,ecx
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;7
                        mov rcx,r8
                        shr rcx,16
                        mov edx,ecx
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;8
                        mov rcx,r8
                        shr rcx,16
                        mov edx,ecx
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

;==================================unidades de la frecuencia
			mov eax,0x80000004
			cpuid
			_break6:
                        mov r8,rdx
                        impr_texto cons_unidades_frec,cons_tam_unidades_frec
                        impr_texto cons_header2,cons_tam_header2
;1
			mov rdx,r8
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;2
                        mov rdx,r8
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;3
                        mov rdx,r8
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;4
                        mov rdx,r8
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;5
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;6
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;7
                        mov rdx,r8
                        shr rdx,16
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;8
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;=====================info cores EAX=4==================================

;.....................cores por package-1  bits (31:26)

			impr_texto cons_cores,cons_tam_cores
                        impr_texto cons_hex_header,cons_tam_hex_header
			xor rax,rax
			mov rax,0x80000004
			;int  80h
			_break7:
			mov r8,rax
;1
			mov rax,r8
;                       shr rax,16
                        mov edx,eax
                        and rax,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;2
                        mov rax,r8
                        shr rax,16
                        mov edx,eax
                        and edx,0x0C00
                        shr edx,8
			add edx,2
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1


;.....................threads por cache bits (25:14)

                        impr_texto cons_thread,cons_tam_thread
                        impr_texto cons_hex_header,cons_tam_hex_header

                        mov rax,0x80000004
                        mov rax,r8
			;int 80h
                        shr rax,16
                        mov edx,eax
                        and edx,0x0700
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rax,r8
                        shr rax,16
                        mov edx,eax
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rax,r8
                        shr rax,16
                        mov edx,eax
                        and edx,0x000F
                        add edx,1
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

			mov rax,r8
                        mov edx,eax
                        and edx,0xC0000
			shr edx,12
                        ;;;;;;add edx,2
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1
;================================================================================================
;         MEMORIA RAM
;================================================================================================
;memoria ram total
        		mov rdi,resultado
			mov rax,0x63
			syscall
			_break8:
			xor eax,eax
			mov eax,[0x00601745]   ; " bc3db000 ",3,16G
			mov edx,eax
			syscall
			_break9:
                        mov r8,rdx
                        impr_texto cons_ram_total,cons_tam_ram_total
                        impr_texto cons_hex_header,cons_tam_hex_header
;1
                        mov rdx,r8
			shr rdx,16
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;2
                        mov rdx,r8
                        shr rdx,16
			and edx,0x0F00
                        shr edx,8
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;3
                        mov rdx,r8
                        shr rdx,16
			and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;4
                        mov rdx,r8
                        shr rdx,16
			and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;5
                        mov rdx,r8
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;6
                        mov rdx,r8
                        and edx,0x0F00
                        shr rdx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;7
                        mov rdx,r8
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;8
                        mov rdx,r8
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1


;memoria ram disponible=============================================================
                        nop
                        mov rdi,resultado
                        mov rax,0x63
                        syscall

                        xor eax,eax
                        mov eax,[0x0060174d]    ;"59d1b000 "
                        mov edx,eax
                        syscall
                        _break10:
                        mov r8,rdx
                        impr_texto cons_ram_disp,cons_tam_ram_disp
                        impr_texto cons_hex_header,cons_tam_hex_header
;1
                        mov rdx,r8
                        shr rdx,16
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;2
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;3
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;4
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;5
                        mov rdx,r8
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;6
                        mov rdx,r8
                        and edx,0x0F00
                        shr rdx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;7
                        mov rdx,r8
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1
;8
                        mov rdx,r8
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;============================================================================================================================
;                   INFO DISCO DURO
;============================================================================================================================
;=======(espacio total en disco)
			impr_texto cons_esp_disco,cons_tam_esp_disco
			impr_texto cons_header3,cons_tam_header3
			mov ebx,nombre_archivo1
			mov eax,5
			mov ecx,0
			int 80h

			mov eax,3
			mov ebx,eax
			mov ecx,contenido_archivo1
			mov edx,100
			d:
			int 80h

			mov eax,4
			mov ebx,1
			mov ecx,contenido_archivo1
			int 80h

;                       mov rax,1       ;sys_write
;                       mov rdi,1       ;std_out
;                       mov rsi,cons_nueva_linea        ;primer parametro: Texto
;                       mov rdx,1       ;segundo parametro: Tamano texto
;                       syscall

;=======(espacio disponible en disco)
                        impr_texto cons_esp_disp_disco,cons_tam_esp_disp_disco
                        impr_texto cons_header3,cons_tam_header3
                        mov ebx,nombre_archivo2
                        mov eax,5
                        mov ecx,0
	                int 80h

                        mov eax,3
                        mov ebx,eax
                        mov ecx,contenido_archivo2
                        mov edx,100
                        c:
			int 80h

                        mov eax,4
                        mov ebx,1
                        ;mov ecx,contenido_archivo2
                        
			mov ecx, 9437184
			int 80h


;			mov edx, 9437184


			mov rax,1	;sys_write
			mov rdi,1	;std_out
			mov rsi,cons_nueva_linea	;primer parametro: Texto
			mov rdx,1	;segundo parametro: Tamano texto
			syscall

;===================================================================================
;Finalizacion del programa. Devolver condiciones para evitar un segmentation fault
  mov	eax,1	;(sys_exit)
	mov	ebx,0	;exit status 0
	int	0x80	;llamar al sistema
;===================================================================================
