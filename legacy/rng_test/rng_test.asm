;###########
;# RNG POC #
;###########
#include <p16f527.inc>
__CONFIG 0x3B4

; GLOBAL VARIABLES (in shared memory)
UDATA_SHR
    random res 1
    bitcnt res 1
    ;output res 1
UDATA
    myoutput res 2
    temp     res 1
; CODE

START_VECT  CODE    0x000
    GOTO    START

RES_VECT    CODE    0x3FF       ; processor reset vector
    GOTO    START		; go to beginning of program

INT_VECT    CODE    0x004	; ignore interrupts (are deactivated)
    RETFIE

MAIN_PROG   CODE                ; let linker place main program
START:
    MOVLW   0xCE
    MOVWF   random
    CLRF    myoutput
    CLRF    myoutput + 1
    goto    MAIN

LOOKUP:
    addwf   PCL, F
    retlw   b'00000001'
    retlw   b'00000010'
    retlw   b'00000100'
    retlw   b'00001000'
    retlw   b'00010000'
    retlw   b'00100000'
    retlw   b'01000000'
    retlw   b'10000000'

RAND:
    RLF	    random, W
    RLF	    random, W
    BTFSC   random, 4
    XORLW   0x01
    BTFSC   random, 5
    XORLW   0x01
    BTFSC   random, 3
    XORLW   0x01
    MOVWF   random
    andlw   0x07
    return

MAIN:
    call RAND
    call LOOKUP
    movwf   temp
    call RAND
    call LOOKUP
    andlw   0xF0
    btfsc   STATUS, Z
    goto write_upper
    ; write lower
    movfw   temp
    iorwf   myoutput, F

END