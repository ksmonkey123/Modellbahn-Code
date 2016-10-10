    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    
; C<0:2> [DO] inner entrance main (GRY [td])
; C<4:7> [DO] inner entrance aux  (YYGG [cw])
; B<4:6> [DI] inner entrance code (track no.)
; B<7>   [BI] lbhf command bus

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
    extern  portb.init
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
rbhf    res 1
lbhf    res 1
output  res 1
;</editor-fold>

PROGRAM_VECTOR  code
start:
    call    deactivate_specials
    call    portb.init
    banksel 0
    ; configure ports
    movlw   b'11110010'
    movwf   PORTC
    movlw   b'00000000'
    tris    PORTC

main:
    ; read inputs
    movlw   lbhf
    movwf   FSR
    call    serial.in
    swapf   PORTB, W
    andlw   0x07
    ; case selection
    iorlw   0xf0
    xorlw   0xff        ; invert C<4:7> for PNP drivers
    movwf   PORTC
    goto    main
    
    end