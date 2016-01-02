    #include <p16f527.inc>

    global  serial.out
    global  serial.out.init

    extern  _global_0
    extern  _global_1
    extern  _global_2
    extern  portb.tris.unset
    extern  portb.tris.flush
    extern  portb.data.set
    extern  portb.data.flush

    #define packet  _global_0
    #define parity  _global_1
    #define index   _global_2
    #define out     PORTB, RB7
    #define out_prt PORTB

SERIAL_OUT_VECTOR  code
serial.out.init:
    movlw   b'10000000'         ; make sure a 1 is written
    lcall   portb.data.set
    lcall   portb.data.flush
    movlw   b'10000000'         ; make sure the pin is output
    lcall   portb.tris.unset
    lcall   portb.tris.flush
    return
serial.out:
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
    pagesel serial.out
serial.out_0:
    bcf     out         ; > 0 (start DATA)
    nop
    rrf     packet, F
    btfsc   STATUS, C
    bsf     out         ; > d
    goto    $+1
    nop
    bsf     out         ; > 1
    decfsz  index, F
    goto    serial.out_0
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