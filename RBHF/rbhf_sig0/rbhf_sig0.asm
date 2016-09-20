    #include    <p16f527.inc>
    __config    0x3bc
    radix       HEX

; C<0:4> [DO] exits 1-4 (C<4> is fast mode for track 4 (set w/ C<3>)
; C<5:7> [DO] inner entrance code (track no.)
; B<4:6> [DO] outer entrance code (track no.)
; B<7>   [BI] rbhf command bus

    extern  deactivate_specials
    extern  serial.in
PROGRAM_RAM udata
rbhf    res 1
exit    res 1
inner   res 1
outer   res 1

PROGRAM_VECTOR  code 0x000
start:
    movlw   b'11111101' ; wdt ratio 1:32 ≈ 0.5s
    option
    clrwdt
    call    deactivate_specials
    banksel 0
    clrwdt
    clrf    PORTB
    movlw   0x8f
    tris    PORTB
    clrf    PORTC
    movlw   0x00
    tris    PORTC
    movlw   rbhf
    movwf   FSR
main:
    call    serial.in
    clrwdt
    clrf    exit
    clrf    inner
    clrf    outer
    ; set exits
    movf    rbhf, W
    btfsc   rbhf, 6
    andlw   0x0c
    btfsc   rbhf, 7
    andlw   0x03
    movwf   exit
    movf    rbhf, W
    andlw   b'10101000'
    xorlw   b'00101000'
    btfss   STATUS, Z
    goto    $+3
    bsf     exit, 4
    bcf     exit, 3
    ; determine inner entrance code
    movf    rbhf, W
    andlw   b'01010000'
    xorlw   b'01010000'
    btfss   STATUS, Z
    goto    decode_outer
    clrw
    btfsc   rbhf, 3 ; tracks 1 and 2 take precedence over 3 and 4
    movlw   0x04
    btfsc   rbhf, 2
    movlw   0x03
    btfsc   rbhf, 1
    movlw   0x02
    btfsc   rbhf, 0
    movlw   0x01
    movwf   inner
    
decode_outer:
    movf    rbhf, W
    andlw   b'10100000'
    xorlw   b'10100000'
    btfss   STATUS, Z
    goto    publish
    clrw
    btfsc   rbhf, 0 ; tracks 3 & 4 take precedence over 1 & 2
    movlw   0x01
    btfsc   rbhf, 1
    movlw   0x02
    btfsc   rbhf, 2
    movlw   0x03
    btfsc   rbhf, 3
    movlw   0x04
    movwf   outer

; PUBLISHING
publish:
    movlw   b'00011111'
    andwf   exit, F
    swapf   inner, F
    rlf     inner, W
    andlw   b'11100000'
    iorwf   exit, W
    movwf   PORTC
    swapf   outer, W
    andlw   b'01110000'
    movwf   PORTB
    goto    main

    end