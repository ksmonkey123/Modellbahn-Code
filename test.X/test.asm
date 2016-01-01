    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

    extern  deactivate_specials

MAIN_RAM        udata
count   res 1

RESET_VECTOR    code    0x000
    goto    start

MAIN_VECTOR     code    0x010
start:
    lcall   deactivate_specials
    banksel 0
    movlw   0xff
    tris    PORTB
    movlw   0x00
    tris    PORTC
    banksel count
    clrf    count

main:
    banksel 0
    btfsc   PORTB, RB7  ; wait for high
    goto    $-1
    btfss   PORTB, RB7  ; wait for low
    goto    $-1
    banksel count
    incf    count, F
    movfw   count
    banksel 0
    movwf   PORTC
    goto    main

    end