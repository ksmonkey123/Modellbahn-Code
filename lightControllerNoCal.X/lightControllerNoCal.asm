    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

; ###########################################
; # SINGLE CHANNEL LIGHT DECODER            #
; ###########################################
; # Light decoder providing 8 individually  #
; # controllable digital output pins. The   #
; # 4-bit device addresses allow the use    #
; # of up to 16 distinct decoders with up   #
; # to 128 individually controlled pins.    #
; # If two or more decoders have all of     #
; # their pins 'coupled' (i.e. always       #
; # controlled identically) they can use    #
; # the same device address. The output is  #
; # is provided on the C<0:7> pins as raw   #
; # digital output. Therefore driver chips  #
; # are required for safe controlling of    #
; # any significant components.             #
; ###########################################
    
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
    extern  serial.in_ra1
    extern  deactivate_specials
    extern  _global_0
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input       res 1
output      res 1
mask        res 1
address     res 1
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
    movlw   0xfe
    tris    PORTA
    bcf	    PORTA, RA0
; ------------ auto calibration loop -----------
    movlw   b'00001010'
    movwf   OSCCAL
    movlw   0x05
    movwf   input
    movlw   0x05
    clrf    output
    
    ; prepare memory
setup:
    clrf    input
    clrf    output
    movlw   input
    movwf   FSR
    bsf	    PORTA, RA0
; -------------- main program loop -------------
main:
    ; load chip address
    call    read_address
    movwf   address
    
    ; read next command
    call    serial.in_ra1
    movf    input, w 
    
    andlw   0xf0
    xorwf   address, w ; packet.address = this.address
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
    ; update LED
    btfsc   STATUS, Z
    bsf	    PORTA, RA0
    btfss   STATUS, Z
    bcf	    PORTA, RA0
    goto    main

; expand 2-bit data payload onto the full 8-bit range by repeating it
get_unmasked:
    movf    input, w
    andlw   0x03
    addwf   PCL, f
    retlw   b'00000000'
    retlw   b'01010101'
    retlw   b'10101010'
    retlw   b'11111111'

; get 8-bit mask on the 2 pins addressed by the 2-bit local address
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

; read the 4-bit device address from the address dial connected to PORTB
read_address:
    clrw
    btfss   PORTB, RB7
    iorlw   0x10
    btfss   PORTB, RB6
    iorlw   0x20
    btfss   PORTB, RB5
    iorlw   0x40
    btfss   PORTB, RB4
    iorlw   0x80
    return
    
    END