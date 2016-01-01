;###############################################
;# SBHF TERMINAL CONTROL W/O CACHE             #
;###############################################
;# A<0> is status LED. ON == SETUP / ILL INPUT #
;# C<7:0> need external pull-up and grounding  #
;#          buttons. (Input)                   #
;# B<7:4> are LC-OC outputs                    #
;###############################################

#include <p16f527.inc>
__CONFIG 0x3B4

; MACROS
READ_INPUT MACRO
    MOVFW PORTC
    XORLW 0xFF
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
    BTFSC input_buffer, 6
    INCF temp, F
    BTFSC input_buffer, 7
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
    BTFSC input_buffer, 4
    INCF temp2, F
    BTFSC input_buffer, 5
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
    BTFSC input_buffer, 6 ; (K)
    GOTO HANDLE_K
    GOTO HANDLE_L
HANDLE_K:
    LED_OFF
    BTFSC input_buffer, 0 ; (A)
    MOVLF output_buffer, b'0001'
    BTFSC input_buffer, 1 ; (F)
    MOVLF output_buffer, b'0110'
    BTFSC input_buffer, 2 ; (G)
    MOVLF output_buffer, b'0111'
    BTFSC input_buffer, 3 ; (H)
    MOVLF output_buffer, b'1000'
    BTFSC input_buffer, 4 ; (I)
    MOVLF output_buffer, b'1001'
    BTFSC input_buffer, 5 ; (J)
    MOVLF output_buffer, b'1010'
    GOTO HANDLE_FINALIZE
HANDLE_L: ; L is not accessible
    LED_ON
    CLRF output_buffer
    GOTO HANDLE_FINALIZE
HANDLE_FINALIZE:
    WRITE_OUTPUT
    GOTO MAIN
END