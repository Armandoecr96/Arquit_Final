;---------------------------------------- PUERTO F ---------------------------------------------------------
GPIO_PORTFR                   EQU 0x4005D004	;GPIO Port B (AHB) 0x40059000 base de datos LECTURA (pin F0)
GPIO_PORTFW                   EQU 0x4005D008	;GPIO Port B (AHB) 0x40059000 base de datos ESCRITURA (pin F1)
GPIO_PORTF_DIR_R              EQU 0x4005D400	;Offset 0x400=>  0 es entrada, 1 salida
GPIO_PORTF_AFSEL_R            EQU 0x4005D420	;Offset 0x420=>  0 funcion como GPIO, 1 funciona como periferico
GPIO_PORTF_DEN_R              EQU 0x4005D51C	;Offset 0x51C=>  0 funcina como NO digital, 1 funcion digital
GPIO_PORTF_AMSEL_R            EQU 0x4005D528	;Offset 0x528=>  0 Deshabilita funcion analogica, 1 activa analogica
GPIO_PORTF_PCTL_R             EQU 0x4005D52C	;Offset 0x52C=>  0 Selecciona funcion alternativa
GPIO_PORTF_ODR_R              EQU 0x4005D50C	;Offset 0x50C=>  1 Activa drenador abiertoGPIO_PORTB_LOCK				  EQU 0X40059520

SYSCTL_RCGCGPIO_RF             EQU 0x400FE608	;Base 0x400F.E000, Offset 0x608=> 1 activa puerto, 0 desactiva puerto
SYSCTL_PRGPIO_RF               EQU 0x400FEA08	;Base 0x400F.E000, Offset 0xA08 indica puerto listo
SYSCTL_RCGCGPIO_R12F           EQU 0x00000020  	;1 Enable and provide a clock to GPIO Port F in Run mode F
SYSCTL_PRGPIO_R12F             EQU 0x00000020    ;Bandera puerto listo F

;**********************Direccion para activar SysTick***************************
SYSCTL_STCURRENT			  EQU 0XE000E018
SYSCTL_STRELOAD				  EQU 0XE000E014
SYSCTL_STCTRL				  EQU 0XE000E010

;----------------------------MACRO------------------------------------------------------------
	MACRO
	REtardo $VALOR
	PUSH {R7, LR}
	MOV R7, $VALOR
	LSL R7, R7, #2
	BL DELAY_480
	POP {R7,LR}
	MEND
;----------------------------------------------
 AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        
		IMPORT Start
		;IMPORT TEMP1
		EXPORT UP_S2_DS18B20
		EXPORT INI_reset_S2
		EXPORT ENVIA_CERO_S2
		EXPORT ENVIA_UNO_S2
		EXPORT LECTURA_S2
		IMPORT DELAY_480
;************************************************************************
UP_S2_DS18B20
;************************************************************************

;------------------------------------ PORT K --------------------------------

 ;activa reloj para el puerto D
    LDR R1, =SYSCTL_RCGCGPIO_RF      ; R1 = SYSCTL_RCGCGPIO_R direccion que  1 activa puerto
    LDR R0, [R1]                    ; R0 = [R1] lee valor
    ORR R0, R0, #SYSCTL_RCGCGPIO_R12F; R0 = R0|SYSCTL_RCGCGPIO_R12, activa reloj de puerto
    STR R0, [R1]                    ; [R1] = R0  se guarda
	
    ;Verifica si el reloj es estable
    LDR R1, =SYSCTL_PRGPIO_RF        ; R1 = SYSCTL_PRGPIO_R (pointer)
GPIONinitloop
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ANDS R0, R0, #SYSCTL_PRGPIO_R12F ; R0 = R0&SYSCTL_PRGPIO_R12
    BEQ GPIONinitloop               ; if(R0 == 0), keep polling
	
    ; Direccion de salida
    LDR R1, =GPIO_PORTF_DIR_R       ; R1 = GPIO_PORTd_DIR_R 
    LDR R0, [R1]                    ; R0 = [R1] 
    ORR R0, R0, #0x02               ; R0 = R0|0xFF (todos los pines del puerto D salida)
	;ORR R0, R0, #0X2A
	BIC R0, R0, #0x01
    STR R0, [R1]                    ; [R1] = R0
	
    ; Registro de funcion alternativa
    LDR R1, =GPIO_PORTF_AFSEL_R     ; R1 = GPIO_PORTN_AFSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFF               ; R0 = R0&~0x02 (disable alt funct on PN1)
    STR R0, [R1]                    ; [R1] = R0
	
    ; set digital enable register
    LDR R1, =GPIO_PORTF_DEN_R       ; R1 = GPIO_PORTN_DEN_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0|0xFF (activa digital I/O  PD0-PD7)
    STR R0, [R1]                    ; [R1] = R0
	
    ; set port control register
    LDR R1, =GPIO_PORTF_PCTL_R      ; R1 = GPIO_PORTN_PCTL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFFFFFFFF         ; R0 = R0&0xFFFFFFFF (clear bit1 field)
    STR R0, [R1]                    ; [R1] = R0
	
	
    ; set analog mode select register
    LDR R1, =GPIO_PORTF_AMSEL_R     ; R1 = GPIO_PORTN_AMSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFF               ; R0 = R0&~0xFF (disable analog functionality on PD0-PD7)
    STR R0, [R1]                    ; [R1] = R0
	
	;activa drenador abierto
	
	 ; activa drenador abierto
    LDR R1, =GPIO_PORTF_ODR_R       ; R1 = GPIO_PORTB_ODR_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0x02               ; R0 = 
   ;ORR R0, R0, #0x2A
	STR R0, [R1]                    ; [R1] = R0

;suelta en bus
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (pointer escritura)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0x02               ; coloca un uno en el bit uno (MASTER TX=1 Resistor pullup)
    ;ORR R0, R0, #0x2A
	STR R0, [R1]                    ; [R1] = R0  envia un uno
	BX LR							; regresa

;*******************************CODIGO DE RESET*****************************
INI_reset_S2

	;se asegura que el bus este libre
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (pointer escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    ORR R0, R0, #0x02               ; coloca un uno en el bit uno (MASTER TX=1 Resistor pullup)
    STR R0, [R1]                    ; [R1] = R0  envia un uno
	nop
	nop
	nop
	nop
;-------------------------------baja TX=0 por 480µs minimo--------------------------------------

	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (pointer escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    BIC R0, R0, #0x02               ; cero en el bit uno (MASTER TX RESET PULSE)
    STR R0, [R1]                    ; [R1] = R0  lo envia al puerto						
	REtardo	#480					; llamo macro retardo de 480 useg mínimo
	
;------------------------------coloca TX em alta impedancia TX=1 Resistor pullup---------------------------------
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (pointer escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    ORR R0, R0, #0x02               ; coloca un uno en el bit uno del puerto B
    STR R0, [R1]                    ; [R1] = R0  envia un uno (suelta bus TX, Resistor pullup)
	REtardo	#60						;esperar entre 16 y 60 useg
	
;-------------------------------verifica si DS18B20 esta presente pulso RX=0-----------------------
	LDR R1, =GPIO_PORTFR        	; R1 = GPIO_PORTBW (pointer lectura pin B0)
es_uno_S2							;etiqueta de salto si no responde con cero   
	LDR R0, [R1]                    ; R0 = [R1] (value)
	MOV32 R2, #0X01					;muevo uno en 32 bit
	ANDS R0, R2 						;verifica si el pin B0 es cero DS18B20
	CMP R0, #0						;lo compara con cero
	BNE es_uno_S2						;si no es cero se queda en el ciclo
	
;--------------------------------verifica si DS18B20 solto el bus----------------------------------	
	LDR R1, =GPIO_PORTFR        	; R1 = GPIO_PORTBW (pointer lectura pin B0)
es_cero_S2								;etiqueta de salto si no responde con uno  
	LDR R0, [R1]                    ; R0 = [R1] (value)
	MOV32 R2, #0X01					;muevo uno en 32 bit
	ANDS R0, R2						;verifica si el DS18B20 solto el bus RX=1 pin B0, Resistor pullup
	CMP R0, #0						;lo compara con cero
	BEQ es_cero_S2						;si es cero continua en el bucle
	BX LR
	
;----------------------FUNCIONES PARA ENVIAR CERO Y UNO AL DS18B20------

ENVIA_CERO_S2
	PUSH {R0, R1}
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (pointer escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    BIC R0, R0, #0x02               ; cero en el bit uno (MASTER TX RESET PULSE)
    STR R0, [R1]                    ; [R1] = R0  lo envia al puerto						
	REtardo	#75						;llamo retardo entre 60-120 useg
;-------------------------------------------------------------------------
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (pointer escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    ORR R0, R0, #0x02               ; coloca un uno en el bit uno
    STR R0, [R1]                    ; [R1] = R0  envia un uno (suelta bus TX, Resistor pullup)
	NOP								;tiempo 0.25 useg
	NOP								;tiempo 0.25 useg
	NOP								;tiempo 0.25 useg
	NOP								;tiempo 0.25 useg
	NOP
	POP {R0, R1}				;tiempo 0.25 useg
	BX LR
;----------------------------------------------------------------------------------
ENVIA_UNO_S2

	PUSH {R0, R1}
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (pointer escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    BIC R0, R0, #0x02               ; cero en el bit uno (MASTER TX RESET PULSE)
    STR R0, [R1]                    ; [R1] = R0  lo envia al puerto						
	NOP								;tiempo 0.25 useg
	NOP								;tiempo 0.25 useg
	NOP								;tiempo 0.25 useg
	NOP								;tiempo 0.25 useg
	NOP								;tiempo 0.25 useg
	NOP								;tiempo 0.25 useg
	NOP
	
;--------------------------------------------------------------------------------
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (pointer escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    ORR R0, R0, #0x02               ; coloca un uno en el bit uno
    STR R0, [R1]                    ; [R1] = R0  envia un uno (suelta bus TX, Resistor pullup)
	REtardo	#58						;llama retardo
	POP {R0, R1}				;restaura todo
	BX LR
;-----------------------------LECTURA DE SENSOR DE TEMPERATURA---------------------------

LECTURA_S2
	PUSH {R0, R1, R2, R3, R4}	;Salba los registros que se van a utilizar
	SUB R3, R3, R3					;borra registro que recibe dato inicia en cero
	
NUEVO_BIT_S2	
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (puntero de escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    BIC R0, R0, #0x02               ; cero en el bit uno (MASTER TX RESET PULSE)
    STR R0, [R1]                    ; [R1] = R0  pone el puerto en cero	
	NOP								; 0.25 useg
	NOP								; 0.25 useg
	NOP								; 0.25 useg
	NOP								; 0.25 useg
	NOP
	LDR R1, =GPIO_PORTFW        	; R1 = GPIO_PORTBW (puntero de escritura)
    LDR R0, [R1]                    ; R0 = [R1] le el puerto B pin 1
    ORR R0, R0, #0x02               ; coloca un uno en el bit uno pull up
    STR R0, [R1]                    ; [R1] = R0  envia un uno (suelta bus TX, Resistor pullup)
;----------------------------------------------------------------------------------------------
	REtardo	#14						;espera 13 useg
	LDR R1, =GPIO_PORTFR        	; R1 = GPIO_PORTBR (puntero de lectura) (0.5 useg)
    LDR R0, [R1]					;lee el dato en el pin B0 (0.25 useg)
;-----------validación--------------------------------------------------------------------------	
	MOV32 R2, #0X01					;muevo 0x01 al registro R2 (0.5 useg)
	ANDS R0, R0, R2					;verifica si es un cero (0.25 useg)
	CBZ  R0, PONCERO_S2				;si es cero salta a PONCERO (0.25 useg)
	ORR R3, R3, #0x00008000               ; si no es  coloca un uno en en el regitro de datos	(0.25 useg)
PONCERO_S2
	LSR R3, R3, #1					;lo rota una vez (0.25 useg)
	REtardo	#45
	SUBS R4, R4, #1					;decrementa el tamaño del dato   (0.25 useg)
	CBZ R4, FIN_S2
	B NUEVO_BIT_S2
FIN_S2
	STRT R3, [R5]
	POP {R0, R1, R2, R3, R4}
	BX LR

	ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file