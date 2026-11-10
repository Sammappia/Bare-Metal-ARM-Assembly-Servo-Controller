	AREA PROGRAM, CODE, READONLY
	INCLUDE	LPC11xx.inc
	IMPORT uptime_ms
	EXPORT TMR16B1_Init
	 
TMR16B1_Init\
	PROC
	PUSH{R0-R7,LR}
	
	LDR R0, =uptime_ms	;	Clear counts
	LDR R1, =0
	STR R1, [R0]
	
	;	Load Match Register0
    LDR R0, =(TMR16B1MR0)
    LDR R1, =(10)
    STR R1, [R0];
	
	;	Load pre-scalar Register
    LDR R0, =(TMR16B1PR)
    LDR R1, =(1199)
    STR R1, [R0];
	
	;	set the Match Control Register(MCR) to reset the counter and raise interrupt when the timer counter matches Match register 0
    LDR R0, =(TMR16B1MCR)
    MOVS R1, #(0x03); MCR has these 3-bit fields for each MR match 0b000_000_011
    STR R1, [R0];
	
	 ; Start the counter by setting bit 0 of Timer Control Register(TCR)
    LDR R0, =(TMR16B1TCR)
    MOVS R1, #(0x2);
    STR R1, [R0];
    MOVS R1, #(0x1);
    STR R1, [R0];
	
	POP {R0-R7,PC}
	ENDP
	END