;###############################################
;# SIGNAL BUTTON CONTROL & SIGNAL STATE CACHE  #
;###############################################
;# A<0> is status LED. ON == SETUP / ERROR     #
;# C<4:0> need external pull-up and grounding  #
;#          buttons. (Input)                   #
;# B<6:4> are driven outputs. DO NOT PULL!!!   #
;###############################################

#include <p16f527.inc>

#define FLASH_ADDRESS 0x00
#define last_input 0x0C
#define temp1 0x0D
#define temp2 0x0E
#define temp3 0x0F

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
    MOVLW 0x1F
    TRIS PORTC
    MOVLW 0x8F
    TRIS PORTB
    ; wait for inputs (all buttons must be 1)
WAIT_FOR_SYSTEM:
    MOVFW PORTC
    IORLW 0xE0
    XORLW 0xFF
    BTFSS STATUS, Z
    GOTO WAIT_FOR_SYSTEM
    ; system is ready. Load old value from Flash
    MOVLB 1
    MOVLW FLASH_ADDRESS
    MOVWF EEADR
    BSF EECON, RD
    MOVFW EEDATA
    MOVLB 0
    IORLW 0xE0
    MOVWF temp1
    MOVWF last_input
    CLRF temp2 ; count number of 0s
    MOVLW 8
    MOVWF temp3
setup_loop:
    DECF temp3, F
    RLF temp1, F
    BTFSS STATUS, C
    INCF temp2, F
    MOVF temp3, F
    BTFSS STATUS, Z
    GOTO setup_loop
    ; check if only 1 zero is present
    DECFSZ temp2, F
    GOTO LOAD_DEFAULT
    CALL GET_OUTPUT
    MOVWF PORTB
    BCF PORTA, RA0 ; setup done - erase status LED
    GOTO MAIN
LOAD_DEFAULT:
    MOVLW 0xFE
    MOVWF last_input
    CALL GET_OUTPUT
    MOVWF PORTB
    BCF PORTA, RA0 ; setup done - erase status LED
    GOTO MAIN
GET_OUTPUT: ;converts the value of last_input to the matching output value
    BTFSS last_input, 0
    RETLW 0x00
    BTFSS last_input, 1
    RETLW 0x40
    BTFSS last_input, 2
    RETLW 0x50
    BTFSS last_input, 3
    RETLW 0x20
    BTFSS last_input, 4
    RETLW 0x30
    RETLW 0x80
MAIN:
    MOVLB 0
    ; STEP 0: wait for any button press
    MOVFW PORTC
    IORLW 0xE0
    XORLW 0xFF
    BTFSC STATUS, Z
    GOTO MAIN
    ; STEP 1: check if input is a new one
    XORLW 0xFF
    MOVWF temp1
    XORWF last_input, W
    BTFSC STATUS, Z
    GOTO MAIN
    ; STEP 2: process change
    MOVFW temp1
    MOVWF last_input
    CALL GET_OUTPUT
    MOVWF PORTB
    ; STEP 3: write last_input to flash
    ;erase
    MOVLB 1
    MOVLW FLASH_ADDRESS
    MOVWF EEADR
    BSF EECON, FREE
    BSF EECON, WREN
    BSF EECON, WR
    ;write new value
    MOVLW 4
    MOVWF temp2
write_loop:
    DECF temp2, F
    MOVLW FLASH_ADDRESS
    MOVWF EEADR
    MOVFW last_input
    MOVWF EEDATA
    BSF EECON, WREN
    BSF EECON, WR
    MOVF temp2, F
    BTFSS STATUS, Z
    GOTO write_loop
    ;validate data
    MOVLW FLASH_ADDRESS
    MOVWF EEADR
    BSF EECON, RD
    MOVFW EEDATA
    XORWF last_input, W
    BTFSS STATUS, Z
    GOTO ERROR_STATE
    MOVLB 0
    GOTO MAIN

ERROR_STATE:
    ; ERROR CONDITION - FLASH FAILED!
    MOVLB 0
    CLRF PORTB
    BSF PORTA, RA0 ; activate status LED to indicate failure
    GOTO $ ; freeze

    END