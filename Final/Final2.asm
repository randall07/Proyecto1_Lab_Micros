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
        mov rsi,cons_headerf     ;primer parametro: Texto
        mov rdx,cons_tam_headerf ;segundo parametro: Tamano texto
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
;------------------------- FIN DE MACRO Bonilla  --------------------------------


%macro limpiar_pantalla 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro imprimir_texto 2

	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

%macro imprimir_texto_guarda 2

        mov rax,1
        mov rdi,1
        mov rsi,%1
        mov rdx,%2
        syscall

        mov rax,1
        mov rdi,[result_fd]
        mov rsi,%1
        mov rdx,%2
        syscall
%endmacro

%macro leer_pantalla 2

	mov rax,0
	mov rdi,0
	mov rsi,%1             ;50
	mov rdx,%2
	syscall
%endmacro

%macro tecla_get 1
	mov rax,0
	mov rdi,0
	mov rsi,%1
	mov rdx,1
	syscall
%endmacro



;#################################### FIN MACRO ########


section .data


%include "Rendimiento.asm"
%include "Familia.asm"


marco1: db '          * * * * * * * * * * * * * * * * * * * * * * *',0ax
marco1_tam: equ $-marco1
marco2: db '          *                                           *',0ax
marco2_tam: equ $-marco2

Universidad: db '          *    INSTITUTO TECNOLÓGICO DE COSTA RICA    *',0ax
Universidad_l: equ $-Universidad

Datos: db '          *             II semestre 2017              *',0ax
Datos_l: equ $-Datos

estudiantes: db '          *               Estudiantes:                *',0ax
estudiantes_tam: equ $-estudiantes
est1: db '          *             Carlos Andrés Solano          *',0ax
est1_tam: equ $-est1

est2: db '          *               Jill Carranza               *',0ax
est2_tam: equ $-est2

est3: db '          *               Randall Bonilla             * ',0ax
est3_tam: equ $-est3

est4: db '          *               Juan Pablo Ortiz            *',0ax
est4_tam: equ $-est4

name_msg: db '   Bienvenido al analizador de procesador  ',0xa
name_tam: equ $-name_msg

disp_msg: db 'Ingrese el número de min : ',0xa
LongDisp_msg: equ $-disp_msg

suopcion: db 'Minutos a analizar : ',0xa
suopcion_l: equ $-suopcion 

limpiar: db 0x1b, "[2J", 0x1b, "[H"
limpiar_tam: equ $-limpiar                        ;100

prueba: db 'Loop',0ax
prueba_l: equ $-prueba

muestreo: db 'Iniciando muestreo.....',0xa
muestreo_l: equ $-muestreo

salir: db 'Fin del programa. Do not worry, be happy',0xa
salir_l: equ $-salir

parteA: db 'Iniciando solicitud de datos del procesador',0xa
parteA_l: equ $-parteA
parteB: db 'Iniciando solicitud de rendimiento',0xa
parteB_l: equ $-parteB

nueva_linea: db 0ax
cuenta_ascii: db ''
cuenta_ascii_tam: equ $-cuenta_ascii

text_enter: db '',0xa

num1: equ 3
num2: equ 0
num3: equ 1
num4: equ 5

resulttxt db 'RESULTADOS.txt',0

fd dw 0

YN_op: db 'Desea salir (y-n)? :',0xa
YN_op_l: equ $-YN_op
cons_retro_1: db 'Usted eligió: ',0ax
cons_tam_retro_1: equ $-cons_retro_1

op_menu: db '          Opciones a escoger',0xa
op_menu_l: equ $-op_menu

linea_vacia: db ' ',0xa
linea_vacia_l: equ $-linea_vacia

opciona: db 'a. Info Sistema',0xa
opciona_l: equ $-opciona
opcionb: db 'b. Rendimiento',0xa
opcionb_l: equ $-opcionb
opcionc: db 'c. Salir',0xa
opcionc_l: equ $-opcionc

cons_headerf: db ' El porcentaje de rendimiento de su procesador es: '
cons_tam_headerf: equ $-cons_headerf
cons_porcentaje: db '%'
cons_tam_porcentaje: equ $-cons_porcentaje
cons_enero: db 'Ene'
cons_tam_enero: equ $-cons_enero
cons_febrero: db 'Feb'
cons_tam_febrero: equ $-cons_febrero
cons_marzo: db 'Mar'
cons_tam_marzo: equ $-cons_marzo
cons_abril: db 'Abr'
cons_tam_abril: equ $-cons_abril
cons_mayo: db 'May'
cons_tam_mayo: equ $-cons_mayo
cons_junio: db 'Jun'
cons_tam_junio: equ $-cons_junio
cons_julio: db 'Jul'
cons_tam_julio: equ $-cons_julio
cons_agosto: db 'Ago'
cons_tam_agosto: equ $-cons_agosto
cons_setiembre: db 'Set'
cons_tam_setiembre: equ $-cons_setiembre
cons_octubre: db 'Oct'
cons_tam_octubre: equ $-cons_octubre
cons_noviembre: db 'Nov'
cons_tam_noviembre: equ $-cons_noviembre
cons_diciembre: db 'Dic'
cons_tam_diciembre: equ $-cons_diciembre
cons_slash: db  "/"
cons_tam_slash: equ $-cons_slash
cons_nueva_linea: db 0xa
cons_diez: db '1'
cons_veinte: db '2'
cons_treinta: db '3'
cons_cuarenta: db '4'
cons_cincuenta: db '5'
cons_sesenta: db '6'
cons_setenta: db '7'
cons_ochenta: db '8'
cons_noventa: db '9'
cons_cien: db '100'
tabla: db "0123456789ABCDEF",0
scale: equ 0x10000 ;este numero va a ser util para calcular el porcentaje, equivale a 65536 en decimal 
cien: equ 0x64 ;este es el 100 que se utilizara para calcular e porcentaje
year: equ 0x01E1853E; numero de segundos que hay en un año
day: equ 0x15180; numero de segundos que hay en un dia
ys70: equ 0x1E ; Cantidad de años desde 1970,hasta el año 2000. Lease years since 1970
month: equ 0x28206f ; Cantidad de segundos que hay en un mes.
ajuste_horario:equ  0x7E90
second: equ 0xE10
second2: equ 0x3C
cons_dospuntos: db ':'
cons_tam_dospuntos: equ $-cons_dospuntos
cons_espacio: db '   '
cons_tam_espacio: equ $-cons_espacio

;################### const de bonilla

;archivos Disco duro
 cons_esp_disco: db 'Espacio total del disco: '
  cons_tam_esp_disco: equ $-cons_esp_disco
 nombre_archivo1: db '/sys/block/sda/size',0
  tam_nombre_archivo1: equ $-nombre_archivo1
 cons_esp_disp_disco: db 'Espacio disponible del disco: '
  cons_tam_esp_disp_disco: equ $-cons_esp_disp_disco
 nombre_archivo2: db '/sys/block/sda/sda1/size'
  tam_nombre_archivo2: equ $-nombre_archivo2
  cons_header: db 'Contenido del registro: '
   cons_tam_header: equ $-cons_header
  cons_header2: db 'ascii->'
   cons_tam_header2: equ $-cons_header2
  cons_header3: db 'Bloques->'
   cons_tam_header3: equ $-cons_header3
  cons_header4: db 'Bloques->'
   cons_tam_header4: equ $-cons_header4
;  cons_nueva_linea: db 0xa
;  tabla: db "0123456789ABCDF",O
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
  cons_cores: db 'Numero de cores: '
   cons_tam_cores: equ $-cons_cores
;thread
  cons_thread: db 'Numero de threads por cache: '
   cons_tam_thread: equ $-cons_thread
;memoria ram
  cons_ram_total: db 'Memoria RAM total: '
   cons_tam_ram_total: equ $-cons_ram_total
  cons_ram_disp: db 'Memoria RAM disponible: '
   cons_tam_ram_disp: equ $-cons_ram_disp
;###############################################



section .bss    ;################### .bss ###########

seconds: resb 1

tiempo_espera:    ; resb 4
	tv_sec: resq 1
	tv_nsec: resq 9
result_fd: resb 8

YN: resb 3
menu: resb 3

;Se van a trabajar numeros HEX de maximo 4 bytes (4 digitos)
valor_hex: resb 1 ;En este ejemplo, se usa una sola
valor_dec: resb 100 ;Un solo digito Hex puede necesitar maximo 2 digitos decimales
;valor_ascii: resb 4
resultado: resb 50 ; Espacio en memoria con 50 bytes
fecha: resw 100 ;Reserva un word para la fecha.
anho: resb 100 ;Variable que guardara el año
dia: resb 100; Variable que guardara el dia
ciclo: resb 100
centinela: resb 100

  mi_registro: resb 4
   un_ascii: resb 1
  resultado1: resb 50
  fabricante_id:resd 12	 ;Identificacion del fabricante (vendor) [12 Double]
  stepping:	resb 1
  un_byte:	resb 1
  contenido_archivo1: resb 10
  contenido_archivo2: resb 10
  mes: resb 100 ; Variable que guardara el numero de mes
  num_dia: resb 100;
  hora: resb 100;
  min: resb 100;
  sec: resb 100;


;################################## .text

section .text
	global _start

_start:

_inicio:           ;150

	mov rax,2
	mov rdi,resulttxt
	mov rsi,(2000o+1000o+100o+2o)
	mov rdx,(700o+40o+4o)
	syscall
	mov [result_fd],rax

	imprimir_texto_guarda marco1,marco1_tam
	imprimir_texto_guarda marco2,marco2_tam
	imprimir_texto_guarda Universidad,Universidad_l
	imprimir_texto_guarda marco2, marco2_tam
	imprimir_texto_guarda Datos,Datos_l
	imprimir_texto_guarda marco2,marco2_tam
	imprimir_texto_guarda estudiantes,estudiantes_tam
	imprimir_texto_guarda marco2,marco2_tam
	imprimir_texto_guarda est1,est1_tam
	imprimir_texto_guarda est2,est2_tam
	imprimir_texto_guarda est3,est3_tam
	imprimir_texto_guarda est4,est4_tam
	imprimir_texto_guarda marco2,marco2_tam
	imprimir_texto_guarda marco2,marco2_tam
	imprimir_texto_guarda marco1,marco1_tam
        imprimir_texto_guarda linea_vacia,linea_vacia_l
	imprimir_texto_guarda name_msg, name_tam
        imprimir_texto_guarda linea_vacia,linea_vacia_l

_inicio1:
        imprimir_texto_guarda linea_vacia,linea_vacia_l
	imprimir_texto_guarda op_menu,op_menu_l
        imprimir_texto_guarda linea_vacia,linea_vacia_l
	imprimir_texto_guarda opciona,opciona_l
	imprimir_texto_guarda opcionb,opcionb_l
	imprimir_texto_guarda opcionc,opcionc_l
        imprimir_texto_guarda linea_vacia,linea_vacia_l

_parche:
         xor r11,r11
         mov [menu],r11
	leer_pantalla menu,1
_bpcentinela:

	xor r11,r11
	mov r11,[menu]
_bpcentinela2:
	cmp r11,0x61
	je _jill
	cmp r11,0x62
	je _primero
	cmp r11,0x63
	je _final

	jmp _parche

_jill:
        imprimir_texto cons_retro_1,cons_tam_retro_1
        imprimir_texto menu,2

	imprimir_texto_guarda linea_vacia,linea_vacia_l
	imprimir_texto_guarda parteA,parteA_l
	imprimir_texto_guarda linea_vacia,linea_vacia_l

	call _Familia
	r1:
	xor r10,r10
	mov r10,0x1
	cmp r10,r10
	je _cuarto

_primero:
        imprimir_texto cons_retro_1,cons_tam_retro_1
        imprimir_texto menu,2

	imprimir_texto_guarda linea_vacia,linea_vacia_l
	imprimir_texto_guarda parteB,parteB_l
        imprimir_texto_guarda linea_vacia,linea_vacia_l


	xor r10,r10
	xor r11,r11

	imprimir_texto_guarda linea_vacia,linea_vacia_l
	imprimir_texto disp_msg, LongDisp_msg
	_parche2:
	mov rax,0
	mov rdi,0
	mov rsi,seconds
	mov rdx,1

	syscall

	mov r15,0x10
	mov r14,[seconds]
	cmp r14,r15
	jg _continue

	jmp _parche2

	_continue:
	imprimir_texto suopcion,suopcion_l
	imprimir_texto seconds,2
	imprimir_texto nueva_linea,1

	xor r11,r11
	mov r11,[seconds]
	sub r11,0x30               ;El valor está en hexa aquí
	mov r8,r11                 ;Para el loop
	imul r8,0xC
	mov [ciclo],r8
        _break:
	mov r14,0x5
	mov [tv_sec],r14           ;delay
	xor r13,r13
	mov r13, 200000000
	mov [tv_nsec],r13

	imprimir_texto_guarda linea_vacia,linea_vacia_l
	imprimir_texto_guarda muestreo,muestreo_l
        imprimir_texto_guarda linea_vacia,linea_vacia_l

	xor r9,r9
	mov r9,num2
	cmp [ciclo],r9
        mov [centinela],r8
	_bpxxx:
	jg _segundo

_segundo:

	imprimir_texto_guarda prueba,prueba_l

	;######################### JP

	call _rendimiento

	;###################### fin

	esperar:
		mov rax,35                  ;Llama al loop
		mov rdi,tiempo_espera
		xor rsi,rsi
		syscall


	add r9,0x1
        mov r8, [centinela]
        mov [ciclo],r8
	cmp r9,[ciclo]
	_bpxx:
	jne _segundo
	je _cuarto

_cuarto:
	xor r14,r14
	jmp _inicio1
_final:

	imprimir_texto_guarda linea_vacia,linea_vacia_l
        imprimir_texto_guarda salir,salir_l

	xor rdi,rdi
	mov rax,3
	mov rdi,[result_fd]
	syscall
	mov rax,3
	mov rdi,fd
	syscall

	tecla_get text_enter
	limpiar_pantalla limpiar,limpiar_tam
	mov rax,60
	mov rdi,0
	syscall






