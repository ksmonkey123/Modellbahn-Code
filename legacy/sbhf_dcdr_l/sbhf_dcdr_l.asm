;###############################################
;# SBHF DECODER LEFT (R - W1,2)                #
;###############################################
;# A<0> is status LED. ON == SETUP / ILL INPUT #
;# B<7:4> need external pull-up (Input)        #
;# C<3:0> are LC-OC outputs                    #
;###############################################

#include <p16f527.inc>
__CONFIG 0x3B4

; MACRO
LED_ON MACRO
    bsf	    PORTA, RA0
    ENDM
LED_OFF MACRO
    bcf	    PORTA, RA0
    ENDM
SET_TRIS MACRO port, value
    movlw   value
    tris    port
    ENDM
READ_INPUT MACRO
    call RECEIVE
    movfw   input
    andlw   0x0F
    movwf   input
ENDM
WRITE_OUTPUT MACRO
    movfw   output
    movwf   PORTC
    ENDM

; GLOBAL VARIABLES (in shared memory)
UDATA_SHR
    output res 1
    input res 1
    state res 1

UDATA
    temp res 1
    temp2 res 1

; CODE

START_VECT  CODE    0x000
    goto start

RES_VECT    CODE    0x3FF       ; processor reset vector
    goto start			; go to beginning of program

INT_VECT    CODE    0x004	; ignore interrupts (are deactivated)
    retfie

MAIN_PROG   CODE                ; let linker place main program

start:
    ; setup
    movlb   0
    bcf	    INTCON0, GIE	; no interrupts
    MOVLB   3
    clrf    INTCON1
    clrf    ANSEL		; no analog inputs
    movlb   1
    bcf	    VRCON, VREN		; no voltage reference
    bcf	    CM1CON0, C1ON	; no comparators
    bcf	    CM2CON0, C2ON
    movlb   0
    movlw   0xC0
    option
    clrf    output
    clrf    state
    clrf    PORTC
    ; PORT SETUP
    SET_TRIS PORTA, 0xFE
    LED_ON
    SET_TRIS PORTB, 0xFF
    SET_TRIS PORTC, 0xF0
    ; port setup done, wait for system to be idle
    GOTO MAIN

RECEIVE:
    ; detect falling edge
    btfss   PORTB, 4
    goto $-1
    btfsc   PORTB, 4
    goto $-1
    ; verify reset
    movlw   0x03
    movwf   temp
    decfsz  temp, F
    goto $-1
    movlw   0x09
    movwf   temp2
    btfsc   PORTB, 4
    goto RECEIVE
    goto $+1
    goto $+1
    ; loop (the first 6µs have already passed)
receive_0
    decfsz  temp2, F
    goto $+2
    return
    movlw   0x02
    movwf   temp
    decfsz  temp, F
    goto $-1
    goto $+1
    rrf	    input, F
    goto $+1
    btfss   PORTB, 4
    goto $+3
    bsf	    input, 7
    goto $+3
    bcf	    input, 7
    nop
    goto receive_0
; MAIN PROGRAM
MAIN:
    LED_OFF
    clrf    output
    READ_INPUT
    movfw   input
    btfss   STATUS, Z
    goto main_0
    clrf    PORTC
    goto MAIN
; processing
main_0:
    btfss   input, 3
    goto $+3
    btfss   input, 2
    goto right
    btfsc   input, 3
    goto higher
    btfsc   input, 2
    goto higher
lower:
    call switch_1a
    call switch_2a
    goto APPLY
higher:
    call switch_1a
    call switch_2b
    goto APPLY
right:
    call switch_1b
APPLY:
    movfw   output
    btfsc   STATUS, Z
    goto $+3
    clrf    PORTC
    goto MAIN
    WRITE_OUTPUT
    LED_ON
    CALL DELAY
    clrf    PORTC
    LED_OFF
    CALL DELAY
    goto MAIN


switch_1a:
    bsf	    output, 0
    btfsc   state, 0
    bcf	    output, 0
    bsf	    state, 0
    bcf	    state, 1
    return
switch_1b:
    bsf	    output, 1
    btfsc   state, 1
    bcf	    output, 1
    bsf	    state, 1
    bcf	    state, 0
    return
switch_2a:
    bsf	    output, 2
    btfsc   state, 2
    bcf	    output, 2
    bsf	    state, 2
    bcf	    state, 3
    return
switch_2b:
    bsf	    output, 3
    btfsc   state, 3
    bcf	    output, 3
    bsf	    state, 3
    bcf	    state, 2
    return
DELAY:
    ;49993 cycles
    movlw	0x0E
    movwf	temp
    movlw	0x28
    movwf	temp2
Delay_0:
    decfsz	temp, f
    goto	$+2
    decfsz	temp2, f
    goto	Delay_0
    ;3 cycles
    goto	$+1
    nop
    ;4 cycles (including call)
    return


END