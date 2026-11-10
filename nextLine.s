	AREA FLASH, CODE, READONLY
	INCLUDE	LPC11xx.inc
	IMPORT LCD_command
	EXPORT nextLine


NEXT_LINE   EQU		0xC0



nextLine
	PUSH {LR}
	LDR R4, =(GPIO0DATA)
	LDR R5, [R4]
	LDR R6, =0xFFFFFF7F
	ANDS R5, R6
	STR  R5, [R4]
	MOVS R0, #NEXT_LINE
    BL LCD_command
	LDR R5, [R4]
	LDR R6, =0xFFFFFFE1
	ANDS R5, R6
	MOVS R6, #0x80
	ORRS R5, R6
	STR  R5, [R4]
	POP {PC}
	
end
	B end