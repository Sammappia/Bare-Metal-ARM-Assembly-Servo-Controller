	AREA program, CODE, READONLY
	IMPORT uptime_ms
	EXPORT AAPCS_delay
	EXPORT delay_ms
	;Takes value from R1 to perform delay
	
AAPCS_delay	;	Delay count is in R0. No return values
	
delay1		;	This label is NOT exported so other source files can also use this label.
	SUBS	R0, R0, #1
	BNE		delay1
	BX LR

delay_ms	;	Delay in ms is in R0. No return values. The uptime_ms counter must be active.
	LDR R1, =uptime_ms
	LDR R2, [R1]	;	Initial tick
delay_ms_loop
	LDR R3, [R1]	;	Current tick
	SUBS R3, R2		;	Calculate delta time
	CMP R3, R0
	BLO delay_ms_loop
	BX LR
	END