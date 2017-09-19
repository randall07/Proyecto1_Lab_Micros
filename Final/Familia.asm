_Familia:
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
	imprimir_texto_guarda cons_fabricante,cons_tam_fabricante
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
			imprimir_texto_guarda cons_stepping,cons_tam_stepping
			imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
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
			imprimir_texto_guarda cons_modelo,cons_tam_modelo
			imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
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
			imprimir_texto_guarda cons_familia,cons_tam_familia
			imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
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
			imprimir_texto_guarda cons_tipo_cpu,cons_tam_tipo_cpu
			imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
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
			imprimir_texto_guarda cons_modelo_ext,cons_tam_modelo_ext
			imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
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
                        imprimir_texto_guarda cons_familia_ext,cons_tam_familia_ext
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
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
                        imprimir_texto_guarda un_byte,1

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
			mov r8,rax
                        _break2:              ;Imprimir los encabezados
                        imprimir_texto_guarda cons_brandid,cons_tam_brandid
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
                        mov rax,r8
                        mov edx,ebx
                        and edx,0x00F0
			shr edx,4
			lea ebx, [tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1

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
      			imprimir_texto_guarda cons_conf_proce_cache,cons_tam_conf_proce_cache
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
                        mov rax,r8
			mov edx,eax
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
			mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
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
                        imprimir_texto_guarda cons_conf_proce_cache2,cons_tam_conf_proce_cache2
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
                        mov rax,r8
                        mov edx,eax
                        and edx,0xF000
			shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1

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
                        imprimir_texto_guarda cons_conf_proce_cache3,cons_tam_conf_proce_cache3
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
			mov rax,r8
			shr rax,8
			mov edx,eax
                        and edx,0x0000F000
                        shr edx,12
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1

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
                        imprimir_texto_guarda cons_conf_proce_cache4,cons_tam_conf_proce_cache4
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
                        mov rax,r8
			shr rax,16
                        mov edx,eax
			and rax,0x0000F000
                        shr edx,12
			lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1

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
                        imprimir_texto_guarda cons_frec_base,cons_tam_frec_base
                        imprimir_texto_guarda cons_header2,cons_tam_header2
;1
			mov rcx,r8
                        mov edx,ecx
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;2
                        mov rcx,r8
                        mov edx,ecx
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;3
                        mov rcx,r8
                        mov edx,ecx
                        and edx,0xF000
			shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;4
                        mov rcx,r8
                        mov edx,ecx
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
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
                        imprimir_texto_guarda un_byte,1
;6
                        mov rcx,r8
                        shr rcx,16
                        mov edx,ecx
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
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
                        imprimir_texto_guarda un_byte,1
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
                        imprimir_texto_guarda un_byte,1

;==================================unidades de la frecuencia
			mov eax,0x80000004
			cpuid
			_break6:
                        mov r8,rdx
                        imprimir_texto_guarda cons_unidades_frec,cons_tam_unidades_frec
                        imprimir_texto_guarda cons_header2,cons_tam_header2
;1
			mov rdx,r8
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;2
                        mov rdx,r8
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;3
                        mov rdx,r8
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;4
                        mov rdx,r8
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;5
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;6
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;7
                        mov rdx,r8
                        shr rdx,16
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
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
			imprimir_texto_guarda cons_cores,cons_tam_cores
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
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
                        imprimir_texto_guarda un_byte,1
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

                        imprimir_texto_guarda cons_thread,cons_tam_thread
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
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
                        imprimir_texto_guarda un_byte,1

                        mov rax,r8
                        shr rax,16
                        mov edx,eax
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1

                        mov rax,r8
                        shr rax,16
                        mov edx,eax
                        and edx,0x000F
                        add edx,1
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1

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
;(memoria ram total)

        		mov rdi,resultado1
			mov rax,0x63
			syscall
			_break8:
			xor eax,eax
			mov eax,[0x00604a88];"primera parte de la direccion en[0:1]nibble"
			mov edx,eax
			syscall
			_break9:
                        mov r8,rdx
                        imprimir_texto_guarda cons_ram_total,cons_tam_ram_total
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
;1
                        mov rdx,r8
                        shr rdx,8
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;2
                        mov rdx,r8
                        shr rdx,8
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;3
                        mov rdx,r8
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;4
                        mov rdx,r8
                        and edx,0x0F00
			shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;5
                        mov rdx,r8
                        and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;6
                        mov rdx,r8
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;7
                        mov rdx,r8
			shr rdx,16                      
			and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;8
                        mov rdx,r8
			shr rdx,16
                        and edx,0x0F00
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        impr_linea un_byte,1 


;memoria ram disponible=============================================================
                        nop
                        mov rdi,resultado1
                        mov rax,0x63
                        syscall

                        xor eax,eax
                        mov eax,[0x00604a90];"primera parte de la direccion en[0:1]nibble"
                        mov edx,eax
                        syscall
                        _break10:
                        mov r8,rdx
                        imprimir_texto_guarda cons_ram_disp,cons_tam_ram_disp
                        imprimir_texto_guarda cons_hex_header,cons_tam_hex_header
;1
                        mov rdx,r8
                        shr rdx,16
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;2
                        mov rdx,r8
                        and edx,0xF000
                        shr edx,12
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;3
                        mov rdx,r8
                        and edx,0x0F00
                        shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;4
                        mov rdx,r8
                        and edx,0x00F0
			shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;5
                        mov rdx,r8
                        and edx,0x000F
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;6
                        mov rdx,r8
			shr edx,16
                        and edx,0x0F00
			shr edx,8
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;7
                        mov rdx,r8
			shr rdx,16                      
			and edx,0x00F0
                        shr edx,4
                        lea ebx,[tabla]
                        mov al,dl
                        xlat
                        mov [un_byte],ax
                        imprimir_texto_guarda un_byte,1
;8
                        mov rdx,r8
			shr rdx,16
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
			
			imprimir_texto_guarda cons_esp_disco,cons_tam_esp_disco
			imprimir_texto_guarda cons_header3,cons_tam_header3
			xor eax,eax
			xor ebx,ebx
			xor ecx,ecx
			xor edx,edx
			mov ebx,nombre_archivo1
			mov eax,5
			mov ecx,0
			d:			
			int 80h

			mov eax,3
			mov ebx,eax
			mov ecx,contenido_archivo1
			mov edx,100
			int 80h

			mov eax,4
			mov ebx,1
			mov ecx,contenido_archivo1			
			int 80h

                        mov rax,1       ;sys_write
                        mov rdi,1       ;std_out
                        mov rsi,cons_nueva_linea      ;primer parametro: Texto
                        mov rdx,1       ;segundo parametro: Tamano texto
                        syscall

        		xor eax,eax
			xor ebx,ebx
			xor ecx,ecx
			xor edx,edx

;=======(espacio disponible en disco)
                        imprimir_texto_guarda cons_esp_disp_disco,cons_tam_esp_disp_disco
                        imprimir_texto_guarda cons_header4,cons_tam_header4
                        mov ebx,nombre_archivo2
                        mov eax,5
                        mov ecx,0
	                int 80h

                        mov eax,3
                        mov ebx,eax
                        mov ecx,contenido_archivo2
                        mov edx,100
                        int 80h

                        mov eax,4
                        mov ebx,1
                        mov ecx,contenido_archivo2
			int 80h

ret
