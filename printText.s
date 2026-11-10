 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 EXPORT printText
 IMPORT LCD_send


;Loop to print text (adapted from lab 4)
;Text loaded in R1 before printText is called
printText
	PUSH {R0,R4,LR}
	MOVS R4, #1		;Prepare LCD_send for data
printLoop
	LDRB r0, [r1]	;Load character into r0
	CMP r0, #0		;null check
	BEQ stringDone
	BL LCD_send
	ADDS r1, #1
	B printLoop
	
stringDone
	MOVS R0, #0xC0	;Next line
	MOVS R4, #0		;LCD_send command
	BL LCD_send
	POP {R0,R4,PC}	
