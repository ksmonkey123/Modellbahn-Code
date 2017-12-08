    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    
; ================ CHIP ADDRESS ================
    #DEFINE     ADDRESS     0x00
    
;<editor-fold defaultstate="collapsed" desc="base vectors">
RESET_VECTOR    code    0x3ff
    goto    0x000
    
START_VECTOR    code    0x000
    lgoto   start

IRUPT_VECTOR    code    0x004
    retfie
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="library imports">
    extern  serial.in
    extern  deactivate_specials
    extern  _global_0
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input       res 1
address     res 1
output      res 1
mask        res 1
;</editor-fold>

PROGRAM_VECTOR  code    ;0x100
; =========== START OF MAIN PROGRAM ============
; -------- processor setup and i/o init --------
start:
    call   deactivate_specials
    banksel 0
    ; prepare output bus
    clrw
    movwf   PORTC
    tris    PORTC
    ; prepare memory
    movlw   ADDRESS
    andlw   0xf0
    movwf   address
    clrf    input
    clrf    output
    movlw   input
    movwf   FSR
; -------------- main program loop -------------
main:
    call    serial.in
    movf    input, w
    andlw   0xf0
    xorwf   address, w
    btfss   STATUS, Z
    goto    main
    ; received valid packet
    ; clear mutating pins
    
    call    get_mask
    movwf   mask
    iorwf   output, f
    xorwf   output, f
    
    ; write new data on cleared bits
    call    get_unmasked
    andwf   mask, w
    iorwf   output, f
    ; commit
    movf    output, w
    movwf   PORTC
    goto    main

get_unmasked:
    movf    input, w
    andlw   0x03
    addwf   PCL, f
    retlw   b'00000000'
    retlw   b'01010101'
    retlw   b'10101010'
    retlw   b'11111111'
    
get_mask:
    rrf     input, w
    movwf   _global_0
    rrf     _global_0, w
    andlw   0x03
    addwf   PCL, f
    retlw   b'00000011'
    retlw   b'00001100'
    retlw   b'00110000'
    retlw   b'11000000'
    
; ========================================
  ;  fill    (xorlw 0xff), (0x200 - $) ; keep libs out of second quarter
    
    END