    #include    <p16f527.inc>

    extern  _global_0
    extern  _global_1
    extern  _global_2

    #define index   _global_0
    #define packet  _global_1
    #define parity  _global_2
    #define in_prt  PORTB
    #define in      PORTB, RB7

    global  fastnet.receive
    global  fastnet.receive.load_tris

FASTNET_RECEIVER_VECTOR code
fastnet.receive.load_tris:
    retlw   0xFF
fastnet.receive:
    banksel in_prt
    pagesel read
read:
    btfsc   in
    goto    read
    movlw   0x09
    movwf   index
    btfsc   in
    goto    read
    clrf    packet
    bcf     STATUS, C
    btfsc   in
    goto    read
    clrf    parity
    nop
    btfss   in
    goto    read
    nop ; NOTE: PCL update times are broken in simulator! This is correct!
loop:
    rrf     packet, F
    btfsc   in
    goto    read
    decf    index, F
    movlw   loop
    btfsc   in
    bsf     STATUS, C
    btfsc   STATUS, Z
    movlw   validate
    btfsc   in
    movwf   PCL
    goto    read
validate: ; current version does not validate checksum. Presence check only
    movfw   packet
    movwf   INDF
    return
    end