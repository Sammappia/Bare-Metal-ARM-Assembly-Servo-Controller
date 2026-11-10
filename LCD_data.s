	AREA FLASH, CODE, READONLY
	INCLUDE	LPC11xx.inc
	IMPORT AAPCS_delay
	EXPORT LCD_data


DELAY		EQU		500
RS_DATA		EQU		1	;RS = 1 for Data mode
RS_CMD		EQU		0	;RS = 0 for command mode


LCD_data
	PUSH {LR}
	
Load_UpperDB
	
	;===Clear DB PINs====
	LDR R4, =(GPIO0DATA)
	LDR R5, [R4]
	LDR R6, =0xFFFFFFE1
	ANDS R5, R6
	
	;	Extract upper nibble
	LSRS R6, R7, #4
	;	Send upper nibble
	LSLS R6, #1
	ORRS R5, R6
	;LDR R4, =(GPIO0DATA)	;	Commented because R4 has not been changed. Left it here to remind everyone this step is necessary.
	STR R5, [R4]
	
	;;===Delay
	LDR R0, =DELAY
	BL AAPCS_delay
	
	;==Set E;;;
	LDR R4, =(GPIO1DATA)
	LDR R5, [R4]
	LDR R6, =0x100
	ORRS R5,R6
	STR	R5, [R4]
	
	;===Delay
	LDR R0, =DELAY
	BL AAPCS_delay
	
	
	;==Clear E
	LDR R4, =(GPIO1DATA)
	LDR R5, [R4]
	LDR R6, =(~0x100)
	ANDS R5, R6
	STR	R5, [R4]
	
	;===Delay
	LDR R0, =DELAY
	BL AAPCS_delay
	
Load_LowerDB

	;===Clear DB PINs====
	LDR R4, =(GPIO0DATA)
	LDR R5, [R4]
	LDR R6, =0xFFFFFFE1
	ANDS R5, R6
	
	;	Extract lower nibble
	MOVS R6, #0x0F
	ANDS R6, R7
	
	;	Send lower nibble
	LSLS R6, #1
	ORRS R5, R6
	;LDR R4, =(GPIO0DATA)	;	Commented because R4 has not been changed. Left it here to remind everyone this step is necessary.
	STR R5, [R4]
	
	;;===Delay
	LDR R0, =DELAY
	BL AAPCS_delay
	
	;==Set E;;;
	LDR R4, =(GPIO1DATA)
	LDR R5, [R4]
	LDR R6, =0x100
	ORRS R5,R6
	STR	R5, [R4]
	
	;===Delay
	LDR R0, =DELAY
	BL AAPCS_delay
	
	;==Clear E
	LDR R4, =(GPIO1DATA)
	LDR R5, [R4]
	LDR R6, =(~0x100)
	ANDS R5, R6
	STR	R5, [R4]
	
	;===Delay
	LDR R0, =DELAY
	BL AAPCS_delay
	
	;	Delay for command to take effect
	LDR R0, =10000
	BL AAPCS_delay
	
	POP {PC}
	