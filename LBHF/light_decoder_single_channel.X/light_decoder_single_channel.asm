    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    
; ================ CHIP ADDRESS ================
    #DEFINE     ADDRESS     0x0
    
; ##########################################
; # SINGLE CHANNEL LIGHT DECODER           #
; ##########################################
; # Light decoder providing 8 individually #
; # controllable digital output pins. The  #
; # 4-bit device addresses allow the use   #
; # of up to 16 distinct decoders with up  #
; # to 128 individually controlled pins.   #
; # If two or more decoders have all of    #
; # their pins 'coupled' (i.e. always      #
; # controlled identically) they can use   #
; # the same device address. The output is #
; # is provided on the C<0:7> pins as raw  #
; # digital output. Therefore driver chips #
; # are required for safe controlling of   #
; # any significant components.            #
; #                                        #
; # The 4-bit commands contain a 2-bit     #
; # pin-pair selection followed by a 2-bit #
; # data section. The 2 selection bits     #
; # determine the pin pair to be updated   #
; # while the data section contains the    #
; # new data for these 2 pins.             #
; #                                        #
; # Single and dual channel decoders can   #
; # be used together. Dual channel decoders#
; # simply take up 2 addresses. Therefore  #
; # when assigning an address to a new     #
; # single channel decoder one must ensure #
; # That the first 3 bits of the address   #
; # do not correspond to any dual channel  #
; # address currently in use. It is        #
; # recommended to separate dual and       #
; # single channel decoders into distinct  #
; # address blocks to avoid collisions.    #
; ##########################################
    
; DATA FORMAT: AAAA.PP.DD
;  - A: 4-bit address
;  - P: 2-bit pin-pair selector. a value d identifies pins 2d and 2d+1
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
    extern  deactivate_specials
    extern  _global_0
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input       res 1
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
    clrf    input
    clrf    output
    movlw   input
    movwf   FSR
; -------------- main program loop -------------
main:
    call    serial.in
    movf    input, w
    andlw   0xf0
    xorlw   ((ADDRESS * .16) & 0xf0)
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