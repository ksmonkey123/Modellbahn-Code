;###############################################
;# DELAY TEST                                  #
;###############################################
;# A<0> is status LED			       #
;###############################################

#include <p16f527.inc>

UDATA_SHR
    d1 res 1
    d2 res 1
    d3 res 1

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
    MOVLW 0xFC
    TRIS PORTC
    MOVLW 0xFF
    TRIS PORTB

    ; MAIN
MAIN:
    ; activate A
    BSF PORTA, RA0
    MOVLW 0x01
    MOVWF PORTC
    CALL Delay
    ; deactivate A
    CLRF PORTC
    BCF PORTA, RA0
    CALL MEGADELAY
    ; activate B
    BSF PORTA, RA0
    MOVLW 0x02
    MOVWF PORTC
    CALL Delay
    ; deactivate B
    CLRF PORTC
    BCF PORTA, RA0
    CALL MEGADELAY
    GOTO MAIN


    ; ===========

MEGADELAY:
    CALL Delay
;    CALL Delay
;    CALL Delay
;    CALL Delay
;    CALL Delay
;    CALL Delay
;    CALL Delay
;    CALL Delay
;    CALL Delay
;    CALL Delay
    RETLW 0x00

; Delay 50ms
Delay
			;49993 cycles
    movlw	0x0E
    movwf	d1
    movlw	0x28
    movwf	d2
Delay_0
    decfsz	d1, f
    goto	$+2
    decfsz	d2, f
    goto	Delay_0

			;3 cycles
    goto	$+1
    nop

			;4 cycles (including call)
    return


    END