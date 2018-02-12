    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    #define     delay_settings_long .1000
    
    ; code for both center decoders. The pcb determines the used channel.
    ;   -> for channel 0 pull RB4 low
    ;   -> for channel 1 pull RB4 high
    
    
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
    extern  expansion.out
    extern  expansion.in
    extern  delay
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
dat res 2
;</editor-fold>

PROGRAM_VECTOR  code
start:
    call    deactivate_specials
    banksel dat
    movlw   0x80
    movwf   PORTB
    movlw   0x0f
    tris    PORTB
    clrf    PORTC
    movlw   0xf1
    tris    PORTC
    clrf    dat + 0
    clrf    dat + 1
    movlw   dat
    movwf   FSR
main:
    call    expansion.in
    call    expansion.out
    goto    main
    
    
    end