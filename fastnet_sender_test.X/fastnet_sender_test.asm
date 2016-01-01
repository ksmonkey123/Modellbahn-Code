    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

    extern  fastnet.send.init
    extern  fastnet.send.load_tris
    extern  fastnet.send
    extern  deactivate_specials

RESET_VECTOR    code    0x3ff
    goto    0x000

START_VECTOR    code    0x000
    goto    start

IRUPT_VECTOR    code    0x004
    retfie

PROGRAM_MEMORY  udata
output  res 1

PROGRAM_VECTOR  code
start:
    call    deactivate_specials
    banksel PORTB
    call    fastnet.send.load_tris
    andlw   0xef
    tris    PORTB
    call    fastnet.send.init
    bcf     PORTB, RB4
    clrf    output
    movlw   output
    movwf   FSR
main:
    bsf     PORTB, RB4
    call    fastnet.send
    bcf     PORTB, RB4
    goto    $+1
    goto    $+1
    goto    $+1
    goto    $+1
    goto    main

    end