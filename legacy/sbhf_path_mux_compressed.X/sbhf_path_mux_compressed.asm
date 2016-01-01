;###############################################
;# SBHF PATH XOR MULTIPLEXER W/O CACHE         #
;###############################################
;# A<0> is status LED. ON == SETUP / ILL INPUT #
;# C<7:0> need external pull-up (Input)        #
;# B<7:4> are LC-OC outputs                    #
;###############################################

#include <p16f527.inc>
__CONFIG 0x3B4

; MACROS
READ_INPUT MACRO
    MOVFW PORTC
    XORLW 0xFF
    MOVWF temp
    ANDLW 0x0F
    MOVLW input_0
    SWAPF temp, W
    ANDLW 0x0F
    MOVLW input_1
ENDM

WRITE_OUTPUT MACRO
    SWAPF output, W
    ANDLW 0xF0
    MOVWF PORTB
ENDM

LED_ON MACRO
    BSF PORTA, RA0
ENDM

LED_OFF MACRO
    BCF PORTA, RA0
ENDM

SET_TRIS MACRO port, value
    MOVLW value
    TRIS port
ENDM

MOVLF MACRO addr, value
    MOVLW value
    MOVWF addr
ENDM

SWAPW MACRO
    MOVWF temp
    SWAPF temp, W
ENDM

IORLF MACRO addr, value
    MOVFW addr
    IORLW value
    MOVWF addr
ENDM

; GLOBAL VARIABLES (in shared memory)
UDATA_SHR
    output res 1
    input_0 res 1
    input_1 res 1
    temp res 1

; CODE

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
    ; PORT SETUP
    SET_TRIS PORTA, 0xFE
    LED_OFF
    CLRF PORTB
    SET_TRIS PORTB, 0x0F
    SET_TRIS PORTC, 0xFF
    CLRF PORTB
    GOTO MAIN

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
    bcf	    PORTB, 4
    goto $+3
    bsf	    PORTB, 4
    goto $+1
    goto $+1
    goto $+1
    nop
    rrf	    output, F
    goto send_0

MAIN:
    MOVFW PORTC
    XORLW 0xFF
    BTFSC STATUS, Z
    GOTO NOOP
    MOVWF output
    BTFSC output, 0
    GOTO LINEAR
    BTFSC output, 1
    GOTO LINEAR
    BTFSC output, 2
    GOTO LINEAR
    BTFSC output, 3
    GOTO LINEAR
    LED_ON
    swapf output, F
    call SEND
    GOTO MAIN
LINEAR:
    BTFSC output, 4
    GOTO NOOP
    BTFSC output, 5
    GOTO NOOP
    BTFSC output, 6
    GOTO NOOP
    BTFSC output, 7
    GOTO NOOP
    LED_ON
    call SEND
    GOTO MAIN
NOOP:
    LED_OFF
;    clrf output
;    call SEND
    GOTO MAIN

END