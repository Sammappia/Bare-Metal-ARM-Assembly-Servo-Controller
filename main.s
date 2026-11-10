	AREA FLASH, CODE, READONLY
	EXPORT __main
	INCLUDE LPC11xx.inc
	IMPORT TMR16B1_Init
	IMPORT PWM_init
	IMPORT KeypadInit
	IMPORT Keypad_reinit
	IMPORT keypressed
	IMPORT LCD_init
	IMPORT LCD_reinit
	IMPORT clearLCD
	IMPORT printText
	IMPORT printNumber
	IMPORT movemotor
	IMPORT mem1
	IMPORT mem2
	IMPORT mem3
	IMPORT mem4
	IMPORT currState
	IMPORT clearflag
	EXPORT startstring
;	EXPORT storestring
;	EXPORT recallstring
	;IMPORT Level3
   
    ENTRY

; __main routine starts here
__main PROC
	
	
	BL TMR16B1_Init
	BL LCD_init
	BL KeypadInit
	BL PWM_init

	
	;Initialize R0 and keypressed memory with 0
	MOVS R0, #0
	LDR R1, =keypressed
	STR R0, [R1]
	
	;Clearing all memory and state
	LDR R1, =mem1
	STR R0, [R1]
	LDR R1, =mem2
	STR R0, [R1]
	LDR R1, =mem3
	STR R0, [R1]
	LDR R1, =mem4
	STR R0, [R1]
	LDR R1, =currState
	STR R0, [R1]

	B waitforkey
	
enter0
	
	BL LCD_reinit
	BL clearLCD
	LDR R1, =startstring
	BL printText
	BL Keypad_reinit
	
	
waitforkey	;keypolling loop
	
	LDR R1, =keypressed
	LDR R2, [R1]			;Get last key pressed
	CMP R2, #0
	BEQ waitforkey
	
	;state check
	LDR R4, =currState
	LDR R3, [R4]
	CMP R3, #0
	BEQ st0
	CMP R3, #1
	BEQ waitformemory
	CMP R3, #2
	BEQ waitforrecall
		

st0

	CMP R2, #0x39
	BGT letterscanned
		
	CMP R2, #0x30
	BLT ignorekey
	


updateValue

	SUBS R2, #0x30
	MOVS R1, #10
	MULS R0, R1, R0
	ADDS R0, R0, R2
	
	;clear keypressed
	LDR R1, =keypressed
	MOVS R2, #0
	STR R2, [R1]
	
	B waitforkey
	
ignorekey
	
	;Check for #
	CMP R2, #0x23
	BNE safetoignore
	BL movemotor
	MOVS R0, #0	;Empty R0
	LDR R4, =clearflag	;set clear flag
	MOVS R3, #1
	STR R3, [R4]
	
safetoignore
	;Clear keypressed
	MOVS R2, #0
	STR R2, [R1]
	
	B waitforkey
	
letterscanned
	
	;Clear keypressed
	MOVS R3, #0				;Uses r3 because r2 is still in use
	STR R3, [R1]
	
	;Check for A
	CMP R2, #0x41
	BEQ st1
	
	;Check for B
	CMP R2, #0x42
	BEQ st2
	

	B waitforkey

;state1 set up
st1

	;Change from state0 to state1
	LDR R4, =currState
	MOVS R3, #1
	STR R3, [R4]
	
	;Print "store" prompt
	BL LCD_reinit
	BL clearLCD
	LDR R1, =storestring
	BL printText
	BL Keypad_reinit
	B waitforkey
	
;state2 set up
st2

	;Change from state0 to state2
	LDR R4, =currState
	MOVS R3, #2
	STR R3, [R4]
	
	;Print "store" prompt
	BL LCD_reinit
	BL clearLCD
	LDR R1, =recallstring
	BL printText
	BL Keypad_reinit
	B waitforkey

waitformemory

	LDR R1, =keypressed		;get keypressed
	LDR R2, [R1]		
	CMP R2, #0x31
	BEQ str1
	CMP R2, #0x32
	BEQ str2
	CMP R2, #0x33
	BEQ str3
	CMP R2, #0x34
	BEQ str4
	
	B waitforkey
	
	
waitforrecall

	LDR R1, =keypressed		;get keypressed
	LDR R2, [R1]		
	CMP R2, #0x31
	BEQ rc1
	CMP R2, #0x32
	BEQ rc2
	CMP R2, #0x33
	BEQ rc3
	CMP R2, #0x34
	BEQ rc4
	
	B waitforkey
	
rc1

	;Load mem1 into R0
	LDR R1, =mem1
	LDR R0, [R1]
	B recall
	
rc2

	;Load mem2 into R0
	LDR R1, =mem2
	LDR R0, [R1]
	B recall
	
rc3

	;Load mem3 into R0
	LDR R1, =mem3
	LDR R0, [R1]
	B recall
	
rc4

	;Load mem4 into R0
	LDR R1, =mem4
	LDR R0, [R1]
	;B recall
	
recall
	MOVS R5,R0	;preserve R0
	
	BL LCD_reinit
	BL clearLCD
	LDR R1, =postrecallstring
	BL printText
	

	BL printNumber
	BL Keypad_reinit
	
	;Clear keypressed
	LDR R1, =keypressed
	MOVS R3, #0
	STR R3, [R1]
	;Change from state2 to state0
	LDR R4, =currState
	STR R3, [R4]
	
	LDR R1, =clearflag
    MOVS R2, #1
    STR R2, [R1]
	
	MOVS R0, R5	;restore R0
	BL movemotor
	
	MOVS R0, #0
	B waitforkey

str1

	;Store current value in mem1
	LDR R1, =mem1
	STR R0, [R1]
	;Reset R0
	MOVS R0, #0
	;Clear keypressed
	LDR R1, =keypressed
	MOVS R3, #0
	STR R3, [R1]
	;Change from state1 to state0
	LDR R4, =currState
	STR R0, [R4]
	B enter0

str2

	;Store current value in mem1
	LDR R1, =mem2
	STR R0, [R1]
	;Reset R0
	MOVS R0, #0
	;Clear keypressed
	LDR R1, =keypressed
	MOVS R3, #0
	STR R3, [R1]
	;Change from state1 to state0
	LDR R4, =currState
	STR R0, [R4]
	B enter0

str3

	;Store current value in mem1
	LDR R1, =mem3
	STR R0, [R1]
	;Reset R0
	MOVS R0, #0
	;Clear keypressed
	LDR R1, =keypressed
	MOVS R3, #0
	STR R3, [R1]
	;Change from state1 to state0
	LDR R4, =currState
	STR R0, [R4]
	B enter0
	
	
str4

	;Store current value in mem1
	LDR R1, =mem4
	STR R0, [R1]
	;Reset R0
	MOVS R0, #0
	;Clear keypressed
	LDR R1, =keypressed
	MOVS R3, #0
	STR R3, [R1]
	;Change from state1 to state0
	LDR R4, =currState
	STR R0, [R4]
	B enter0

end
	
	B end
	ENDP
		
startstring 	 DCB "Enter Angle:", 0
storestring	 	 DCB "Store (1-4):", 0
recallstring	 DCB "Recall (1-4):", 0
postrecallstring DCB "Angle Recalled:", 0
			
		
	END; End of File
