    #include <p16f527.inc>

    global  network.send
    global  network.send.init
    global  network.send.load_tris

    extern  _global_0
    extern  _global_1

    #define value   _global_0
    #define temp    _global_1

NETWORK_SEND_VECTOR CODE
network.send.load_tris:
    retlw   0x7F

network.send.init:
    banksel PORTB
    bsf	    PORTB, RB7
    return
network.send:
    pagesel network.send
    banksel PORTB
    movfw   INDF
    movwf   value
    bcf	    PORTB, RB7
    movlw   0x05
    movwf   temp
    decfsz  temp, F
    goto $-1
    goto $+1
    goto $+1
    movlw   0x08
    movwf   temp
network.send_0:
    bsf	    PORTB, RB7
    goto $+1
    movfw   temp
    btfsc   STATUS, Z
    return
    decf    temp, F
    nop
    btfss   value, 0
    goto $+4
    nop
    bsf	    PORTB, RB7
    goto $+3
    bcf	    PORTB, RB7
    goto $+1
    goto $+1
    goto $+1
    nop
    rrf	    value, F
    goto network.send_0

    END