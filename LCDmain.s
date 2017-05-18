;------------------------ Direcciones del Puerto J-----------------------------------------------
GPIO_PUERTOJ0                   EQU 0x40060004	; Como salida
GPIO_PUERTOJ_DIR_R              EQU 0x40060400	;Direccion
GPIO_PUERTOJ_AFSEL_R            EQU 0x40060420	;Funcion Alternativa
GPIO_PUERTOJ_DEN_R              EQU 0x4006051C  ;Digital Enable
GPIO_PUERTOJ_AMSEL_R            EQU 0x40060528  ;Analog Mode Select
GPIO_PUERTOJ_PCTL_R             EQU 0x4006052C	;Port Control
GPIO_PUERTOJ_PUR_R				EQU 0x40060510	;Pull-up
;----------------------------------------------------------------------	
SYSCTL_RCGCGPIO_RJ             EQU 0x400FE608
SYSCTL_RCGCGPIO_RJ8            EQU 0x00000100  ; GPIO Port J Run Mode Clock Gating Control
SYSCTL_PRGPIO_RJ               EQU 0x400FEA08
SYSCTL_PRGPIO_RJ8              EQU 0x00000100  ; GPIO Port J Peripheral Ready	
;-------------------------- Interrupciones -----------------------------------------------
GPIO_MASK_INTERRUPT		      EQU 0x40060410	;Pagina 750 de interrupciones
GPIO_SENSE_INTERRUPT		  EQU 0x40060404
GPIO_INTERRUPT_BOTH_EDGES	  EQU 0x40060408
GPIO_RISING_EDGE			  EQU 0x4006040C	
GPIO_INTERRUPT_CLEAR		  EQU 0x4006041C
ENABLE_VEC					  EQU 0xE000E104	;Este registro permite activar la interrupcion del puerto J pin 0, pag 152 
;----------------------------- PUERTO P ---------------------------------------
GPIO_PUERTOP0                   EQU 0x400653FC		;Se activan todos como ENTRADA
GPIO_PUERTOP_DIR_R              EQU 0x40065400
GPIO_PUERTOP_AFSEL_R            EQU 0x40065420
GPIO_PUERTOP_PUR_R              EQU 0x40065510
GPIO_PUERTOP_DEN_R              EQU 0x4006551C
GPIO_PUERTOP_AMSEL_R            EQU 0x40065528
GPIO_PUERTOP_PCTL_R             EQU 0x4006552C

SYSCTL_RCGCGPIO_RP             EQU 0x400FE608	;Base 0x400F.E000, Offset 0x608=> 1 activa puerto, 0 desactiva puerto
SYSCTL_PRGPIO_RP               EQU 0x400FEA08	;Base 0x400F.E000, Offset 0xA08 indica puerto listo
SYSCTL_RCGCGPIO_RP8            EQU 0x00002000  ; GPIO activa puerto P y 
SYSCTL_PRGPIO_RP8              EQU 0x00002000; GPIO Port J Peripheral ReadyVALOR_INICIAL
	
;----------------------INTERRUPCIONES PUERTO P-----------------------------------
GPIO_MASK_INTERRUPT_P		  EQU 0x40065410	;Pagina 750 de interrupciones
GPIO_SENSE_INTERRUPT_P		  EQU 0x40065404
GPIO_INTERRUPT_BOTH_EDGES_P	  EQU 0x40065408
GPIO_RISING_EDGE_P			  EQU 0x4006540C	
GPIO_INTERRUPT_CLEAR_P		  EQU 0x4006541C
ENABLE_VEC_P				  EQU 0xE000E108
;----------------------------- PUERTO Q ---------------------------------------
GPIO_PUERTOQ0                   EQU 0x400663FC		;Se activan todos como ENTRADA
GPIO_PUERTOQ_DIR_R              EQU 0x40066400
GPIO_PUERTOQ_AFSEL_R            EQU 0x40066420
GPIO_PUERTOQ_PUR_R              EQU 0x40066510
GPIO_PUERTOQ_DEN_R              EQU 0x4006651C
GPIO_PUERTOQ_AMSEL_R            EQU 0x40066528
GPIO_PUERTOQ_PCTL_R             EQU 0x4006652C

SYSCTL_RCGCGPIO_RQ             EQU 0x400FE608	;Base 0x400F.E000, Offset 0x608=> 1 activa puerto, 0 desactiva puerto
SYSCTL_PRGPIO_RQ               EQU 0x400FEA08	;Base 0x400F.E000, Offset 0xA08 indica puerto listo
SYSCTL_RCGCGPIO_RQ8             EQU 0x00004000  ; GPIO activa puerto P y 
SYSCTL_PRGPIO_RQ8               EQU 0x00004000; GPIO Port J Peripheral ReadyVALOR_INICIAL
	
;----------------------INTERRUPCIONES PUERTO Q-----------------------------------
GPIO_MASK_INTERRUPT_Q		  EQU 0x40066410	;Pagina 750 de interrupciones
GPIO_SENSE_INTERRUPT_Q		  EQU 0x40066404
GPIO_INTERRUPT_BOTH_EDGES_Q	  EQU 0x40066408
GPIO_RISING_EDGE_Q			  EQU 0x4006640C	
GPIO_INTERRUPT_CLEAR_Q		  EQU 0x4006641C
ENABLE_VEC_Q				  EQU 0xE000E108
;------------------------------------------------------------------------------
CONVERTTEMP 	EQU 0x44	;Convert T 
RSCRATCHPAD 	EQU 0xbe	;Read Scratchpad	
WSCRATCHPAD 	EQU 0x4e	;Write Scratchpad
CPYSCRATCHPAD 	EQU 0x48	;Copy Scractchap
RECEEPROM  		EQU 0xb8	;Recall E+2
RPWRSUPPLY 		EQU 0xb4	;Read Power Supply
SEARCHROM 		EQU 0xf0	;Search Rom
READROM 		EQU 0x33    ;Read Rom 
MATCHROM 		EQU 0x55	;Match Rom
SKIPROM 		EQU 0xcc	;Skip Rom
ALARMSEARCH 	EQU 0xec	;Alarma Searach Rom
;----------------------------------------------------------------------------
			AREA    DATA, READWRITE, ALIGN=2
CONTA    	SPACE   4
CONTA1      SPACE   2
TEMPERATURA SPACE	6
S1_TEMP1	SPACE	4
S1_TEMP2	SPACE	4
S1_TEMP3	SPACE	4		
VALOR_CRC	SPACE	8
;-----------------------------------------------------------------------------	
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT Start
        IMPORT UP_LCD
		IMPORT LCD_DELAY
		IMPORT LCD_INI
		IMPORT LCD_E
		IMPORT LCD_DATO
		IMPORT LCD_REG
        IMPORT FUNCION_SET
		IMPORT BORRA_Y_HOME
		IMPORT DISPLAY_ON_CUR_OFF
		EXPORT TABLA 
		EXPORT CONTA1
		IMPORT RETURN_HOMER
;SENSOR 1			
		IMPORT UP_DS18B20
		IMPORT INI_reset
		IMPORT ENVIA_CERO
		IMPORT ENVIA_UNO
		IMPORT LECTURA			
		IMPORT DELAY_480
			
;INTERRUPCIONES			
		EXPORT SALTA1
		EXPORT SALTA2
		EXPORT SALTA3


;************************************
;		   AREA DE MACROS
;************************************
		MACRO
		RECIBE $DIREC
		PUSH {R4, R5}
		SUB R4, R4, R4
		MOV32 R4, #15
		LDR.W R5, $DIREC
		BL	LECTURA
		POP {R4, R5}
		MEND
;--------------------------------------
		MACRO
		REtardo $VALOR
		PUSH {R7, LR}
		MOV R7, $VALOR
		LSL R7, R7, #2
		BL DELAY_480
		POP {R7,LR}
		MEND
;-------------------------------------
		MACRO
		INICIAR $TEMPERATURA
		BL INI_reset
		COMANDO #SKIPROM
		COMANDO #CONVERTTEMP
		BL INI_reset	
		COMANDO #SKIPROM
		COMANDO #RSCRATCHPAD
		RECIBE  $TEMPERATURA
		BL INI_reset
		BL BORRA_Y_HOME
		BL CONVIERTETEMP
		MEND
;---------------------------------------

	MACRO
	COMANDO $COM
	PUSH {R4, R5}
	MOV R5, #0x08
	MOV R4, $COM
0
	TST R4, #0x001
	BEQ %FT2
	B   %FT1
1
    BL ENVIA_UNO
	B %FT3
2
	BL ENVIA_CERO
3
	SUB R5, R5, #1
	CBZ R5, %FT4
	LSR R4, R4, #0x01
	B   %BT0
4
	POP {R4, R5}
	MEND
;------------------------------------	
			
TABLA DCB 0X40, 0XF9, 0XA4, 0XB0, 0X99, 0X92, 0X82, 0XF8, 0X80, 0X98

Start	
;---------------------------------------------------------------
;		                     PUERTO J
;---------------------------------------------------------------
	; activate clock for Port J
    LDR.W R1, =SYSCTL_RCGCGPIO_RJ      ; R1 = SYSCTL_RCGCGPIO_RJ (pointer), va a tomar el valor y lo guarda en el registro
    LDR R0, [R1]                    ; R0 = [R1] (value), lee lo que esta en el registro
    ORR R0, R0, #SYSCTL_RCGCGPIO_RJ8 ; R0 = R0|SYSCTL_RCGCGPIO_RJ8, una OR con lo que esta en R0
    STR R0, [R1]                    ; [R1] = R0
	; allow time for clock to stabilize
    LDR.W R1, =SYSCTL_PRGPIO_RJ        ; R1 = SYSCTL_PRGPIO_RJ (pointer)
GPIOJinitloop1
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ANDS R0, R0, #SYSCTL_PRGPIO_RJ8  ; R0 = R0&SYSCTL_PRGPIO_RJ8
    BEQ GPIOJinitloop1             ; if(R0 == 0), keep polling
   
   ; set direction register
    LDR.W R1, =GPIO_PUERTOJ_DIR_R       ; R1 = GPIO_PUERTOJ_DIR_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0x01               ; R0 = R0&~0x01 (make PJ0 in (PJ0 built-in SW1))
	AND R0,R8
	STR R0, [R1]                    ; [R1] = R0
    
	; set alternate function register
    LDR.W R1, =GPIO_PUERTOJ_AFSEL_R     ; R1 = GPIO_PUERTOJ_AFSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0x01    ;0X01           ; R0 = R0&~0x01 (disable alt funct on PJ0)
    STR R0, [R1]                    ; [R1] = R0
    
	; set pull-up register
    LDR.W R1, =GPIO_PUERTOJ_PUR_R       ; R1 = GPIO_PUERTOJ_PUR_RR (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0x01     ;0X01          ; R0 = R0|0x01 (enable pull-up on PJ0)
    STR R0, [R1]                    ; [R1] = R0
   
   ; set digital enable register
    LDR.W R1, =GPIO_PUERTOJ_DEN_R       ; R1 = GPIO_PUERTOJ_DEN_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0X01        ;0X01      ; R0 = R0|0x01 (enable digital I/O on PJ0)
    STR R0, [R1]                    ; [R1] = R0
    
	; set port control register
    LDR.W R1, =GPIO_PUERTOJ_PCTL_R      ; R1 = GPIO_PUERTOJ_PCTL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0x0000000F         ; R0 = R0&0xFFFFFFF0 (clear bit0 field)
    ADD R0, R0, #0x00000000         ; R0 = R0+0x00000000 (configure PJ0 as GPIO)
    STR R0, [R1]                    ; [R1] = R0
    
	; set analog mode select register
    LDR.W R1, =GPIO_PUERTOJ_AMSEL_R     ; R1 = GPIO_PORTJ_AMSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0x01   ;0X01               ; R0 = R0&~0x01 (disable analog functionality on PJ0)
    STR R0, [R1]                    ; [R1] = R0
	
    LDR.W R4, =GPIO_PUERTOJ0            ; R4 = GPIO_PORTJ0 (pointer)

;---------------------------------------------------------------
;		                     PUERTO P
;---------------------------------------------------------------
	; activate clock for Port P
    LDR.W R1, =SYSCTL_RCGCGPIO_RP      ; R1 = SYSCTL_RCGCGPIO_RJ (pointer), va a tomar el valor y lo guarda en el registro
    LDR R0, [R1]                    ; R0 = [R1] (value), lee lo que esta en el registro
    ORR R0, R0, #SYSCTL_RCGCGPIO_RP8 ; R0 = R0|SYSCTL_RCGCGPIO_RJ8, una OR con lo que esta en R0
    STR R0, [R1]                    ; [R1] = R0
    
	
	; allow time for clock to stabilize
    LDR.W R1, =SYSCTL_PRGPIO_RP        ; R1 = SYSCTL_PRGPIO_RJ (pointer)
GPIOJinitloop2
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ANDS R0, R0, #SYSCTL_PRGPIO_RP8  ; R0 = R0&SYSCTL_PRGPIO_RJ8
    BEQ GPIOJinitloop2            ; if(R0 == 0), keep polling
   
   ; set direction register
    LDR.W R1, =GPIO_PUERTOP_DIR_R       ; R1 = GPIO_PUERTOJ_DIR_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    MOV  R0,#0X00					;Entrada desd P0-P7
	STR R0, [R1]                    ; [R1] = R0
    
	; set alternate function register
    LDR.W R1, =GPIO_PUERTOP_AFSEL_R     ; R1 = GPIO_PUERTOJ_AFSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
	MOV R0,#0X00
    STR R0, [R1]                    ; [R1] = R0
    
	; set pull-up register
    LDR.W R1, =GPIO_PUERTOP_PUR_R       ; R1 = GPIO_PUERTOJ_PUR_RR (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
	MOV R0,#0XFF;
    STR R0, [R1]                    ; [R1] = R0
   
   ; set digital enable register
    LDR.W R1, =GPIO_PUERTOP_DEN_R       ; R1 = GPIO_PUERTOJ_DEN_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
	MOV R0, #0XFF
    STR R0, [R1]                    ; [R1] = R0
    
	; set port control register
    LDR.W R1, =GPIO_PUERTOP_PCTL_R      ; R1 = GPIO_PUERTOJ_PCTL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0x0000000F         ; R0 = R0&0xFFFFFFF0 (clear bit0 field)
    ADD R0, R0, #0x00000000         ; R0 = R0+0x00000000 (configure PJ0 as GPIO)
    STR R0, [R1]                    ; [R1] = R0
    
	; set analog mode select register
    LDR.W R1, =GPIO_PUERTOP_AMSEL_R     ; R1 = GPIO_PORTJ_AMSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
	mov R0,#0x00
    STR R0, [R1]                    ; [R1] = R0
	
    LDR.W R4, =GPIO_PUERTOP0            ; R4 = GPIO_PORTJ0 (pointer)
	LDR R3,[R4]

;---------------------------------------------------------------
;		                     PUERTO Q
;---------------------------------------------------------------
	; activate clock for Port P
    LDR.W R1, =SYSCTL_RCGCGPIO_RQ      ; R1 = SYSCTL_RCGCGPIO_RJ (pointer), va a tomar el valor y lo guarda en el registro
    LDR R0, [R1]                    ; R0 = [R1] (value), lee lo que esta en el registro
    ORR R0, R0, #SYSCTL_RCGCGPIO_RQ8 ; R0 = R0|SYSCTL_RCGCGPIO_RJ8, una OR con lo que esta en R0
    STR R0, [R1]                    ; [R1] = R0
    
	
	; allow time for clock to stabilize
    LDR.W R1, =SYSCTL_PRGPIO_RQ        ; R1 = SYSCTL_PRGPIO_RJ (pointer)
GPIOJinitloop3
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ANDS R0, R0, #SYSCTL_PRGPIO_RQ8  ; R0 = R0&SYSCTL_PRGPIO_RJ8
    BEQ GPIOJinitloop3            ; if(R0 == 0), keep polling
   
   ; set direction register
    LDR.W R1, =GPIO_PUERTOQ_DIR_R       ; R1 = GPIO_PUERTOJ_DIR_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    MOV  R0,#0X00					;Entrada desd P0-P7
	STR R0, [R1]                    ; [R1] = R0
    
	; set alternate function register
    LDR.W R1, =GPIO_PUERTOQ_AFSEL_R     ; R1 = GPIO_PUERTOJ_AFSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
	MOV R0,#0X00
    STR R0, [R1]                    ; [R1] = R0
    
	; set pull-up register
    LDR.W R1, =GPIO_PUERTOQ_PUR_R       ; R1 = GPIO_PUERTOJ_PUR_RR (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
	MOV R0,#0XFF;
    STR R0, [R1]                    ; [R1] = R0
   
   ; set digital enable register
    LDR.W R1, =GPIO_PUERTOQ_DEN_R       ; R1 = GPIO_PUERTOJ_DEN_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
	MOV R0, #0XFF
    STR R0, [R1]                    ; [R1] = R0
    
	; set port control register
    LDR.W R1, =GPIO_PUERTOQ_PCTL_R      ; R1 = GPIO_PUERTOJ_PCTL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0x0000000F         ; R0 = R0&0xFFFFFFF0 (clear bit0 field)
    ADD R0, R0, #0x00000000         ; R0 = R0+0x00000000 (configure PJ0 as GPIO)
    STR R0, [R1]                    ; [R1] = R0
    
	; set analog mode select register
    LDR.W R1, =GPIO_PUERTOQ_AMSEL_R     ; R1 = GPIO_PORTJ_AMSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
	mov R0,#0x00
    STR R0, [R1]                    ; [R1] = R0
	
    LDR.W R4, =GPIO_PUERTOQ0            ; R4 = GPIO_PORTJ0 (pointer)
	LDR R3,[R4]
;-----------------------------------------------------------------------------
;                               INTERRUPCIONES J
;-----------------------------------------------------------------------------
	
;************** SSR_Mask **************
;La interrupcion del pin correspondiente se manda al controlador de interrupcion

	LDR.W R1, =GPIO_MASK_INTERRUPT         ; R1 = GPIO_MASK_INTERRUPT (pointer)
    LDR R0, [R1]                   		 ; R0 = [R1] (value)
    ORR R0, R0, #0x01               	 ; R0 = R0|0x01
    STR R0, [R1] 						 ; [R1] = R0

;************** SSR_Sense **************
;GPIOIS - Se activa la interrupcion por nivel

	LDR.W R1, =GPIO_SENSE_INTERRUPT    		; R1 = GPIO_SENSE_INTERRUPT   (pointer)
    LDR R0, [R1]                   			; R0 = [R1] (value)
    AND R0, R0, #0x00               		; R0 = R0|0x00
    STR R0, [R1] 							; [R1] = R0
	
;**************- SSR_Both_Edges **************			
;GPIOIBE - La generación de interrupcion es controlada por GPIO Interrupt Event (GPIOIEV)
	
	LDR.W R1, =GPIO_INTERRUPT_BOTH_EDGES      ; R1 = GPIO_INTERRUPT_BOTH_EDGES (pointer)
    LDR R0, [R1]                   			; R0 = [R1] (value)
    AND R0, R0, #0x00               		; R0 = R0|0x00
    STR R0, [R1] 							; [R1] = R0
	
;************** SSR_Clear **************
;La interrupcion correspondiente se limpia

	LDR.W R1,=GPIO_INTERRUPT_CLEAR			; R1 = GPIO_INTERRUPT_CLEAR (pointer)
	LDR R0,[R1]								; R0 = [R1] (value)
	ORR R0, R0, #0xFF						; R0 = R0|0xFF
	STR R0,[R1]    							; [R1] = R0

;************** SSR_Rising **************
;GPIOIEV - Para activiar que la interrupción por nivel sea por franco de subida

	LDR.W R1, =GPIO_RISING_EDGE      	; R1 = GPIO_RISING_EDGE 
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0x01               ; R0 = R0|0x01
    STR R0, [R1] 					; [R1] = R0

;Activar las interrupcones del 32-63, interrupcion del PORTJ esta en la 51
	LDR.W R1,=ENABLE_VEC					; R1 =ENABLE_VEC (pointer)
	LDR R0,[R1]							 ; R0 = [R1] (value)
	ORR R0, R0, #0x80000				; R0 = R0|0x80000 
	STR R0,[R1]							; [R1] = R0
	
;-------------------------------------------------------------
;                          INTERRUPCIONES P
;-------------------------------------------------------------
	
;************** SSR_Mask **************
;La interrupcion del pin correspondiente se manda al controlador de interrupcion

	LDR.W R1, =GPIO_MASK_INTERRUPT_P         ; R1 = GPIO_MASK_INTERRUPT (pointer)
    LDR R0, [R1]                   		 ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               	 ; R0 = R0|0x01
    STR R0, [R1] 						 ; [R1] = R0

;************** SSR_Sense **************
;GPIOIS - Se activa la interrupcion por nivel

	LDR.W R1, =GPIO_SENSE_INTERRUPT_P   		; R1 = GPIO_SENSE_INTERRUPT   (pointer)
    LDR R0, [R1]                   			; R0 = [R1] (value)
    AND R0, R0, #0xFF               		; R0 = R0|0x00
    STR R0, [R1] 							; [R1] = R0
	
;**************- SSR_Both_Edges **************			
;GPIOIBE - La generación de interrupcion es controlada por GPIO Interrupt Event (GPIOIEV)
	
	LDR.W R1, =GPIO_INTERRUPT_BOTH_EDGES_P      ; R1 = GPIO_INTERRUPT_BOTH_EDGES (pointer)
    LDR R0, [R1]                   			; R0 = [R1] (value)
    AND R0, R0, #0x00               		; R0 = R0|0x00
    STR R0, [R1] 							; [R1] = R0
	
;************** SSR_Clear **************
;La interrupcion correspondiente se limpia

	LDR.W R1,=GPIO_INTERRUPT_CLEAR_P			; R1 = GPIO_INTERRUPT_CLEAR (pointer)
	LDR R0,[R1]								; R0 = [R1] (value)
	ORR R0, R0, #0xFF						; R0 = R0|0xFF
	STR R0,[R1]    							; [R1] = R0

;************** SSR_Rising **************
;GPIOIEV - Para activiar que la interrupción por nivel sea por franco de subida

	LDR.W R1, =GPIO_RISING_EDGE_P      	; R1 = GPIO_RISING_EDGE 
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0|0x01
    STR R0, [R1] 					; [R1] = R0

;Activar las interrupcones del 32-63, interrupcion del PORTJ esta en la 51
	LDR.W R1,=ENABLE_VEC_P					; R1 =ENABLE_VEC (pointer)
	LDR R0,[R1]							 ; R0 = [R1] (value)
	ORR R0, R0, #0x000FF000				; R0 = R0|0x80000 
	STR R0,[R1]							; [R1] = R0
		
;-------------------------------------------------------------
;                          INTERRUPCIONES Q
;-------------------------------------------------------------
	
;************** SSR_Mask **************
;La interrupcion del pin correspondiente se manda al controlador de interrupcion

	LDR.W R1, =GPIO_MASK_INTERRUPT_Q         ; R1 = GPIO_MASK_INTERRUPT (pointer)
    LDR R0, [R1]                   		 ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               	 ; R0 = R0|0x01
    STR R0, [R1] 						 ; [R1] = R0

;************** SSR_Sense **************
;GPIOIS - Se activa la interrupcion por nivel

	LDR.W R1, =GPIO_SENSE_INTERRUPT_Q   		; R1 = GPIO_SENSE_INTERRUPT   (pointer)
    LDR R0, [R1]                   			; R0 = [R1] (value)
    AND R0, R0, #0xFF               		; R0 = R0|0x00
    STR R0, [R1] 							; [R1] = R0
	
;**************- SSR_Both_Edges **************			
;GPIOIBE - La generación de interrupcion es controlada por GPIO Interrupt Event (GPIOIEV)
	
	LDR.W R1, =GPIO_INTERRUPT_BOTH_EDGES_Q      ; R1 = GPIO_INTERRUPT_BOTH_EDGES (pointer)
    LDR R0, [R1]                   			; R0 = [R1] (value)
    AND R0, R0, #0x00               		; R0 = R0|0x00
    STR R0, [R1] 							; [R1] = R0
	
;************** SSR_Clear **************
;La interrupcion correspondiente se limpia

	LDR.W R1,=GPIO_INTERRUPT_CLEAR_Q			; R1 = GPIO_INTERRUPT_CLEAR (pointer)
	LDR R0,[R1]								; R0 = [R1] (value)
	ORR R0, R0, #0xFF						; R0 = R0|0xFF
	STR R0,[R1]    							; [R1] = R0

;************** SSR_Rising **************
;GPIOIEV - Para activiar que la interrupción por nivel sea por franco de subida

	LDR.W R1, =GPIO_RISING_EDGE_Q      	; R1 = GPIO_RISING_EDGE 
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0|0x01
    STR R0, [R1] 					; [R1] = R0

;Activar las interrupcones del 32-63, interrupcion del PORTJ esta en la 51
	LDR.W R1,=ENABLE_VEC_Q					; R1 =ENABLE_VEC (pointer)
	LDR R0,[R1]							 ; R0 = [R1] (value)
	ORR R0, R0, #0x0FF00000				; R0 = R0|0x80000 
	STR R0,[R1]							; [R1] = R0
		

;---------------------------------------------------------
	BL  UP_LCD
	BL FUNCION_SET
	BL BORRA_Y_HOME
	BL DISPLAY_ON_CUR_OFF
	BL UP_DS18B20
	
;--------------------- SENSOR 1 ----------------------------	
	INICIAR =S1_TEMP1
	MOV32 R7, #4000000
	BL DELAY_480
	MOV32 R7, #2000000
	BL DELAY_480
	BL BORRA_Y_HOME
	
	INICIAR =S1_TEMP2
	MOV32 R7, #4000000
	BL DELAY_480
	MOV32 R7, #2000000
	BL DELAY_480
	BL BORRA_Y_HOME
	
	INICIAR =S1_TEMP3
	MOV32 R7, #4000000
	BL DELAY_480
	MOV32 R7, #2000000
	BL DELAY_480
	BL BORRA_Y_HOME
GO
	B GO
	
;****************************************************************************
;									MAIN
;****************************************************************************
	
CONVIERTETEMP
	PUSH {LR}
	TST R1, #0X08000
	BEQ POSITIVO
	NEG R1, R1
	LSL R1,R1,#16
	LSR R1,R1,#16
	LDR R6, ="-"		;R6 = "-"
	PUSH {R1,R0}		;Push registers onto a full descending stack
	BL LCD_DATO
	POP {R1,R0}			;Pop registers off a full descending stack.
	B BRINCA
	
POSITIVO
	LDR R6, ="+"		;R6 = "+"
	PUSH {R1, R0}
	BL LCD_DATO
	POP {R1, R0}

;-------------- PARTE ENTERA -------------
BRINCA
	MOV R2, R1			
	LSR R1, R1, #4		

; **** CENTENAS ****
	MOV32 R3, #100		;100 -> R3; 
	UDIV R4, R1, R3 	;Division sin signo, R1 / R3 -> R4
	MUL R7, R4, R3		;R4 * R3 -> R7
	SUB R7, R1, R7		;R1 - R7 -> R7
	ORR R4, #0X30		;OR R4 | 0x30
	MOV R6, R4			;R4 -> R6
	PUSH {R1,R2,R4,R7}
	BL LCD_DATO			;Brinca a LCD_DATO
	POP {R1,R2,R4,R7}

; **** DECENAS ****
	MOV32 R3, #10		;10 -> R3
	UDIV R4, R7, R3		;R7 / R3 -> R4
	MUL R8, R4, R3		;R4 * R3 -> R8
	SUB R7, R7,R8		;R7 - R8 -> R7
	ORR	  R4, #0x30		;OR R4 | 0x30
	MOV   R6, R4		;R4 -> R6
	PUSH {R2,R7}
	BL	  LCD_DATO   
	POP {R2,R7}
	
; **** UNIDADES ****	
	ORR   R7,#0x30		;OR R7 | 0x30
	MOV   R6, R7		;R7 -> R6
	PUSH {R2}
	BL    LCD_DATO   
	POP {R2}

	LDR   R6, ='.'		;R6 = "."
	PUSH {R2}
	BL    LCD_DATO	
	POP {R2}
	
;------------- PARTE DECIMAL ------------
    AND   R2, R2, #0x00F 
	MOV32 R3, #625
	MUL   R4, R2, R3
	
; **** MILLAR ****		
	MOV32 R3, #1000		;1000 -> R3
	UDIV  R8, R4, R3	;R4 / R3 -> R8
	MUL	  R7, R8, R3	;R8 * R3 -> R7
	SUB   R7, R4, R7	;R4 - R7 -> R7
	ORR	  R8, #0x30		;OR R8 | 0x30
	MOV   R6, R8 		;R8 -> R6
	PUSH  {R4,R7}
	BL	  LCD_DATO
    POP  {R4, R7}

; **** CENTENAS ****	
	MOV32 R3, #100		;100 -> R3
	UDIV  R9, R7, R3	;R7 / R3 -> R9
	MUL	  R8, R9, R3	;R9 * R3 -> R8
	SUB   R8, R7, R8	;R7 - R8 -> R8
	ORR	  R9, #0x30		;OR R9 | 0x30
	MOV   R6, R9		;R9 -> R6
    PUSH  {R8}	
	BL	  LCD_DATO
	POP  {R8}

; **** DECENAS ****
	MOV32 R3, #10		;10 -> R3
	UDIV  R5, R8, R3	;R8 / R3 -> R5
	MUL	  R9, R5, R3	;R5 * R3 -> R9
	SUB   R9, R8, R9	;R8 - R9 -> R9
	ORR	  R5, #0x30		;OR R5 | 0x30
	MOV   R6, R5		;R5 -> R6
    PUSH  {R9, R5}	
	BL	  LCD_DATO
	POP   {R9, R5}

; **** UNIDADES ****
	ORR   R9, #0x30		;OR R9 | 0x30
	MOV   R6, R9		;R9 -> R6
	PUSH  {R9}
	BL    LCD_DATO
	POP   {R9}
	POP   {LR}
	
    BX LR

;-----------------------------------------------------------------
;INTERRUPCIONES
;-----------------------------------------------------------------
;-------------------------------SENSOR 1---------------------------

SALTA1
; 		**** Limpiar registro de inrerrupciones ****
	LDR.W R1, =GPIO_INTERRUPT_CLEAR_P   ; R1 = GPIOICR_J (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0|0xFF (Limpiar registro)
    STR R0, [R1]                    ; [R1] = R0
Repite
	PUSH {LR}
	MOV R6, #0x80
	ADD R6, #0X43
	BL LCD_REG
	POP {LR}
	PUSH{LR}
	LDR R6, ='T'
	BL LCD_DATO 
	LDR R6, ='1'
	BL LCD_DATO 
	LDR R6, =':'
	BL LCD_DATO
	LDR R6, =' '
	BL LCD_DATO
	POP{LR}
	
	PUSH {LR}
	MOV R6, #0x80
	BL LCD_REG
	POP {LR}
	
	LDR.W R0,=S1_TEMP1;
	LDR R1, [R0];
	
	PUSH {LR}
	BL CONVIERTETEMP
	POP {LR}
	
	PUSH{LR}
	LDR R6, ='°'
	BL LCD_DATO
	LDR R6, ='C'
	BL LCD_DATO
	POP{LR}
	
	BX LR

;---------------------------------------------------------------------

SALTA2
; 		**** Limpiar registro de inrerrupciones ****
	LDR.W R1, =GPIO_INTERRUPT_CLEAR_P   ; R1 = GPIOICR_J (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0|0xFF (Limpiar registro)
    STR R0, [R1]                    ; [R1] = R0

	PUSH {LR}
	MOV R6, #0x80
	ADD R6, #0X43
	BL LCD_REG
	POP {LR}
	PUSH{LR}
	LDR R6, ='T'
	BL LCD_DATO  
	LDR R6, ='2'
	BL LCD_DATO 
	LDR R6, =':'
	BL LCD_DATO
	LDR R6, =' '
	BL LCD_DATO
	POP {LR}
	
	PUSH {LR}
	MOV R6, #0x80
	BL LCD_REG
	POP {LR}
	
	LDR.W R0,=S1_TEMP2;
	LDR R1, [R0];
	PUSH {LR}
	BL CONVIERTETEMP
	POP {LR}
	
	PUSH{LR}
	LDR R6, ='°'
	BL LCD_DATO
	LDR R6, ='C'
	BL LCD_DATO
	POP{LR}
	BX LR
;---------------------------------------------------------------------

SALTA3
; 		**** Limpiar registro de inrerrupciones ****
	LDR R1, =GPIO_INTERRUPT_CLEAR_P   ; R1 = GPIOICR_J (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0|0xFF (Limpiar registro)

	PUSH {LR}
	MOV R6, #0x80
	ADD R6, #0X43
	BL LCD_REG
	POP {LR}
	PUSH {LR}
	LDR R6, ='T'
	BL LCD_DATO 
	LDR R6, ='3'
	BL LCD_DATO 
	LDR R6, =':'
	BL LCD_DATO
	LDR R6, =' '
	BL LCD_DATO
	POP {LR}
	
	PUSH {LR}
	MOV R6, #0x80
	BL LCD_REG
	POP {LR}
	
	LDR R0,=S1_TEMP3;
	LDR R1, [R0];
	PUSH {LR}
	BL CONVIERTETEMP
	POP {LR}
	
	PUSH{LR}
	LDR R6, ='°'
	BL LCD_DATO
	LDR R6, ='C'
	BL LCD_DATO
	POP{LR}
	
	BX LR

aqui
	B aqui
	
    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file