;###############################################
;# SENDER TEST                                 #
;###############################################
;# A<0> is status LED			       #
;# B<4> is output (O/C)			       #
;# C<0:7> are input (Pull-Up required)	       #
;###############################################

#include <p16f527.inc>

UDATA_SHR
    output res 1
    temp res 1

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
    MOVLW 0x3E
    TRIS PORTA
    MOVLW 0x01
    MOVWF PORTA ; activate status LED to indicate setup
    MOVLW 0xFF
    TRIS PORTC
    MOVLW 0xEF
    TRIS PORTB
    goto MAIN

SEND:
    bsf	    PORTB, 4
    movlw   0x05
    movwf   temp
    decfsz  temp, F
    goto $-1
    goto $+1
    goto $+1
    movlw   0x08
    movwf   temp
send_0
    bcf	    PORTB, 4
    goto $+1
    movfw   temp
    btfsc   STATUS, Z
    return
    decf    temp, F
    nop
    btfss   output, 0
    goto $+4
    nop
    bsf	    PORTB, 4
    goto $+3
    bcf	    PORTB, 4
    goto $+1
    goto $+1
    goto $+1
    nop
    rrf	    output, F
    goto send_0
    
MAIN:
    movfw   PORTC
    movwf   output
    call    SEND
    goto    MAIN

    END