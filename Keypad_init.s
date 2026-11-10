; GPIO0 1,2,3,4 are set as input with pullup for rows, interrupt on LOW LEVEL
; GPIO1 0,1,2,4 are set as output and held at LOW
	AREA PROGRAM, CODE, READONLY
	INCLUDE	LPC11xx.inc
	EXPORT KeypadInit
	 
	 
KeypadInit PROC
	PUSH{R0-R7,LR}
	
	LDR  R4, =(GPIO0DIR)	;P0_1 TO P0_4 TO INPUT
	LDR R5,[R4]
	LDR R6,=0XFFFFFFE1
	ANDS R5,R6
	STR  R5, [R4]
	
	;0x10 sets bit 4 (Pull-up enabled)
	LDR  R4, =IOCON_PIO0_1
    MOVS R5, #0x10          
    STR  R5, [R4]
    
    LDR  R4, =IOCON_PIO0_2
    MOVS R5, #0x10
    STR  R5, [R4]
    
    LDR  R4, =IOCON_PIO0_3
    MOVS R5, #0x10
    STR  R5, [R4]
    
    LDR  R4, =IOCON_PIO0_4
    MOVS R5, #0x10
    STR  R5, [R4]
	
	LDR  R4, =(IOCON_R_PIO1_0)
	LDR	 R5, =(0x081)
	STR  R5, [R4]
	
	LDR  R4, =(IOCON_R_PIO1_1)
	LDR	 R5, =(0x081)
	STR  R5, [R4]
	
	LDR  R4, =(IOCON_R_PIO1_2)
	LDR	 R5, =(0x081)
	STR  R5, [R4]
	
	
	LDR  R4, =(IOCON_PIO1_4)
	MOVS R5, #0x80
	STR  R5, [R4]
		
	LDR R4, =(GPIO1DIR)		;set the direction of P1.0, 1.1, 1.2 and 1.4 as output
	LDR R3,[R4]
	LDR R5, =0x17
	ORRS R5,R3
	STR  R5, [R4]
	
	LDR  R4, =(0X5001005C)		;P1.0, 1.1, 1.2 and 1.4 to 0 USING BIT BANDING ADDRESS
	LDR R5, =(0x00)
	STR  R5, [R4]
	
	LDR  R4, =(LPC_GPIO0IS)		;Interrupt sense register is configured as level sensitive
	MOVS R5,  #0x1E
	STR  R5, [R4]
	
	LDR  R4, =(LPC_GPIO0IE)		;Interrupt on P0.1, 0.2, 0.3 and 0.4 is unmasked
	MOVS R5,  #0x1E
	STR  R5, [R4]
	
	LDR  R4, =(LPC_GPIO0IEV)	;Interrupts on falling edge or low level of pin. Rising edge would be 0X1E
	LDR R5,  =(0xE1)
	STR  R5, [R4]
	
	LDR R4, =(0xE000E100)		;enable the interrupt for Port0
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	POP {R0-R7,PC}
	ENDP
	END