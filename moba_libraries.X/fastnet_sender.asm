    #include <p16f527.inc>

    global  fastnet.send
    global  fastnet.send.load_tris
    global  fastnet.send.init

    extern  _global_0
    extern  _global_1
    extern  _global_2

    #define packet  _global_0
    #define parity  _global_1
    #define index   _global_2
    #define out     PORTB, RB7
    #define out_prt PORTB

FASTNET_VECTOR  code
fastnet.send.load_tris:
    retlw   0x7f
fastnet.send.init:
    banksel out_prt
    bsf     out
    return
fastnet.send:
    banksel out_prt
    bcf     out         ; > 0 (start RESET)
    movfw   INDF
    movwf   packet
    movwf   parity
    swapf   parity, W   ; > 0
    xorwf   parity, F
    rrf     parity, W
    xorwf   parity, F
    rlf     parity, W   ; > 0
    rrf     parity, F
    xorwf   parity, F
    rrf     parity, F
    bsf     out         ; > 1
    movlw   0x08
    movwf   index
    pagesel fastnet.send
fastnet.send_0:
    bcf     out         ; > 0 (start DATA)
    nop
    rrf     packet, F
    btfsc   STATUS, C
    bsf     out         ; > d
    goto    $+1
    nop
    bsf     out         ; > 1
    decfsz  index, F
    goto    fastnet.send_0
    nop
    bcf     out         ; > 0 (start PARITY)
    goto    $+1
    btfsc   parity, 0
    bsf     out         ; > p
    goto    $+1
    nop
    bsf     out         ; > 1
    return

    end