;###############################################
;# SBHF DECODER M1 (R - W3,4,5)                #
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
main_0:
    btfss   input, 3
    goto $+5
    btfsc   input, 2
    goto MAIN
    call SWITCH_3b
    goto APPLY
    btfss   input, 2
    goto MAIN
    ; here 01xx
    call SWITCH_3a
    btfsc   input, 1
    goto $+5
    btfsc   input, 0
    goto $+3
    call SWITCH_4b
    goto APPLY
    call SWITCH_4a
    goto APPLY
    
SWITCH_3a:
    BSF output, 0
    BTFSC state, 0
    BCF output, 0
    BSF state, 0
    BCF state, 1
    return
SWITCH_3b:
    BSF output, 1
    BTFSC state, 1
    BCF output, 1
    BSF state, 1
    BCF state, 0
    return
SWITCH_4a:
    BSF output, 2
    BTFSC state, 2
    BCF output, 2
    BSF state, 2
    BCF state, 3
    return
SWITCH_4b:
    BSF output, 3
    BTFSC state, 3
    BCF output, 3
    BSF state, 3
    BCF state, 2
    return
SWITCH_5a:
    BSF output, 4
    BTFSC state, 4
    BCF output, 4
    BSF state, 4
    BCF state, 5
    return
SWITCH_5b:
    BSF output, 5
    BTFSC state, 5
    BCF output, 5
    BSF state, 5
    BCF state, 4
    return

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