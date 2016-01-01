    #include <p16f527.inc>

    global  network.receive
    global  network.receive.load_tris

    extern  _global_0
    extern  _global_1
    extern  _global_2

    #define in RB7

    #define index   _global_0
    #define temp    _global_1
    #define value   _global_2

NETWORK_RECEIVE_VECTOR CODE
network.receive.load_tris:
    retlw   0xFF

network.receive:
    pagesel network.receive
    banksel 0
    clrf    value
receive_0:
    ; detect falling edge
    btfss   PORTB, in
    goto    $-1
    btfsc   PORTB, in
    goto    $-1
    ; verify reset
    movlw   0x03
    movwf   temp
    decfsz  temp, F
    goto    $-1
    movlw   0x09
    movwf   index
    btfsc   PORTB, in
    goto    receive_0
    goto    $+1
    goto    $+1
    ; loop (the first 6µs have already passed)
receive_1:
    decfsz  index, F
    goto    $+2
    goto    receive_2
    movlw   0x02
    movwf   temp
    decfsz  temp, F
    goto    $-1
    goto    $+1
    rrf	    value, F
    goto    $+1
    btfss   PORTB, in
    goto    $+3
    bsf	    value, 7
    goto    $+3
    bcf	    value, 7
    nop
    goto    receive_1
receive_2:
    movfw   value
    movwf   INDF
    return

    END