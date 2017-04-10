    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    
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
    extern  serial.in
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
input           res 1
;</editor-fold>

PROGRAM_VECTOR  code
start:
    call    deactivate_specials
    banksel 0
    clrf    PORTC
    clrw
    tris    PORTC
    movlw   input
    movwf   FSR
main:
    call    serial.in
    movf    input, w
    movwf   PORTC
    goto    main
    
    end