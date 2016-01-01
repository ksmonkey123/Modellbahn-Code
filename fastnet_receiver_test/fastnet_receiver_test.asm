    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

    extern  fastnet.receive
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
    movlw   0xFF
    tris    PORTB
    clrf    output
    movlw   output
    movwf   FSR
main:
    call    fastnet.receive
    goto    main

    end