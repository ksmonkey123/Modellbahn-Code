    #include    <p16f527.inc>
    __config    0x3bc
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
    movlw   b'11111101' ; wdt ratio 1:32 ≈ 0.5s
    option
    clrwdt
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
    clrwdt
    swapf   PORTB, W
    andlw   0x07
    ; case selection
    addwf   PCL, F
    goto    handle_off      ; case 0
    goto    handle_track_1  ; case 1
    goto    handle_track_2  ; case 2
    goto    handle_track_3  ; case 3
    goto    handle_track_4  ; case 4
    nop                     ; case 5
    nop                     ; case 6
    nop                     ; case 7
    
handle_off:
    movlw   b'00000010'
    movwf   output
    goto    publish
    
handle_track_1:
    movf    lbhf, W
    xorlw   b'01000001'
    movlw   b'00110101'
    btfsc   STATUS, Z
    movlw   b'01010101'
    movwf   output
    goto    publish
    
handle_track_2:
    movf    lbhf, W
    andlw   b'11101110'
    xorlw   b'01000010'
    movlw   b'00110101'
    btfsc   STATUS, Z
    movlw   b'01010101'
    movwf   output
    goto    publish
    
handle_track_3:
    movf    lbhf, W
    andlw   b'11001100'
    xorlw   b'01000100'
    movlw   b'00110101'
    btfsc   STATUS, Z
    movlw   b'11010101'
    movwf   output
    goto    publish
    
handle_track_4:
    movf    lbhf, W
    andlw   b'11001100'
    xorlw   b'01001000'
    movlw   b'00111001'
    btfsc   STATUS, Z
    movlw   b'11001001'
    movwf   output
    
publish:
    movf    output, W
    xorlw   0xf0        ; invert C<4:7> for PNP drivers
    movwf   PORTC
    goto    main
    
    end