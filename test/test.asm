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
    extern  expansion.in
    extern  expansion.out
    extern  serial.out
    extern  deactivate_specials
    extern  _global_0
    extern  _global_1
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
  output res 2
;</editor-fold>

PROGRAM_VECTOR  code
start:  
    call    deactivate_specials
    banksel output
    movlw   0x80
    movwf   PORTB
    movlw   0x0f
    tris    PORTB
    clrf    PORTC
    movlw   0xf1
    tris    PORTC
    clrf    output + 0
    clrf    output + 1
    movlw   output
    movwf   FSR
    call    expansion.out
    
main:
    call    expansion.in
    call    expansion.out
    goto    main
    
    END