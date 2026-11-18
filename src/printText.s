 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 EXPORT printText
 IMPORT nextLine
 IMPORT LCD_send


;Loop to print text (adapted from lab 4)
;Text loaded in R1 before printText is called
printText
	PUSH {R4,LR}
	MOVS R4, R1		;Preserve R1
	MOVS R1, #1		;Prepare LCD_send for data
printLoop
	LDRB r0, [r4]	;Load character into r0
	CMP r0, #0		;null check
	BEQ stringDone
	BL LCD_send
	ADDS r4, #1
	B printLoop
	
stringDone
	BL nextLine
	POP {R4,PC}	
