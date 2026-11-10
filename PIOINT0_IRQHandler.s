	AREA PROGRAM, CODE, READONLY
	INCLUDE	LPC11xx.inc
	EXPORT PIOINT0_IRQHandler
	IMPORT KeypadInit
	IMPORT delay_ms
	IMPORT keypressed
	IMPORT LCD_reinit
	IMPORT Keypad_reinit
	IMPORT LCD_send
	IMPORT currState
	IMPORT clearflag
	IMPORT printText
	IMPORT clearLCD
	IMPORT startstring
	
	
	
	
PIOINT0_IRQHandler
	PUSH {R0-R6,LR}
	
	LDR R4, =(0xE000E180)		; disable the interrupt, ICER, page 507, 508
	MOVS R5, 0x1				; Interrupt Clear-enable Register, page 508  (ICER)
	MOVS R5, R5, LSL #31		; Interrupt source: Page 70. 
	STR R5, [R4]
	
	LDR R4, =(0xE000E280)		;clear the pending interrupt, Interrupt Clear-pending Register (ICPR)
	MOVS R5, 0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	LDR	R0, =15
	BL delay_ms	
	
check_row1
		
		LDR	R4,=(GPIO1DATA) ; just let first row = 0
		MOVS R5, #0x07
		STR R5, [R4]
		
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E		;0000_0001_1110
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ; find input coulmn and shift down one bit
		
		;kp = key pressed
		CMP R5, #0x07  	; 0111 --> 1
		BEQ kp1
		
		CMP R5, #0x0B	; 1011 --> 2
		BEQ kp2
		
		CMP R5, #0x0D  	; 1101 --> 3
		BEQ kp3
		
		CMP R5, #0x0E	; 1110 --> A
		BEQ kp4
		
check_row2
		
		LDR	R4,=(GPIO1DATA) ; 2nd row = 0
		MOVS R5, #0x13	;0001_0011  
		STR R5, [R4]
		
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E		;0000_0001_1110
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ; find input coulmn and shift down one bit
		
		CMP R5, #0x07  	; 0111 --> 4
		BEQ kp5
		
		CMP R5, #0x0B	; 1011 --> 5
		BEQ kp6
		
		CMP R5, #0x0D  	; 1101 --> 6
		BEQ kp7
		
		CMP R5, #0x0E	; 1110 --> B
		BEQ kp8
		
check_row3
		
		LDR	R4,=(GPIO1DATA) ; 3nd row = 0
		MOVS R5, #0x15	;0001_0101 
		STR R5, [R4]
		
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E		;0000_0001_1110
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ; find input coulmn and shift down one bit
		
		CMP R5, #0x07  	; 0111 --> 7
		BEQ kp9
		
		CMP R5, #0x0B	; 1011 --> 8
		BEQ kp10
		
		CMP R5, #0x0D  	; 1101 --> 9
		BEQ kp11
		
		CMP R5, #0x0E	; 1110 --> C
		BEQ kp12
		
check_row4
		
		LDR	R4,=(GPIO1DATA) ; 2nd row = 0
		MOVS R5, #0x16	;0001_0110  
		STR R5, [R4]
		
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E		;0000_0001_1110
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ; find input coulmn and shift down one bit
		
		CMP R5, #0x07  	; 0111 --> *
		BEQ kp13
		
		CMP R5, #0x0B	; 1011 --> 0
		BEQ kp14
		
		CMP R5, #0x0D  	; 1101 --> #
		BEQ kp15
		
		CMP R5, #0x0E	; 1110 --> D
		BEQ kp16
		B	exit		;Detection failed, exit
		

;Converting key pressed to ASCII
kp1
		;1
		MOVS	R2, #0x31
		B		exit
		
kp2
		;2
		MOVS	R2, #0x32
		B		exit
		
kp3
		;3
		MOVS	R2, #0x33
		B		exit

kp4
		;A
		MOVS	R2, #0x41
		B		exit

kp5
		;4
		MOVS	R2, #0x34
		B		exit

kp6
		;5
		MOVS	R2, #0x35
		B		exit

kp7
		;6
		MOVS	R2, #0x36
		B		exit

kp8
		;B
		MOVS	R2, #0x42
		B		exit

kp9
		;7
		MOVS	R2, #0x37
		B		exit

kp10
		;8
		MOVS	R2, #0x38
		B		exit

kp11
		;9
		MOVS	R2, #0x39
		B		exit

kp12
		;C
		MOVS	R2, #0x43
		B		exit

kp13
		;*
		MOVS	R2, #0x2A
		B		exit

kp14
		;0
		MOVS	R2, #0x30
		B		exit

kp15
		;#
		MOVS	R2, #0x23
		B		exit

kp16
		;D
		MOVS	R2, #0x44
		B		exit


;; continue the code for other columns, _colx

; ....
		
;; continue to write brach entry for check row 2.

; repeat similar treatment for ientify which key for row 3.
; then row 3, then row 4...
exit
	
	
	LDR R4, =(0xE000E280)		;clear the pending interrupt, Interrupt Clear-pending Register (ICPR)
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	
	;;store the detected value of the key in register R2, then pass it to R0 to LCD-data to display.
	
	LDR R0, =keypressed
	STR R2, [R0]
	
	
	
releaseCheck
	
		LDR R4, =(GPIO0DATA)
		LDR R5, [R4]
		MOVS R6, #0x01E		;0000_0001_1110
		ANDS R5, R5, R6
		MOVS R5, R5, LSR #1  ;
		
		CMP R5, #0xF  	; 1111, all columns high
		BNE releaseCheck

	
	;check state
	LDR R4, =currState
	LDR R3, [R4]
	CMP R3, #0
	BNE afterPrint

	CMP R2, #0x39
	BGT afterPrint
		
	CMP R2, #0x30
	BLT afterPrint
		
	
	;; prepare LCD display
	BL LCD_reinit
	
	;check if display needs to be cleared
	LDR R4, =clearflag
	LDR R3, [R4]
	CMP R3, #0
	BEQ print
	
	BL clearLCD
    LDR R1, =startstring
    BL printText

    ; Clear the flag
    MOVS R3, #0
    STR R3, [R4]
	
print
	MOVS R0, R2	;Moving ASCII value into R0 for LCD print
	MOVS R4, #1	;Setting up LCD_send for data
	BL LCD_send
	
	
	
		
	;; print the detected character in the LCD screen, call LCD_data using R0
	
	; Done with LCD, prepare for keypad detection
	; set the direction of P0.1, P0.2, P0.3, P0.4 as input for keypad column	
	;set the direction of P1.0, P1.1, P1.2, P1.4 as output for keypad row
	BL Keypad_reinit
	
afterPrint
	;Delay for debouncing
	LDR	R0, =0x15
	BL delay_ms
	
	
	LDR R4, =(0xE000E280)		;clear the pending interrupt, Interrupt Clear-pending Register (ICPR)
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	LDR R4, =(0xE000E100)		;enable the interrupt for Port0
	MOVS R5, #0x1
	MOVS R5, R5, LSL #31
	STR R5, [R4]
	
	;Ground all rows
	LDR	R4,=(GPIO1DATA)
	MOVS R5, #0x00
	STR R5, [R4]
	
	
	POP{R0-R6,PC}

	END