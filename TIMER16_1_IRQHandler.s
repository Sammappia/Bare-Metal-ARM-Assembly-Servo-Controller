;	TMR16B1-driven millisecond tick
;	Make sure to set priorities of other handlers that rely on this time tick for delays to lower priority than this

	AREA PROGRAM, CODE, READONLY
	INCLUDE	LPC11xx.inc
	EXPORT TIMER16_1_IRQHandler
	EXPORT uptime_ms
	EXPORT keypressed
	EXPORT mem1
	EXPORT mem2
	EXPORT mem3
	EXPORT mem4
	EXPORT currState
	EXPORT clearflag
		
		
TIMER16_1_IRQHandler\
	PROC
	PUSH {R4-R7,LR}
	
	LDR R0, =(TMR16B1IR)	;RW1
	LDR R1, [R0]
	LDR R2, =(0x1)			;001, acknowledge interrupt (match register 0)
	STR R2, [R0]
	
	;Update uptime_ms in memory
	LDR R0, =uptime_ms
	LDR R1, [R0]
	ADDS R1, R1, #1
	STR R1, [R0]
	
	POP {R4-R7,PC}
	ENDP
	
	AREA Variables, DATA, READWRITE, ALIGN=2
uptime_ms
	DCD 0
keypressed
	DCD 0
mem1
	DCD 0
mem2
	DCD 0
mem3
	DCD 0
mem4
	DCD 0
currState
	DCD 0
clearflag
	DCD 0
;Memory Addresses for uptime, keypressed, and mem 1 through 4
;Added tracker for currState as per my design
;Added flag to keep track of needing to clear the screen from st2 to st0
		
	END