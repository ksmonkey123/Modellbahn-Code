    #include    <p16f527.inc>
    __config    0x3B4
  
;<editor-fold defaultstate="collapsed" desc="base vectors">
RESET_VECTOR    code    0x3ff
    goto    0x000

START_VECTOR    code    0x000
    lgoto   start

IRUPT_VECTOR    code    0x004
    retfie
;</editor-fold>
    
;<editor-fold defaultstate="collapsed" desc="library imports">
    extern  deactivate_specials
    extern  led.init, led.on, led.off
;</editor-fold>

PROGRAM_VECTOR  code
start:
    call   deactivate_specials
    call   led.init
    call   led.off
    clrf    PORTB
    movlw   0x7f
    tris    PORTB
main:
    ; await button press
    btfss   PORTB, 4
    goto    $-1
    ; turn on
    movlw   0x80
    movwf   PORTB
    call    led.on
    ; await button release
    btfsc   PORTB, 4
    goto    $-1
    ; await button press
    btfss   PORTB, 4
    goto    $-1
    ; turn off
    clrf    PORTB
    call    led.off
    ; await button release
    btfsc   PORTB, 4
    goto    $-1
    goto    main
    
    end