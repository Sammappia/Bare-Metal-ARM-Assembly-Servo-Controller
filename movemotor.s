	AREA PROGRAM, CODE, READONLY
    INCLUDE LPC11xx.inc
    EXPORT movemotor

		
;routine to move servo according to angle stored in R0
movemotor
	
	PUSH {R0-R3,LR}
	CMP R0, #180
	BLT angle
	MOVS R0, #180 ;Caps angle to 180
	
angle	;converting angle to MR0 value by multiplying by 91 and dividing by 9
	
    MOVS R1, #91
    MULS R0, R1, R0

    ;Divide (Angle * 91) by 9 using repeated subtraction
    MOVS R1, #0
    MOVS R2, #9
	
div9

    CMP R0, R2
    BLT done
    SUBS R0, R0, R2
    ADDS R1, R1, #1
    B div9
	
done

    ;MR0 = 19570 - ticks
    LDR R2, =19570
    SUBS R2, R2, R1

    ; 5. Write directly to TMR32B0MR0 (0x40014018)
    LDR R3, =(TMR32B0MR0)
    STR R2, [R3]


	POP {R0-R3,PC}