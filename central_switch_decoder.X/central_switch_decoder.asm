    #include    <p16f527.inc>
    radix       HEX
    __config    0x3b4

    #define     DELAYTIME   .1000

;<editor-fold defaultstate="collapsed" desc="base vectors">
RESET_VECTOR    code    0x3ff
    goto    0x000

START_VECTOR    code    0x000
    lgoto   start

IRUPT_VECTOR    code    0x004
    retfie
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="library imports">
    extern  fastnet.receive, fastnet.receive.load_tris
    extern  led.on, led.off, led.init
    extern  deactivate_specials
    extern  delay
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
delay_preset    res 2   ; holds configured delay time [ms]
fastnet_input   res 1   ; holds command received from fastnet
state_cache     res 1   ; holds the cached switch states
;</editor-fold>

PROGRAM_VECTOR  code    0x100
start:
    call    deactivate_specials
    call    fastnet.receive.load_tris
    banksel PORTB
    tris    PORTB
    call    led.init
    banksel delay_preset
    movlw   LOW DELAYTIME
    movwf   delay_preset
    movlw   HIGH DELAYTIME
    movwf   delay_preset + 1
    goto    $

    END