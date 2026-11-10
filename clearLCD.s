	AREA FLASH, CODE, READONLY
	INCLUDE	LPC11xx.inc
	IMPORT LCD_send
	EXPORT clearLCD


CLEAR       EQU		0X01



clearLCD
	PUSH {R0,R4,LR}
	MOVS R0, #CLEAR
	MOVS R4, #0
	BL LCD_send
	POP {R0,R4,PC}
	
end
	B end