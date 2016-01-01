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
    MOVFW output
    ANDLW 0x0F
    SWAPW
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
    LED_ON
    SET_TRIS PORTB, 0x0F
    SET_TRIS PORTC, 0xFF
    ; port setup done, wait for system to be idle
START0:
    READ_INPUT
    MOVFW input_0
    BTFSS STATUS, Z
    GOTO START0
    MOVFW input_1
    BTFSS STATUS, Z
    GOTO START0
    LED_OFF

    ; MAIN LOOP
MAIN:
    READ_INPUT
    ; check if only one is active. If true output that
    MOVFW input_0
    BTFSS STATUS, Z
    GOTO CHECK_0
    MOVFW input_1
    BTFSS STATUS, Z
    GOTO OUTPUT_1
    LED_OFF
    GOTO OUTPUT_NULL
CHECK_0:
    MOVFW input_1
    BTFSS STATUS, Z
    GOTO OUTPUT_0
    LED_ON
    GOTO OUTPUT_NULL
OUTPUT_NULL:
    CLRF output
    WRITE_OUTPUT
    GOTO MAIN
OUTPUT_0:
    LED_OFF
    MOVFW input_0
    MOVWF output
    WRITE_OUTPUT
    GOTO MAIN
OUTPUT_1:
    LED_OFF
    MOVFW input_1
    MOVWF output
    WRITE_OUTPUT
    GOTO MAIN

END