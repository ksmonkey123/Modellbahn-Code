    IFNDEF LED.ALREADY_INCLUDED
    #define LED.ALREADY_INCLUDED
    IFDEF DEBUG
    messg   "included led.asm"
    ENDIF
; #############################################################################
LED_ON macro
    bsf PORTA, RA1
    ENDM
LED_OFF macro
    bcf PORTA, RA1
    ENDM
LED_INIT macro
    movlw   0xFD
    tris    PORTA
    ENDM
; #############################################################################
    ELSE
    IFDEF DEBUG
    messg   "already included!"
    ENDIF
    ENDIF