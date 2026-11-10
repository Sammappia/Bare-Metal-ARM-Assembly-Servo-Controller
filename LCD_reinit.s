	AREA FLASH, CODE, READONLY
	INCLUDE	LPC11xx.inc
	EXPORT LCD_reinit
	IMPORT delay_ms

		

LCD_reinit

	PUSH{R0-R5}
	
	LDR R4, =(0xE000E180)		; disable the interrupt, ICER, page 507, 508
	MOVS R5, #0x1				; Interrupt Clear-enable Register, page 508  (ICER)
	MOVS R5, R5, LSL #31		; Interrupt source: Page 70. 
	STR R5, [R4]
	
	LDR R4, =(0xE000E280)		;clear the pending interrupt, Interrupt Clear-pending Register (ICPR)
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	
	;reset pin 1
    LDR R0, =(IOCON_PIO0_1)
    LDR R2, =(0x8)			;pull down resistor
    STR R2, [R0]
	 
	;reset pin 2
    LDR R0, =(IOCON_PIO0_2)
    STR R2, [R0]
	
	;reset pin 3
    LDR R0, =(IOCON_PIO0_3)
    STR R2, [R0]
	
	;reset pin 4
    LDR R0, =(IOCON_PIO0_4)
    STR R2, [R0]
	
	;Set up pin 7
    LDR R0, =(IOCON_PIO0_7)
	STR R2, [R0]
	
	;Set up pin 8 (port1)
    LDR R0, =(IOCON_PIO1_8) 
	STR R2, [R0]
	
	; Set GPIO0 data direction register to set pins as output
    LDR R0, =(GPIO0DIR);
    LDR R1, [R0];
	MOVS R2, #(0x9E) ;1001_1110, setting pins 1 through 4 and 7 to output
    ORRS R1, R2;
    STR R1, [R0];
	
	LDR R0, =(GPIO1DIR);
    LDR R1, [R0];
	MOVS R2, #(0x1) ;setting pin 8 to output
	MOVS R2, R2, LSL #8
    ORRS R1, R2;
    STR R1, [R0];


	POP {R0-R5}
	BX LR
	
	END