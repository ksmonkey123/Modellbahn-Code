;###############################################
;# SBHF TRANSIT CONTROL W/O CACHE              #
;###############################################
;# A<0> is status LED. ON == SETUP / ILL INPUT #
;# C<5:0> need external pull-up and grounding  #
;#          buttons. (Input)                   #
;# B<7:4> are LC-OC outputs                    #
;###############################################

#include <p16f527.inc>
__CONFIG 0x3B4

; MACROS
READ_INPUT MACRO
    MOVFW PORTC
    ANDLW 0x3F
    XORLW 0x3F
    MOVWF input_buffer
ENDM

WRITE_OUTPUT MACRO
    MOVFW output_buffer
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

IS_INPUT_ACTIVE MACRO
    CLRF temp
    MOVFW input_buffer
    BTFSS STATUS, Z
    INCF temp, F
ENDM

IS_INPUT_VALID MACRO
    CLRF temp
    CLRF temp2
    ; count pressed direction buttons
    BTFSC input_buffer, 4
    INCF temp, F
    BTFSC input_buffer, 5
    INCF temp, F
    ; count pressed target buttons
    BTFSC input_buffer, 0
    INCF temp2, F
    BTFSC input_buffer, 1
    INCF temp2, F
    BTFSC input_buffer, 2
    INCF temp2, F
    BTFSC input_buffer, 3
    INCF temp2, F
    ;check that exactly one of each is pressed
    DECF temp, W
    BTFSS STATUS, Z ; one direction was pressed
    CLRF temp
    DECF temp2, W
    BTFSS STATUS, Z ; not one target was pressed
    CLRF temp
ENDM

; GLOBAL VARIABLES (in shared memory)
UDATA_SHR
    output_buffer res 1
    input_buffer res 1
    temp res 1
    temp2 res 1

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
    MOVFW input_buffer
    BTFSS STATUS, Z
    GOTO START0
    LED_OFF

    ; MAIN LOOP
MAIN:
    READ_INPUT
    IS_INPUT_ACTIVE
    MOVFW temp
    BTFSS STATUS, Z
    GOTO POTENTIAL_INPUT
    LED_OFF
    CLRF output_buffer
    WRITE_OUTPUT
    GOTO MAIN
POTENTIAL_INPUT:
    IS_INPUT_VALID
    MOVFW temp
    BTFSS STATUS, Z
    GOTO HANDLE_INPUT
    ; input is invalid
    LED_ON
    CLRF output_buffer
    WRITE_OUTPUT
    GOTO MAIN
HANDLE_INPUT:
    LED_OFF
    BTFSC input_buffer, 4 ; (K)
    GOTO HANDLE_K
    GOTO HANDLE_L
HANDLE_K:
    BTFSC input_buffer, 0 ; (B)
    MOVLF output_buffer, b'0010'
    BTFSC input_buffer, 1 ; (C)
    MOVLF output_buffer, b'0011'
    BTFSC input_buffer, 2 ; (D)
    MOVLF output_buffer, b'0100'
    BTFSC input_buffer, 3 ; (E)
    MOVLF output_buffer, b'0101'
    GOTO HANDLE_FINALIZE
HANDLE_L:
    BTFSC input_buffer, 0 ; (B)
    MOVLF output_buffer, b'1100'
    BTFSC input_buffer, 1 ; (C)
    MOVLF output_buffer, b'1101'
    BTFSC input_buffer, 2 ; (D)
    MOVLF output_buffer, b'1110'
    BTFSC input_buffer, 3 ; (E)
    MOVLF output_buffer, b'1111'
    GOTO HANDLE_FINALIZE
HANDLE_FINALIZE:
    WRITE_OUTPUT
    GOTO MAIN
END