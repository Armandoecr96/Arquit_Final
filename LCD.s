; SSR.s
;*******************Direcciones del puerto D**********************************************
GPIO_PORTN1                   EQU 0x4005B3FC	;GPIO Port D (AHB) 0x4005B000 base de datos
GPIO_PORTN_DIR_R              EQU 0x4005B400	;Offset 0x400=>  0 es entrada, 1 salida
GPIO_PORTN_AFSEL_R            EQU 0x4005B420	;Offset 0x420=>  0 funcion como GPIO, 1 funciona como periferico
GPIO_PORTN_DEN_R              EQU 0x4005B51C	;Offset 0x51C=>  0 funcina como NO digital, 1 funcion digital
GPIO_PORTN_AMSEL_R            EQU 0x4005B528	;Offset 0x528=>  0 Deshabilita funcion analogica, 1 activa analogica
GPIO_PORTN_PCTL_R             EQU 0x4005B52C	;Offset 0x52C=>  0 Selecciona funcion alternativa
GPIO_PORTN_LOCK				  EQU 0X4005B520
GPIO_PORTN_CR				  EQU 0X4005B524

;--------Direccion para activar y verificar puertos------------------------------------------
SYSCTL_RCGCGPIO_R             EQU 0x400FE608	;Base 0x400F.E000, Offset 0x608=> 1 activa puerto, 0 desactiva puerto
SYSCTL_PRGPIO_R               EQU 0x400FEA08	;Base 0x400F.E000, Offset 0xA08 indica puerto listo
SYSCTL_RCGCGPIO_R12           EQU 0x00000008  	;1 Enable and provide a clock to GPIO Port D in Run mode
SYSCTL_PRGPIO_R12             EQU 0x00000008    ;Bandera puerto listo D
	
;*******************Direcciones del puerto E**********************************************
GPIO_PORTJ0                   EQU 0x4005C0FC		;Se activan todos como salida
GPIO_PORTJ_DIR_R              EQU 0x4005C400
GPIO_PORTJ_AFSEL_R            EQU 0x4005C420
GPIO_PORTJ_PUR_R              EQU 0x4005C510
GPIO_PORTJ_DEN_R              EQU 0x4005C51C
GPIO_PORTJ_AMSEL_R            EQU 0x4005C528
GPIO_PORTJ_PCTL_R             EQU 0x4005C52C

SYSCTL_RCGCGPIO_R8            EQU 0x00000010  ; GPIO activa puerto A y 
SYSCTL_PRGPIO_R8              EQU 0x00000010; GPIO Port J Peripheral ReadyVALOR_INICIAL

;**********************Direccion para activar SysTick***************************
SYSCTL_STCURRENT			  EQU 0XE000E018
SYSCTL_STRELOAD				  EQU 0XE000E014
SYSCTL_STCTRL				  EQU 0XE000E010
;-------------------------------------------------------------------------------


        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        
		IMPORT Start
		EXPORT UP_LCD
		EXPORT LCD_DELAY
		EXPORT LCD_E
		EXPORT LCD_BUSY
		EXPORT LCD_DATO
		EXPORT LCD_REG
		EXPORT LCD_INI
		EXPORT FUNCION_SET
		EXPORT BORRA_Y_HOME
		EXPORT DISPLAY_ON_CUR_OFF
		EXPORT RETURN_HOMER			
;-------------------------------------------------------------------------------------------
;Rutinas para el manejo del LCD
;-------------------------------------------------------------------------------------------
;UP_LCD: Configuracion el puerto D como salida, bus de datos del LCD.
		
			
;------------configura puerta D como Salida-----------------------------------------
UP_LCD

    ; activa reloj para el puerto D
    LDR R1, =SYSCTL_RCGCGPIO_R      ; R1 = SYSCTL_RCGCGPIO_R direccion que  1 activa puerto
    LDR R0, [R1]                    ; R0 = [R1] lee valor
    ORR R0, R0, #SYSCTL_RCGCGPIO_R12; R0 = R0|SYSCTL_RCGCGPIO_R12, activa reloj de puerto
    STR R0, [R1]                    ; [R1] = R0  se guarda
	
    ;Verifica si el reloj es estable
    LDR R1, =SYSCTL_PRGPIO_R        ; R1 = SYSCTL_PRGPIO_R (pointer)
GPIONinitloop
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ANDS R0, R0, #SYSCTL_PRGPIO_R12 ; R0 = R0&SYSCTL_PRGPIO_R12
    BEQ GPIONinitloop               ; if(R0 == 0), keep polling
;-----------------------------------------	
	;desbloqueo del pin 7 puerto D
	LDR R1, =GPIO_PORTN_LOCK
	MOV32 R0, #0X4C4F434B
	STR R0, [R1]
	
	 ;Verifica si se desbloqueo
    LDR R1, =GPIO_PORTN_LOCK        ; R1 = GPIO_PORTN_LOCK (pointer)
GPIOUNLOCKinitloop
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ANDS R0, R0, #0X00000001 ; R0 = R0&SYSCTL_PRGPIO_R12
    BNE GPIOUNLOCKinitloop               ; if(R0 == 0), keep polling
	
	;Desbloquea el pin D7
	LDR R1, =GPIO_PORTN_CR		
	LDR R0, [R1]
	ORR R0, R0, #0X0080
	STR R0, [R1]
	
	
    ; Direccion de salida
    LDR R1, =GPIO_PORTN_DIR_R       ; R1 = GPIO_PORTN_DIR_R 
    LDR R0, [R1]                    ; R0 = [R1] 
    ORR R0, R0, #0xFF               ; R0 = R0|0xFF (todos los pines del puerto D salida)
    STR R0, [R1]                    ; [R1] = R0
	
	
    ; Registro de funcion alternativa
    LDR R1, =GPIO_PORTN_AFSEL_R     ; R1 = GPIO_PORTN_AFSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFF               ; R0 = R0&~0x02 (disable alt funct on PN1)
    STR R0, [R1]                    ; [R1] = R0
	
    ; set digital enable register
    LDR R1, =GPIO_PORTN_DEN_R       ; R1 = GPIO_PORTN_DEN_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0|0xFF (activa digital I/O  PD0-PD7)
    STR R0, [R1]                    ; [R1] = R0
	
    ; set port control register
    LDR R1, =GPIO_PORTN_PCTL_R      ; R1 = GPIO_PORTN_PCTL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFFFFFFFF         ; R0 = R0&0xFFFFFFFF (clear bit1 field)
    STR R0, [R1]                    ; [R1] = R0
	
	
    ; set analog mode select register
    LDR R1, =GPIO_PORTN_AMSEL_R     ; R1 = GPIO_PORTN_AMSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFF               ; R0 = R0&~0xFF (disable analog functionality on PD0-PD7)
    STR R0, [R1]                    ; [R1] = R0
	
	
	
;------------Configura puerto A como salida-------------------------------------------------
   
    ; activate clock for Port J
    LDR R1, =SYSCTL_RCGCGPIO_R      ; R1 = SYSCTL_RCGCGPIO_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #SYSCTL_RCGCGPIO_R8 ; R0 = R0|SYSCTL_RCGCGPIO_R8
    STR R0, [R1]                    ; [R1] = R0
	
    ; allow time for clock to stabilize
    LDR R1, =SYSCTL_PRGPIO_R        ; R1 = SYSCTL_PRGPIO_R (pointer)
	
GPIOJinitloop
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ANDS R0, R0, #SYSCTL_PRGPIO_R8  ; R0 = R0&SYSCTL_PRGPIO_R8
    BEQ GPIOJinitloop               ; if(R0 == 0), keep polling
	
    ; set direction register
    LDR R1, =GPIO_PORTJ_DIR_R       ; R1 = GPIO_PORTJ_DIR_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0&~0x01 (make PJ0 in (PJ0 built-in SW1))
    STR R0, [R1]                    ; [R1] = R0
	
    ; set alternate function register
    LDR R1, =GPIO_PORTJ_AFSEL_R     ; R1 = GPIO_PORTJ_AFSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFF               ; R0 = R0&~0x01 (disable alt funct on PJ0)
    STR R0, [R1]                    ; [R1] = R0
			
    ; set digital enable register
    LDR R1, =GPIO_PORTJ_DEN_R       ; R1 = GPIO_PORTJ_DEN_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    ORR R0, R0, #0xFF               ; R0 = R0|0x01 (enable digital I/O on PJ0)
    STR R0, [R1]                    ; [R1] = R0

    ; set port control register
    LDR R1, =GPIO_PORTJ_PCTL_R      ; R1 = GPIO_PORTJ_PCTL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFFFFFFFF         ; R0 = R0&0xFFFFFFF0 (clear bit0 field)
    STR R0, [R1]                    ; [R1] = R0
	
    ; set analog mode select register
    LDR R1, =GPIO_PORTJ_AMSEL_R     ; R1 = GPIO_PORTJ_AMSEL_R (pointer)
    LDR R0, [R1]                    ; R0 = [R1] (value)
    BIC R0, R0, #0xFF               ; R0 = R0&~0x01 (disable analog functionality on PJ0)
    STR R0, [R1]                    ; [R1] = R0
	
;------------Activa RS=1----(modo dato)-PORTA0=> RS=1, PORTA1=> RD/WR=0,  PORTA2 =>E=0--
	LDR R0, =GPIO_PORTJ0
	MOV R1, #0x01
	STR R1, [R0]       ;RS=A0=1, RD/WR =A1=0, E=A2=0 (modo dato, escribir, no activado)
	
	PUSH {LR}
	BL LCD_INI
	POP {LR}
	BX  LR

;******************************RETARDO DE 15 ms*************************************
;RUTINA LCD_DELAY: Se trata de un rutina que implementa un retardo 
;o temporizaci¢n de 5 ms. Utiliza dos variables llamadas LCD_TEMP_1 
;y LCD_TEMP_2, que se van decrementando hasta alcanzar dicho tiempo.
;***********************************************************************************
		
LCD_DELAY
	
	;---------------------------------------------------------------------
    LDR R0, =SYSCTL_STCTRL
	LDR R1, [R0]
	AND R1, #0X00000000
	STR R1, [R0]
;---------------------------CUENTA------------------------------------
	LDR R0, =SYSCTL_STRELOAD
	LDR R1, =0x00EA5F					;hay que cambiar
	STR R1, [R0]
;---------------------------------------------------------------------
	LDR R0, =SYSCTL_STCURRENT
	MOV R1, #0
	STR R1, [R0]
;---------------------------------------------------------------------
    LDR R0, =SYSCTL_STCTRL
	LDR R1, [R0]
	ORR R1, #0X00000001
	STR R1, [R0]
;--------------------------------------------------------------------
	LDR R0, =SYSCTL_STCTRL
L1
	LDR R1, [R0]
	MOV R2, #0x00010000		
	AND R1, R2			;verifica si ya se desbordo
	CBNZ R1, salta		;Salta si se desbordo
	B L1				;Salta si no se desbordo
salta	
	BX  LR
;********************PORTA0=> RS=1, PORTA1=> RD/WR,  PORTA2 =>E********
		
LCD_E
	
	NOP
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	ORR R1, R1, #0X04
	STR R1, [R0]			; PORTA2 =>E=1
	NOP
	NOP
	BIC R1, R1, #0X04		; PORTA2 =>E=0
	STR R1, [R0]
	NOP
	
	BX  LR					;REGRESA DE SUBRUTINA
;********************************************************************************
;LCD_BUSY: Lectura del Flag Busy y la direccion.
;
LCD_BUSY

;---------Pone LCD en Modo RD=1----PORTA=> RS=1, PORTA1=> RD=1,  PORTA2 =>E=0-----
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	MOV R2, #0X02		;RS=0 comando,  R/W = 1 lectura,  E=0 desactivado		
	STR R2, [R0]		;PORTA1=> RD/WR=1
;----------------Configura el puerto D como entrada-----------------------------	
	; Direccion de salida
    LDR R1, =GPIO_PORTN_DIR_R       ; R1 = GPIO_PORTN_DIR_R 
    LDR R0, [R1]                    ; R0 = [R1] 
    AND R0, R0, #0x00               ; R0 = R0|0x00 (todos los pines del puerto D entrada)
    STR R0, [R1]                    ; [R1] = R0

;**************PORTA0=> RS=1, PORTA1=> RD=1,  PORTA2 =>E=1********
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	ORR R1, R1, #0X04
	STR R1, [R0]				;PORTA2 =>E=1 ACTIVA LCD
;--------------Lee puerto D-------------------------------------------
	LDR R0, =GPIO_PORTN1
L2
	LDR R1, [R0]
	ANDS R1, R1, #0x80 
	CBZ R1, CONTI
	B L2

;**************PORTA=> RS=1, PORTA1=> RD=1,  PORTA2 =>E=0********
CONTI
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	BIC R1, R1, #0X04
	STR R1, [R0]			;PORTA2 =>E=0 DESACTIVA LCD
	NOP

;---------------Configura Puerto D como Salida-------------------------------------------

; Direccion de salida
    LDR R1, =GPIO_PORTN_DIR_R       ; R1 = GPIO_PORTN_DIR_R 
    LDR R0, [R1]                    ; R0 = [R1] 
    ORR R0, R0, #0xFF               ; R0 = R0|0x00 (todos los pines del puerto D Salida)
    STR R0, [R1]                    ; [R1] = R0
;--------------------------PORTA=> RS=1, PORTA1=> WR=0,  PORTA2 =>E=0--------------------------------------------------
;                ;Pone LCD en modo WR=0    bcf PORTA,1 
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	BIC R1, R1, #0X02
	STR R1, [R0]			 ;PORTA1=> WR=0 DESACTIVA LECTURA
	BX  LR

;----------------------------PORTA0=> RS=1, PORTA1=> RD=1,  PORTA2 =>E=0**------------------
;LCD_DATO: Escritura de datos en DDRAM o CGRAM
;El dato tiene que estar en R6
	
LCD_DATO        
;---------------bcf PORTA,0    ;Desactiva RS=0 (modo comando) ;Desactiva RS=0  bcf PORTA,0 (modo comando)  
	PUSH {LR}
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	BIC R1, R1, #0X01
	STR R1, [R0]				;RS=0 MODO COMANDO
;---------------------El dato esta en R6-----------------------------------------------
	
	PUSH {LR}
	BL LCD_BUSY            
	POP {LR}
	LDR R1, =GPIO_PORTN1        	
	STR R6, [R1]
    LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	ORR R1, R1, #0X01  			;Activa RS=1   (bsf PORTA,0) (modo dato) 
	STR R1, [R0]
	POP {LR}
	B LCD_E
;--------------------------------------------------------------------------
;LCD_REG: Escritura de comandos del LCD
;W ==> portd
;
LCD_REG         

;---------------bcf PORTA,0    ;Desactiva RS=0 (modo comando) ;Desactiva RS=0  bcf PORTA,0 (modo comando)  
 
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	BIC R1, R1, #0X01
	STR R1, [R0]				;RS=0 (modo comando)
    
	PUSH {LR}
	BL LCD_BUSY
	POP {LR}
	LDR R1, =GPIO_PORTN1        
	STR R6, [R1]
	B  LCD_E	
	
;------------------------FUNCION QUE INICIALIZA EL LCD-------------------------------------------

LCD_INI         
	PUSH {LR}
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	BIC R1, R1, #0X01
	STR R1, [R0]				;RS=0 (modo comando)
 
	LDR R1, =GPIO_PORTN1
	MOV R0, #0x38
	STR R0, [R1]
    BL LCD_E
    BL LCD_DELAY 
		
		
		
	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	BIC R1, R1, #0X01
	STR R1, [R0]				;RS=0 (modo comando)
	
	LDR R1, =GPIO_PORTN1
	MOV R0, #0X38
	STR R0, [R1]
    BL LCD_E
    BL LCD_DELAY 


	LDR R0, =GPIO_PORTJ0
	LDR R1, [R0]
	BIC R1, R1, #0X01
	STR R1, [R0]				;RS=0 (modo comando)

    LDR R1, =GPIO_PORTN1
	MOV R0, #0X38
	STR R0, [R1]
    BL LCD_E
    BL LCD_DELAY
	POP {LR}
    BX LR

;-------------------------------------------------------------------------
;FUNCION SET :Imterfase de 8 bits DL=1, numero de lineas dos N=1, matriz 5x8
;			    0 0 1 DL N F - - 

FUNCION_SET
		PUSH {LR}
		MOV R6, #0X38
		BL LCD_REG
		POP {LR}
		BX LR
;-------------------------------------------------------------------------
;BORRA_Y_HOME: Borra el display y retorna el cursor a la posici¢n 0 
;
	
BORRA_Y_HOME 
		PUSH {LR}
		MOV R6, #0X01
		BL LCD_REG
		POP {LR}
		BX LR
;-------------------------------------------------------------------------
;DISPLAY_ON_CUR_OFF: Control ON/OFF del display y cursor.
;Activa Display desactiva cursor.
	
DISPLAY_ON_CUR_OFF
		PUSH {LR}
		MOV R6, #0X0E
		BL LCD_REG
		POP {LR}
		BX LR
;--------------------------------------------------------------------------

RETURN_HOMER
		PUSH {LR}
		MOV R6, #0X02
		BL LCD_REG
		POP {LR}
		BX LR
;------------------------------------------------------------------------	
    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
