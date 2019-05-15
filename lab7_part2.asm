;***********************************
;	lab7_Part1

;***********************************
#include <ADUC841.h>
SWITCH EQU P3.2
CSEG
ORG 0000h
JMP MAIN
;______________________________________SUBROUTINES
ORG 000Bh ;TIMER 0 INT
	SETB flag0
	RETI
ORG 001Bh ;TIMER 1 INT
	SETB flag1
	RETI
;______________________________________Main
ORG 0100h
MAIN:
;_____DACs______   
	MOV DACCON, #11111111b	;8bits DACs, 0-5v, output,sync, power on
;_____Timers_____
	MOV TMOD, #00100010b	; set both timers to mode2
    MOV TH0, #06H			; set to 250 ticks
	MOV TH1, #0CEH			; set to 50 ticks
	SETB TR0                ; Activate timer 0
	SETB TR1				; Activate timer 1
    SETB ET0                ; enable timer 0 interrupt
	SETB ET1				; enable timer 1 interrupt
	MOV R2,#0000H
	MOV R3,#0000H
	SETB EA					;enables ints
	MOV DPTR,#Cosine
check_flag:
	JB SWITCH, n250_ticks
	MOV TH0, #05h			; set to 251 ticks
	jmp continue
n250_ticks:
	MOV TH0, #06h			; set to 250 ticks
continue:
	 JBC flag0,T0_INT
	 JBC flag1,T1_INT
	 jmp check_flag
T0_INT:	;Extend to INT0
	PUSH ACC
	MOV A,R2
	MOVC A,@A+DPTR
	MOV DAC0L,A
	INC R2
	POP ACC
	JMP check_flag
T1_INT: ;Extend to INT1
	PUSH ACC
	MOV A,R3
	MOVC A,@A+DPTR
	MOV DAC1L,A
	INC R3
	POP ACC
	JMP check_flag
#include <table.asm>
BSEG
 flag0: DBIT 1
 flag1: DBIT 1
END
