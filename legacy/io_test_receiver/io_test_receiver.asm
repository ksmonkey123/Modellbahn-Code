;###############################################
;# RECEIVER TEST                               #
;###############################################
;# A<0> is status LED			       #
;# B<4> is input (p/u required)		       #
;# C<0:7> are output (O/C)		       #
;###############################################

#include <p16f527.inc>

UDATA_SHR
    input res 1
    temp res 1
    temp2 res 1

__CONFIG 0x3B4

START_VECT  CODE    0x000
    GOTO START

RES_VECT    CODE    0x3FF       ; processor reset vector
    GOTO START			; go to beginning of program

INT_VECT    CODE    0x004	; ignore interrupts (are deactivated)
    RETFIE

MAIN_PROG   CODE                ; let linker place main program

START:
    ; setup
    MOVLB 0
    BCF INTCON0, GIE	; no interrupts
    MOVLB 3
    CLRF INTCON1
    CLRF ANSEL		; no analog inputs
    MOVLB 1
    BCF VRCON, VREN	; no voltage reference
    BCF CM1CON0, C1ON	; no comparators
    BCF CM2CON0, C2ON
    MOVLB 0
    MOVLW 0xC0
    OPTION
    ;MOVLW 0x3E
    ;TRIS PORTA
    ;MOVLW 0x01
    ;MOVWF PORTA ; activate status LED to indicate setup
    clrf    PORTC
    MOVLW 0x00
    TRIS PORTC
    MOVLW 0xFF
    TRIS PORTB
    goto MAIN

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
MAIN:
    call RECEIVE
    movfw   input
    movwf   PORTC
    goto MAIN

    END