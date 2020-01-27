    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

; ###########################################
; # QUAD DIMMER CIRCUIT                     #
; ###########################################

;<editor-fold defaultstate="collapsed" desc="base vectors">
RESET_VECTOR    code    0x3ff
    goto    0x000
    
START_VECTOR    code    0x000
    lgoto   start

IRUPT_VECTOR    code    0x004
    retfie
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="library imports">
    extern  deactivate_specials
    extern  _global_0
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input	    res 1
output      res 3
;</editor-fold>

PROGRAM_VECTOR  code    ;0x100
; =========== START OF MAIN PROGRAM ============
; -------- processor setup and i/o init --------
start:
    call   deactivate_specials
    banksel 0
    clrw
    movwf   PORTB
    tris    PORTB
    
    clrf    input
    clrf    output + 0
    clrf    output + 1
    clrf    output + 2
; -------- processor setup and i/o init --------
main:
    ; -- PHASE 2 --
    clrf    output + 0
    clrf    output + 1
    bcf	    output + 2, 4
    movlw   b'00000011'
    andwf   input, w
    btfss   STATUS, Z
    bsf	    output + 0, 4
    btfsc   input, 1
    bsf	    output + 1, 4
    xorlw   b'00000011'
    btfsc   STATUS, Z
    bsf	    output + 2, 4
    movf    output + 2, w
    movwf   PORTB
    ; -- PHASE 3 --
    nop
    nop
    nop
    nop
    nop
    andlw   b'00010000'
    movwf   output + 2
    movlw   b'00001100'
    andwf   input, w
    btfss   STATUS, Z
    bsf	    output + 0, 5
    btfsc   input, 3
    bsf	    output + 1, 5
    xorlw   b'00001100'
    btfsc   STATUS, Z
    bsf	    output + 2, 5
    movlw   b'00110000'
    andwf   input, w
    btfss   STATUS, Z
    bsf	    output + 0, 6
    btfsc   input, 5
    bsf	    output + 1, 6
    xorlw   b'00110000'
    btfsc   STATUS, Z
    bsf	    output + 2, 6
    movlw   b'11000000'
    andwf   input, w
    btfss   STATUS, Z
    bsf	    output + 0, 7
    btfsc   input, 7
    bsf	    output + 1, 7
    xorlw   b'11000000'
    btfsc   STATUS, Z
    bsf	    output + 2, 7
    movf    output + 0, w
    movwf   PORTB
    ; -- PHASE 1 --
    movf    PORTC, w
    movwf   input
    movf    output + 1, w
    movwf   PORTB
    ; -- PHASE 2 --
    goto    main
    
    END