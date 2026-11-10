
	AREA FLASH, CODE, READONLY
	INCLUDE	LPC11xx.inc
    EXPORT SystemInit
SystemInit
	;    ____  ____     _   ______  ______   __  _______  ____  ____________  __
	;   / __ \/ __ \   / | / / __ \/_  __/  /  |/  / __ \/ __ \/  _/ ____/\ \/ /
	;  / / / / / / /  /  |/ / / / / / /    / /|_/ / / / / / / // // /_     \  / 
	; / /_/ / /_/ /  / /|  / /_/ / / /    / /  / / /_/ / /_/ // // __/     / /  
	;/_____/\____/  /_/ |_/\____/ /_/    /_/  /_/\____/_____/___/_/       /_/   
	; Enable clock for I/O config block, GPIO, and 32-bit counter/timer in SYSAHBCLKCTRL
   
    ; First, load the address of SYSAHBCLKCTRL into R0
    LDR R0, =(SYSAHBCLKCTRL); SYSAHBCLKCTRL, address 0x4004 8080
    ; Load R1 with the value of SYSAHBCLKCTRL
    LDR R1, [R0];
    ; Load the bit pattern to enable clock for I/O config block(bit 16), GPIO(bit 6),
    ; 32-bit counter/timer0(bit 9) and 16-bit counter/timer1 (bit8) into R2
    LDR R2, =(0x10340);
    ; Apply bitwise OR between R1(value of SYSAHBCLKCTRL) and R2(new bit pattern)
    ; and save the result into R1
    ORRS R1, R2;
    ; Store the new value of R1 into SYSAHBCLKCTRL
    STR R1, [R0];
	
	; Enable CT16B1 interrupt (bit 17) and PIO0 interrupt (bit 31) in Nested Vectored Interrupt Controller(NVIC)
    ; Load the address of Interrupt Set Register(ISER) of NVIC into R0
    LDR R0, =(NVIC_ISER); ISER of NVIC, address 0xE000 E100
    ; Load R1 with all zeros except bit-18 set
    MOVS R1, #0x1
	LSLS R2, R1, #17	;	CT16B1
	LSLS R1, R1, #31	;	PIO0
	ORRS R1, R2
    ; Store the value of R1 into ISER of NVIC
    STR R1, [R0];
	
	LDR R0, =IPR7	;	Set interrupt priority of PIO0 to lower (than default) so timer interrupt can happen inside PIO interrupt
	LDR R1, [R0]
	LSLS R1, #8		;	Erase existing Exception 31 priority.
	ADDS R1, #0xC0	;	This sets priority to highest value, thus lowest priority.
	MOVS R2, #8
	RORS R1, R2
	STR R1, [R0]
	
	BX LR

	END