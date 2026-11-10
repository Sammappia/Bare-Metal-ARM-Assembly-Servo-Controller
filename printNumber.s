	AREA PROGRAM, CODE, READONLY
    INCLUDE LPC11xx.inc
    EXPORT printNumber
    IMPORT LCD_send
    IMPORT LCD_reinit
    IMPORT Keypad_reinit
    IMPORT divide
		
;uses divide function from uptime lab to loop a number into its digits
printNumber
	
	PUSH {R4,R5,LR}
	MOVS R5, #0	;Setting up R5 to count digits
	MOVS R4, #1 ;Data mode for LCD_send
	
	BL LCD_reinit	;Decided it's easier to enable and disable print in the print function instead of main
	
	;Zero check 
	CMP R0, #0
    BNE splitterloop
    MOVS R0, #0x30		;ASCII 0
    BL LCD_send
    B done
	

splitterloop ;loop that splits R0 into its digits. Pushes them onto stack for print loop
	
	BL divide
	;Convert remainder to ASCII
    ADDS R1, R1, #0x30
    PUSH {R1}
    ADDS R5, R5, #1     ;Increment digit count
	CMP R0, #0			;Check if quotient is 0
	BNE splitterloop
	
	
printloop ;loop that prints digits to LCD from stack
	POP {R1}
	MOVS R0, R1
	BL LCD_send
	SUBS R5, R5, #1
	CMP R5, #0
	BNE printloop
	
done

	BL Keypad_reinit  ;Restore keypad function
	POP {R4,R5,PC}