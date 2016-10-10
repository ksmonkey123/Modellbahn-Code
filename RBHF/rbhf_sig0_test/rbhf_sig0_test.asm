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
    andlw   0x0f
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
    ; proto-decode entrances
    call    entrance_lookup
    movwf   inner
    movwf   outer
    movlw   b'11100000'
    andwf   inner, F
    movlw   b'00000111'
    andwf   outer, F
    btfss   rbhf, 6
    clrf    inner
    btfss   rbhf, 7
    clrf    outer
    btfss   rbhf, 4
    clrf    inner
    btfss   rbhf, 5
    clrf    outer
    ; write outputs
    movf    exit, W
    iorwf   inner, W
    movwf   PORTC
    swapf   outer, W
    andlw   b'01110000'
    movwf   PORTB
    goto    main
    
entrance_lookup:
    movf    rbhf, W
    andlw   0x0f
    addwf   PCL, F
    ; coding: III--OOO
    retlw   b'00000000' ; 0000
    retlw   b'00100001' ; 0001
    retlw   b'01000010' ; 0010
    retlw   b'00000000' ; 0011
    retlw   b'01100011' ; 0100
    retlw   b'00100011' ; 0101
    retlw   b'01000011' ; 0110
    retlw   b'00000000' ; 0111
    retlw   b'10000100' ; 1000
    retlw   b'00100100' ; 1001
    retlw   b'01000100' ; 1010
    retlw   b'00000000' ; 1011
    retlw   b'00000000' ; 1100
    retlw   b'00000000' ; 1101
    retlw   b'00000000' ; 1110
    retlw   b'00000000' ; 1111

    end