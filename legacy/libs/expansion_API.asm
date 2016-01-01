    IFNDEF EXPANSION.ALREADY_INCLUDED
    #define EXPANSION.ALREADY_INCLUDED
    IFDEF DEBUG
    messg   "included expansion_API.asm"
    ENDIF
; #############################################################################
    #include "../libs/globals"

    #define expansion.data  _global_0
    #define expansion.index _global + 2

    #define expansion.out.port	 PORTB
    #define expansion.out.strobe PORTB, 6
    #define expansion.out.clock	 PORTB, 5
    #define expansion.out.data   PORTB, 4

    #define expansion.in.port PORTC
    #define expansion.in.a0   PORTC, 3
    #define expansion.in.a1   PORTC, 2
    #define expansion.in.a2   PORTC, 1
    #define expansion.in.z0   PORTC, 4
    #define expansion.in.z1   PORTC, 5

EXPANSION_API_VECTOR CODE
; ###########################################
; # OUTPUT WRITE FUNCTION		    #
; ###########################################
; # this function uses the byte addressed   #
; #   through FSR as the lower 8 bits, and  #
; #   FSR+1 as the higher 8 bits.	    #
; ###########################################
expansion.write:
    ; copy the input data into working files
    incf    FSR, F
    movfw   INDF
    movwf   expansion.data
    decf    FSR, F
    ; write working files to indf and bank to PORTB
    banksel expansion.out.port
    ; write bytes
    call    expansion.write.sendByte
    movfw   INDF
    movwf   expansion.data
    call    expansion.write.sendByte
    bsf	    expansion.out.strobe
    bcf	    expansion.out.strobe
    return
expansion.write.sendByte
    movlw   0x08
    movwf   expansion.index
    bcf	    expansion.out.data
    rlf	    expansion.data, F
    btfsc   STATUS, C
    bsf	    expansion.out.data
    bsf	    expansion.out.clock
    bcf	    expansion.out.clock
    bcf	    expansion.out.data
    decfsz  expansion.index, F
    goto    $-7
    return

expansion.read:
    banksel expansion.in.port
    movlw   0x08
    movwf   expansion.index
expansion.read_0
    decf    expansion.index, F
    bcf	    expansion.in.a0
    bcf	    expansion.in.a1
    bcf	    expansion.in.a2
    btfsc   expansion.index, 0
    bsf	    expansion.in.a0
    btfsc   expansion.index, 1
    bsf	    expansion.in.a1
    btfsc   expansion.index, 2
    bsf	    expansion.in.a2
    bcf	    STATUS, C
    btfss   expansion.in.z0
    bsf	    STATUS, C
    rlf	    expansion.data + 0, F
    bcf	    STATUS, C
    btfss   expansion.in.z1
    bsf	    STATUS, C
    rlf	    expansion.data + 1, F
    movfw   expansion.index
    btfss   STATUS, Z
    goto    expansion.read_0
    movfw   expansion.data + 0
    movwf   INDF
    incf    FSR, F
    movfw   expansion.data + 1
    movwf   INDF
    decf    FSR, F
    return

    #undefine expansion.data
    #undefine expansion.index
    #undefine expansion.out.port
    #undefine expansion.out.strobe
    #undefine expansion.out.clock
    #undefine expansion.out.data
    #undefine expansion.in.port
    #undefine expansion.in.a0
    #undefine expansion.in.a1
    #undefine expansion.in.a2
    #undefine expansion.in.z0
    #undefine expansion.in.z1

; #############################################################################
    ELSE
    IFDEF DEBUG
    MESSG "already included"
    ENDIF
    ENDIF