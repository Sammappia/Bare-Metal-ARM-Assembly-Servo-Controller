 AREA PROGRAM, CODE, READONLY
 INCLUDE LPC11xx.inc
 EXPORT LCD_send
 IMPORT AAPCS_delay
	 
DELAY		EQU		500

LCD_send	;	Parameters:  R0 = data or command    R4 = RS (0 for command, 1 for data)

	PUSH{R0,R4-R7,LR}
	MOVS r7, r0		;Preserve the parameter because this subroutine calls other subroutines.
	CMP r4, #0
	BEQ isCommand
	
isData
	LDR R4, =(GPIO0DATA)
	LDR R5, [R4]
	LDR R6, =0xFFFFFFE1	;1111_1111_1110_0001
	ANDS R5, R6
	MOVS R6, #0x80	;0000_0000_1000_0000
	ORRS R5, R6
	STR  R5, [R4]
	B disE
	
isCommand
	; and set all data pins and RS to 0
	LDR R4, =(GPIO0DATA)
	LDR R5, [R4]
	LDR R6, =0xFFFFFF61	;1111_0110_0001
	ANDS R5, R6
	STR  R5, [R4]
	B disE
	
disE
	;Disable E
	LDR R4, =(GPIO1DATA)
	LDR R5, [R4]
	LDR R6, =0xFFFFFEFF
	ANDS R5, R6
	STR R5, [R4]
	
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
	
	POP {R0,R4-R7,PC}
	END