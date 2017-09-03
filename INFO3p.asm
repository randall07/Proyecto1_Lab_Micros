
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

;===============================================================================
;Segmento de datos, Declaracion de variables estaticas (ubicadas en memoria)

section .data
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
  cons_frec_base: db 'Frecuencia : '
   cons_tam_frec_base: equ $-cons_frec_base
  cons_frec_max: db 'frecuencia max: '
   cons_tam_frec_max: equ $-cons_frec_max
  cons_frec_bus: db 'frecuencia bus: '
   cons_tam_frec_bus: equ $-cons_frec_bus

;cores
  cons_cores: db 'Numero de cores por package: '
   cons_tam_cores: equ $-cons_cores
;thread
  cons_thread: db 'Numero de threads por cache: '
   cons_tam_thread: equ $-cons_thread

section .bss
  fabricante_id:resd 12	 ;Identificacion del fabricante (vendor) [12 Double]
  version:	resd 4   ;Version
  features:	resd 4   ;Features o funcionalidades
  stepping:	resb 1
  un_byte:	resb 1
  dos_bytes: resb 2
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;  i		resd	4
;  curfeat		resd	4
;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

;===================================================================================
;Segmento de codigo
section .text
    global _start
    names	db	'FPU  VME  DE   PSE  TSC  MSR  PAE  MCE  CX8  APIC RESV SEP  MTRR PGE  MCA  CMOV PAT PSE3 PSN  CLFS RESV DS   ACPI MMX FXSR SSE  SSE2 SS   HTT  TM   RESV PBE '
;------------------------------Inicio de codigo-------------------------------------
_start:

;==============info del preocesador

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
						;Se recuperan los valores de CPUID
			mov rax,r8
			mov edx,eax
						;Nos interesa el segundo nibble mas bajo de EDX (Modelo) - Se filtra con una mascara
						;y con un corrimiento (shift) a la derecha por 4 bits
			and edx,0x00F0
			shr edx,4
						;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			lea ebx,[tabla]
						;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			mov al,dl
			xlat
						;El resultado se guarda en "un_byte"
			mov [un_byte],ax
						;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
			impr_linea un_byte,1

;Ahora se pasa a calcular la Familia (Tercer nibble)
			impr_texto cons_familia,cons_tam_familia
			impr_texto cons_hex_header,cons_tam_hex_header
						;Se recuperan los valores de CPUID
			mov rax,r8
			mov edx,eax
						;Nos interesa el tercer nibble mas bajo de EDX (Modelo) - Se filtra con una mascara
						;y con un corrimiento (shift) a la derecha por 8 bits
			and edx,0x0F00
			shr edx,8
						;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			lea ebx,[tabla]
						;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			mov al,dl
			xlat
						;El resultado se guarda en "un_byte"
			mov [un_byte],ax
						;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
			impr_linea un_byte,1

;Ahora se pasa a calcular el tipo de procesador
						;Imprimir los encabezados
			impr_texto cons_tipo_cpu,cons_tam_tipo_cpu
			impr_texto cons_hex_header,cons_tam_hex_header
						;Se recuperan los valores de CPUID
			mov rax,r8
			mov edx,eax
						;Nos interesa el cuarto nibble mas bajo de EDX (Tipo) - Se filtra con una mascara
						;y con un corrimiento (shift) a la derecha por 12 bits
			and edx,0xF000
			shr edx,12
						;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			lea ebx,[tabla]
						;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			mov al,dl
			xlat
						;El resultado se guarda en "un_byte"
			mov [un_byte],ax
						;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
			impr_linea un_byte,1

; se calcula el modelo extendido del procesador
						;Imprimir los encabezados
			impr_texto cons_modelo_ext,cons_tam_modelo_ext
			impr_texto cons_hex_header,cons_tam_hex_header
						;Se recuperan los valores de CPUID
			mov rax,r8
						;Para poder trabajar el 5to nibble, es necesario hacer un corrimiento a RAX
						;antes de procesarlo con las mascaras en EDX
			shr rax,4
			mov edx,eax
						;Nos interesa el cuarto nibble de EDX (Modelo Ext) - Se filtra con una mascara
						;y con un corrimiento (shift) a la derecha por 12 bits
			and edx,0xF000
			shr edx,12
						;Se carga la tabla de referencia para imprimir hexadecimales en EBX
			lea ebx,[tabla]
						;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
			mov al,dl
			xlat
						;El resultado se guarda en "un_byte"
			mov [un_byte],ax
						;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
			impr_linea un_byte,1

;se calcula el familia extendido del procesador ()
                                                ;Imprimir los encabezados
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
                                               ;El resultado se guarda en "un_byte"
                        mov [un_byte],ax
                                                ;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
                        impr_texto un_byte,1


			mov rax,r8
	                                        ;Para poder trabajar el 6to ni$
                                                ;antes de procesarlo con las m$
                        shr rax,8
                        mov edx,eax
                                                ;Nos interesa el cuarto nibble$
                                                ;y con un corrimiento (shift) $
                        and edx,0xF000
                        shr edx,12
                                                ;Se carga la tabla de referenc$
                        lea ebx,[tabla]
                                                ;Ahora, en AL se carga el nibb$
                        mov al,dl

                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;Finalmente se calcula el Brand id del procesador

			mov ebx,1
			cpuid
			_break1.5:                        ;Imprimir los encabezados
                        impr_texto cons_brandid,cons_tam_brandid
                        impr_texto cons_hex_header,cons_tam_hex_header
                                                ;Se recuperan los valores de CPUID
                        mov rax,r8
                        mov edx,ebx
                                                ;Nos interesa el cuarto nibble de EDX (Modelo Ext) - Se filtra con una mascara
                        and edx,0x00FF
                                                ;Se carga la tabla de referencia para imprimir hexadecimales en EBX
                        lea ebx, [tabla]        ;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
                        mov al,dl
                        xlat
                                                ;El resultado se guarda en "un_byte"
                        mov [dos_bytes],ax        ;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir
                        impr_linea un_byte,2

;==================info cache con EAX=2========================================================

;Primero se calcula la configuracion del procesador de la  cache(0 a 7 bits)
;                                                ;Llamar a CPUID con EAX=2 para solicitar los features del CPU
;                       mov eax,2
;                       cpuid                   ;R8 se usa como referencia con el valor precargado. No debe sobre-escribirse
;                       _break2:
;    		        mov r8,rax
;                                                ;Imprimir los encabezados
;                       impr_texto cons_conf_proce_cache,cons_tam_conf_proce_cache
;                       impr_texto cons_hex_header,cons_tam_hex_header
;			mov edx,eax             ;EAX se va a copiar a EDX para poder hacer calculos sin perder los datos de EAX
;                       and edx,0x00FF          ;Nos interesa el nibble mas bajo de EDX (Stepping) - Se filtra con una mascara
;                       lea ebx,[tabla]         ;Se carga la tabla de referencia para imprimir hexadecimales en EBX
;                       mov al,dl               ;Ahora, en AL se carga el nibble que deseamos buscar en la tabla y se hace el lookup
;                       xlat
;                       mov [dos_bytes],ax      ; el resultado se guarda en "un_byte"
;                      	impr_linea dos_bytes,2    ;Ahora, en un_byte esta el caracter ASCII correspondiente al hexadecimal a imprimir


                        mov eax,2
                        cpuid
                        _break2:
                        mov r8,rax

;Primero se calcula la configuracion del procesador de la  cache(0 a 7 bits)
			_break3:
      			impr_texto cons_conf_proce_cache,cons_tam_conf_proce_cache
                        impr_texto cons_hex_header,cons_tam_hex_header
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
			_break5:
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

;==========================info frecuencia EAX=15h========================0====
			mov eax,0
			cpuid
			_breaka:
			mov eax,15
                        cpuid
                        mov r8,rcx
			_breakb:
;Primero se calcula la configuracion del procesador de la  cache(0 a 31 bits)
                        impr_texto cons_frec_base,cons_tam_frec_base
                        impr_texto cons_hex_header,cons_tam_hex_header

			shr rcx,16
                        mov edx,ecx
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

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

                        mov rcx,r8
                        shr rcx,16
                        mov edx,ecx
			and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

			mov rcx,r8
                        mov edx,ecx
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rcx,r8
                        mov edx,ecx
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rcx,r8
                        mov edx,ecx
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rcx,r8
                        mov edx,ecx
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1


;============================================= EAX=16h=================================================
			mov eax,16
			cpuid

                        mov r8,rax

                        impr_texto cons_frec_base,cons_tam_frec_base
                        impr_texto cons_hex_header,cons_tam_hex_header
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
                        impr_texto un_byte,1

			mov rax,r8
                        mov edx,eax
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rax,r8
                        mov edx,eax
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1

;=====================info cores EAX=4==================================

;.....................cores por package-1  bits (31:26)

			impr_texto cons_cores,cons_tam_cores
                        impr_texto cons_hex_header,cons_tam_hex_header

			mov eax,4
			mov r8,rax

                        shr rax,16
                        mov edx,eax
                        and rax,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rax,r8
                        shr rax,16
                        mov edx,eax
                        and edx,0x0C00
                        shr edx,8
			;;;add edx,2
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1


;.....................threads por cache bits (25:14)

                        impr_texto cons_thread,cons_tam_thread
                        impr_texto cons_hex_header,cons_tam_hex_header

                        mov eax,4
                        mov r8,rax

                        shr rax,16
                        mov edx,eax
                        and rax,0x0700
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
                        ;;;;;;add edx,2
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_texto un_byte,1

                        mov rax,r8
                        shr rax,16
                        mov edx,eax
                        and edx,0x000F
                        ;;;;;;add edx,2
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
;========================================

			mov rax,1	;sys_write
			mov rdi,1	;std_out
			mov rsi,cons_nueva_linea	;primer parametro: Texto
			mov rdx,1	;segundo parametro: Tamano texto
			syscall

;      mov [version],eax
;      mov [features],edx
;
;     impr_linea version,4
;     impr_linea features,4
;mov [100000f0h],ebx ;break program for debugging
;!!!!!!!!!!!!!!!!!!

;;########################## A FOR LOOP ###################################################
;;for(i = 8; i != 0; i++){
;mov	eax,00000001h
;mov	[curfeat],eax
;mov     eax,-1
;mov     [i],eax
;.loop:
;;--i
;	mov     eax,[i]
;	inc eax         ;(i++)
;	cmp     eax,31
;	jz     .quitloop   ;quit loop if reached limit
;	mov     [i],eax    ;put updated value on stack

;get current feature
;        mov ebx,[curfeat]
;test for feature - if feature exists ebx is non zero
;	and ebx,[features]
;left shift to test for next feature (will be used in next iteration of loop)
;	mov eax,[curfeat]
;        shl eax,1
;        mov [curfeat],eax

;jump if feaure not exist
;cmp ebx,0
;jz .loop ;check if zero flag is set - if it is it means that the feature didn't exist so we don't want to print anything out
;;otherwise this feature must exist lets print it out...
;        mov     eax,[i] ;get value from stack           0x080480bf
;        mov     edx,5   ;message length
;        mov     ecx,names     ;message to write (msg is a pointer to the start of the string
;times 5	add	ecx,eax

;        mov     ebx,1   ;file descriptor (stdout)
;        mov     eax,4   ;system call number (sys_write) 0x080480b7
;        int     0x80    ;call kernel                    0x080480be

;	jmp .loop ; unconditional jump
;}
;.quitloop:
;===================================================================================
;Finalizacion del programa. Devolver condiciones para evitar un segmentation fault
  mov	eax,1	;(sys_exit)
	mov	ebx,0	;exit status 0
	int	0x80	;llamar al sistema
;===================================================================================
