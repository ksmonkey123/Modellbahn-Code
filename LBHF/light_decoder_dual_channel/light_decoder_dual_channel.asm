    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    
; ================ CHIP ADDRESS ================
    #DEFINE     ADDRESS     0x0
       
; ##########################################
; # DUAL CHANNEL LIGHT DECODER             #
; ##########################################
; # Light decoder providing 16 separately  #
; # controllable digital output pins. The  #
; # 3-bit device addresses allow the use   #
; # of up to 8 distinct decoders with up   #
; # to 128 individually controlled pins.   #
; # To make interoperation with single     #
; # channel decoders easier, the address   #
; # has to be specified as a 4-bit address #
; # with a constant 0 as the last bit.     #
; # If two or more decoders have all of    #
; # their pins 'coupled' (i.e. always      #
; # controlled identically) they can use   #
; # the same device address. The output is #
; # is provided through an expansion board #
; # as raw digital output. Therefore       #
; # driver chips are required for safe     #
; # controlling of any significant         #
; # components.                            #
; #                                        #
; # The 5-bit commands contain a 3-bit     #
; # pin-pair selection followed by a 2-bit #
; # data section. The 3 selection bits     #
; # determine the pin pair to be updated   #
; # while the data section contains the    #
; # new data for these 2 pins.             #
; #                                        #
; # Single and dual channel decoders can   #
; # be used together. Dual channel decoders#
; # simply take up 2 addresses. Therefore  #
; # when assigning an address to a new     #
; # dual channel decoder one must ensure   #
; # that the address does not correspond   #
; # to the 3 leading bits of any single    #
; # channel address currently in use. It   #
; # is recommended to separate dual and    #
; # single channel decoders into distinct  #
; # address blocks to avoid collisions.    #
; ##########################################
    
; DATA FORMAT: AAA.PPP.DD
;  - A: 3-bit address
;  - P: 3-bit pin-pair selector. a value d identifies pins 2d and 2d+1
;  - D: 2-bit pin-pair data. Sets the states for the 2 selected pins
    
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
    extern  expansion.out
    extern  deactivate_specials
    extern  _global_0
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input       res 1
output      res 2
mask        res 1
;</editor-fold>

PROGRAM_VECTOR  code    ;0x100
; =========== START OF MAIN PROGRAM ============
; -------- processor setup and i/o init --------
start:
    call   deactivate_specials
    banksel 0
    ; prepare output bus
    clrf    PORTB
    movlw   0x8f
    tris    PORTB
    ; prepare memory
    clrf    input
    clrf    output + 0
    clrf    output + 1
    
; -------------- main program loop -------------
main:
    ; commit
    movlw   output + 0
    movwf   FSR
    call    expansion.out
    ; read
read:
    movlw   input
    movwf   FSR
    call    serial.in
    movf    input, w
    andlw   0xe0
    xorlw   ((ADDRESS * .16) & 0xe0)
    btfss   STATUS, Z
    goto    read
    ; received valid packet
    ; select correct channel
    movlw   output + 0
    btfss   input, 4
    movlw   output + 1
    movwf   FSR
    
    ; clear mutating pins
    call    get_mask
    movwf   mask
    iorwf   INDF, f ; set mutating pins
    xorwf   INDF, f ; invert mutating pins (turns them off)
    
    ; write new data on cleared bits
    call    get_unmasked
    andwf   mask, w
    iorwf   INDF, f
    
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