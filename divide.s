	AREA program, CODE, READONLY
	EXPORT divide
	;Takes value from R0, divides by 10 to seperate individual digits in a 2 digit decimal number
	
divide	;	
	;r0 is the number divided by 10
	MOVS r1, r0  ;Set up register to hold  1s place (subtraction will take place in r1)
	MOVS r0, #0  ;Set up register to hold 10s place (count will take place in r0)
	MOVS r2, #10 ;Set up the divisor
	
	
div
	CMP r2, r1
	BGT done
	SUBS r1, r1, r2
	ADDS r0, r0, #1
	B div
	
done
	
	BX LR
	
	END