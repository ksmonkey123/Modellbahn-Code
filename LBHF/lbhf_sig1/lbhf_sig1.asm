    #include    <p16f527.inc>
    __config    0x3bc
    radix       HEX

; C<0:3> [DO] entrance main (GRYG [td])
; C<4:7> [DO] entrance aux  (YYGG [cw]) (driven over PNP, therefore invert I/O)
; B<4:6> [DI] entrance code (track no.)
; B<7>   [BI] rbhf command bus

;<editor-fold defaultstate="collapsed" desc="library imports">
    extern  deactivate_specials
    extern  serial.in
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
rbhf    res 1
lbhf    res 1
output  res 1
;</editor-fold>

PROGRAM_VECTOR  code 0x000
start:
    movlw   b'11111101' ; wdt ratio 1:32 ≈ 0.5s
    option
    clrwdt
    call    deactivate_specials
    banksel 0
    clrwdt  
    ; configure portc for output
    movlw   b'11110010'
    movwf   PORTC
    movlw   0x00
    tris    PORTC
    
main:
    ; read inputs
    movlw   rbhf
    movwf   FSR
    call    serial.in
    swapf   PORTB, W
    andlw   0x07
    movwf   lbhf
    clrwdt
    ; case selection
    btfsc   STATUS, Z
    goto    handle_off
    movlw   0x01
    xorwf   lbhf, W
    btfsc   STATUS, Z
    goto    handle_track_1
    movlw   0x02
    xorwf   lbhf, W
    btfsc   STATUS, Z
    goto    handle_track_2
    movlw   0x03
    xorwf   lbhf, W
    btfsc   STATUS, Z
    goto    handle_track_3
    goto    handle_track_4
    
handle_off:
    movlw   b'00000010'
    movwf   output
    goto    publish
    
handle_track_1:
    movlw   b'01000001'
    andwf   rbhf, W
    xorlw   b'00000001'
    movlw   b'00110101'
    btfsc   STATUS, Z
    movlw   b'01010101'
    movwf   output
    goto    publish
    
handle_track_2:
    movlw   b'01000010'
    andwf   rbhf, W
    xorlw   b'00000010'
    movlw   b'00110101'
    btfsc   STATUS, Z
    movlw   b'01010101'
    movwf   output
    goto    publish
    
handle_track_3:
    movlw   b'10000100'
    andwf   rbhf, W
    xorlw   b'00000100'
    movlw   b'00111001'
    btfsc   STATUS, Z
    movlw   b'01011001'
    movwf   output
    goto    publish
    
handle_track_4:
    movlw   b'10001000'
    andwf   rbhf, W
    xorlw   b'00001000'
    movlw   b'00110001'
    btfsc   STATUS, Z
    movlw   b'11010001'
    btfss   rbhf, 5
    andlw   b'01111111'
    movwf   output
    
publish:
    movf    output, W
    xorlw   0xf0 ; invert aux for PNP drivers
    movwf   PORTC
    goto    main
    
    end