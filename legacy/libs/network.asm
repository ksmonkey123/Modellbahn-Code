    IFNDEF NETWORK.ALREADY_INCLUDED
    #define NETWORK.ALREADY_INCLUDED
    IFDEF DEBUG
    messg   "included network.asm"
    ENDIF
; #############################################################################
    #include "../libs/globals"

network.error macro thing
    error thing must be defined!
    IFDEF network.config_ok
    #undefine network.config_ok
    ENDIF
    ENDM
    #define network.config_ok

    IFNDEF network.config.sender
    IFNDEF network.config.receiver
    ERROR   "network has no config. configure as sender and/or receiver by defining network.config.sender and/or network.config.receiver"
    #undefine network.config_ok
    ENDIF
    ENDIF

    IFDEF   network.config.sender
    IFNDEF  network.out.byte
    network.error network.out.byte
    ENDIF
    IFNDEF  network.out.bit
    network.error network.out.bit
    ELSE
    IF network.out.bit < 0 || network.out.bit > 7
    ERROR   "network.out.bit must be in range [0,7] (inclusive)!"
    IFDEF network.config_ok
    #undefine network.config_ok
    ENDIF
    ENDIF
    ENDIF
    ENDIF
    IFDEF   network.config.receiver
    IFNDEF  network.in.byte
    network.error network.in.byte
    ENDIF
    IFNDEF  network.in.bit
    network.error network.in.bit
    ELSE
    IF network.in.bit < 0 || network.in.bit > 7
    ERROR   "network.in.bit must be in range [0,7] (inclusive)!"
    IFDEF network.config_ok
    #undefine network.config_ok
    ENDIF
    ENDIF
    ENDIF
    ENDIF

    IFDEF network.config_ok
    IFDEF network.config.sender
    IFDEF DEBUG
    messg   "network sender included"
    ENDIF
    #define network.out network.out.byte, network.out.bit
    #define network.data _global + 0
    #define network.temp _global + 1


NETWORK_API_VECTOR CODE
network.init:
    bsf	    network.out
    return
network.sendByte:
    banksel network.out.byte
    movfw   INDF
    movwf   network.data
    bcf	    network.out
    movlw   0x05
    movwf   network.temp
    decfsz  network.temp, F
    goto    $-1
    goto    $+1
    goto    $+1
    movlw   0x08
    movwf   network.temp
network.sendByte_0
    bcf	    network.out
    goto    $+1
    movfw   network.temp
    btfsc   STATUS, Z
    return
    decf    network.temp, F
    nop
    btfss   network.data, 0
    goto    $+4
    nop
    bsf	    network.out
    goto    $+3
    bcf	    network.out
    goto    $+1
    goto    $+1
    goto    $+1
    nop
    rrf	    network.data, F
    goto    network.sendByte_0


    #undefine	network.out
    #undefine	network.data
    #undefine	network.temp
    ENDIF

   ; =================================

    IFDEF network.config.receiver
    IFDEF DEBUG
    messg   "network receiver included"
    ENDIF
    #define network.in network.in.byte, network.in.bit
    #define network.data _global + 0
    #define network.temp _global + 1
    #define network.temp2 _global + 2

network.receiveByte:
    banksel network.in.byte
    ; detect falling edge
    btfss   network.in
    goto    $-1
    btfsc   network.in
    goto    $-1
    ; verify reset
    movlw   0x03
    movwf   network.temp
    decfsz  network.temp, F
    goto    $-1
    movlw   0x09
    movwf   network.temp2
    btfsc   network.in
    goto    network.receiveByte
    goto    $+1
    goto    $+1
    ; loop (the first 6µs have already passed)
network.receiveByte_0
    decfsz  network.temp2, F
    goto    $+4
    movfw   network.data
    movwf   INDF
    return
    movlw   0x02
    movwf   network.temp
    decfsz  network.temp, F
    goto    $-1
    goto    $+1
    rrf	    network.data, F
    goto    $+1
    btfss   network.in
    goto    $+3
    bsf	    network.data, 7
    goto    $+3
    bcf	    network.data, 7
    nop
    goto    network.receiveByte_0

    #undefine	network.in
    #undefine	network.data
    #undefine	network.temp
    #undefine	network.temp2

    ENDIF
; #############################################################################
    #undefine network.config_ok
    ENDIF
    ELSE
    IFDEF DEBUG
    MESSG "already included!"
    ENDIF
    ENDIF