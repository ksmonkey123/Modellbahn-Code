;###############################################
;# SWITCH DRIVER HARDWARE TEST                 #
;###############################################
;# A<0> is status LED. ON == SETUP / ERROR     #
;# B<0> needs external pull-up and grounding   #
;#          buttons. (Input)                   #
;# C<0> is driven output. DO NOT PULL!!!       #
;###############################################

#include <p16f527.inc>

UDATA_SHR
    output res 1

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
    MOVLW 0xFE
    TRIS PORTC
    MOVLW 0xFF
    TRIS PORTB
    ; wait for inputs (all buttons must be 1)
WAIT_FOR_SYSTEM:
    BTFSS PORTB, RB4
    GOTO WAIT_FOR_SYSTEM
MAIN:
    CLRF output
    BTFSS PORTB, RB4
    BSF output, 0
    MOVFW output
    MOVWF PORTC
    MOVWF PORTA
    GOTO MAIN

    END