	AREA PROGRAM, CODE, READONLY
	INCLUDE	LPC11xx.inc
	EXPORT PWM_init
	
PWM_init
	PUSH{R0-R7,LR}
	
	; Load the address of IOCON_PIO1_6 into R0
    LDR R0, =(IOCON_PIO1_6)
    ; Load the value of IOCON_PIO1_6 into R1
    LDR R2, =(0x2);
    ; Store the new value of R1 into IOCON_PIO1_6
    STR R2, [R0];
	
	;Set prescale value to 11 (so Timer counts up every 12 ticks, equivalent to 1us)
	LDR R0, =(TMR32B0PR)
	MOVS R1, #11
	STR R1, [R0]
	
	
	;Setting up PWM for PIO1_6 (32B0MAT0)
	LDR R0, =(TMR32B0PWMC);PWM Control
	LDR R1, [R0]
	LDR R2, =(0x1);0001 set channel 0 PWM
	ORRS R2, R1
	STR R2, [R0]
	
	
	;Setting up match register 3 and 1 for counter0
	;3 for the PWM period, and 1 for the "other" register
	
	; PWM period
	; Load Match Register3(TMR32B0MR3) of 32-bit counter0(TMR32B0 or CT32B0)
    LDR R0, =(TMR32B0MR3);TMR32B0MR3
    LDR R1, =(20000);20ms
    ; Store the value of R1 into TMR32B0MR3
    STR R1, [R0];
	
	; Pulse
	; Load Match Register1(TMR32B0MR1) of 32-bit counter0(TMR32B0 or CT32B0)
    LDR R0, =(TMR32B0MR0); TMR32B0MR0
    LDR R1, =(19570);
    ; Store the value of R1 into TMR32B0MR0
    STR R1, [R0];
	
	
	; set the Match Control Register(MCR) to reset the counter when the timer counter matches Match register 3
    LDR R0, =(TMR32B0MCR)
    LDR R1, =(0x400); 010_000_000_000 ---> reset MR3
    ; Store R1 into TMR32B0MCR
    STR R1, [R0];
	
	; Start the counter by setting bit 0 of Timer Control Register(TCR)
    LDR R0, =(TMR32B0TCR)
    ; Load R1 with all zeros except bit 0 set
    MOVS R1, #(0x1);
    ; Store R1 into TMR32B0TCR. This starts the counter
    STR R1, [R0];
	
	
	
	POP {R0-R7,PC}
	END