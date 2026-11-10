	AREA FLASH, CODE, READONLY
	INCLUDE	LPC11xx.inc
	EXPORT LCD_init
	IMPORT delay_ms
	IMPORT LCD_send
	IMPORT printText
	IMPORT startstring
		
; Useful LCD commands
CLEAR       EQU		0X01
HOME        EQU		0X02
LCD_ON      EQU		0X0C
BLINK       EQU		0X0F
CURSOR_ON   EQU		0X0E
LEFT        EQU		0X10
RIGHT       EQU		0X14
NEXT_LINE   EQU		0xC0
FOURBIT     EQU		0x28    ;0b00101000 = 0x28
LCD_OFF     EQU		0x0A		
		

LCD_init

	PUSH {R4-R7,LR}
	
	;Set up pin 1
    LDR R0, =(IOCON_PIO0_1)
    LDR R1, [R0];
    LDR R2, =(0x8);
    ORRS R1, R2;
    STR R1, [R0];
	 
	 
	;Set up pin 2
    LDR R0, =(IOCON_PIO0_2);
    LDR R1, [R0];
    LDR R2, =(0x8);
    ORRS R1, R2;
    STR R1, [R0];
	
	
	;Set up pin 3
    LDR R0, =(IOCON_PIO0_3); 
    LDR R1, [R0];
    LDR R2, =(0x8);
    ORRS R1, R2;
    STR R1, [R0];
	
	;Set up pin 4
    LDR R0, =(IOCON_PIO0_4); 
    LDR R1, [R0];
    LDR R2, =(0x8);
    ORRS R1, R2;
    STR R1, [R0];
	
	;Set up pin 7
    LDR R0, =(IOCON_PIO0_7); 
    LDR R1, [R0];
    LDR R2, =(0x8);
    ORRS R1, R2;
    STR R1, [R0];
	
	;Set up pin 8 (port1)
    LDR R0, =(IOCON_PIO1_8); 
    LDR R1, [R0];
    LDR R2, =(0x8);
    ORRS R1, R2;
    STR R1, [R0];
	
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
	
	LDR R0, =1000
	BL delay_ms
	
	MOVS R4, #0	;setting up LCD_send for commands
	
	MOVS	R0, #0x33			;Boot up
	BL		LCD_send
	
	MOVS	R0, #0x32			;Boot up
	BL		LCD_send
	
    MOVS	R0, #FOURBIT		;28H initialization to 2-lines
    BL 		LCD_send			;using 4-bit interface(DL = 0)

	MOVS	R0, #BLINK			;turn LCD display on, cursor on	and blink
    BL 		LCD_send
	
	MOVS	R0, #CLEAR		 	;clear LCD
    BL 		LCD_send
	
	MOVS 	R0, #HOME			;or using 02H - return home command
    BL 		LCD_send
	
	;Used for testing
;	MOVS R0, "E"
;	MOVS R4, #1
;	BL LCD_send
;	MOVS R0, "N"
;	BL LCD_send
;	MOVS R0, "T"
;	BL LCD_send
;	MOVS R0, "E"
;	BL LCD_send
;	MOVS R0, "R"
;	BL LCD_send

	LDR R1, =startstring
	BL printText


	POP {R4-R7,PC}
	
	END