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
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input   res 2
buffer  res 1
output  res 2
;</editor-fold>

PROGRAM_VECTOR code
start:   
    call    deactivate_specials
    movlw   0x80
    movwf   PORTB
    movlw   0x0f
    tris    PORTB
    clrf    PORTC
    movlw   0xf9
    tris    PORTC
    clrf    buffer
    clrf    output + 0
    clrf    output + 1
main:
    movlw   output
    movwf   FSR
    call    expansion.out
    call    serial.out
    movlw   input
    movwf   FSR
    call    expansion.in
    movf    input, w
    movwf   output
    goto    main
    
    end