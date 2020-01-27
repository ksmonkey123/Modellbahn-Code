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
    movlw   0x80
    movwf   address
    movwf   PORTC
    movwf   OSCCAL
    movlw   0x05
    movwf   input
    movlw   0x05
    clrf    output

cal_loop:
    btfsc   PORTA, RA1
    goto    cal_loop
    goto    $+1
    btfsc   PORTA, RA1
    goto    cal_loop
    goto    $+1
    btfsc   PORTA, RA1
    goto    cal_loop
    goto    $+1
    goto    $+1
    goto    $+1
    movlw   .32
    movwf   mask
    decfsz  mask, f
    goto    $-1
    goto    $+1
    btfss   PORTA, RA1
    goto    cal_hit
    goto    cal_miss

cal_hit:
    decf    output, f
    btfsc   STATUS, Z
    goto    setup
    movlw   0x05
    movwf   input
    goto    cal_loop
    
cal_miss:
    movlw   0x05
    movwf   output
    decfsz  input, f
    goto    cal_loop
    incf    address, f
    incf    address, f
    movf    address, w
    movwf   PORTC
    movwf   OSCCAL
    movlw   0x05
    movwf   input
    goto    cal_loop
    
    ; prepare memory
setup:
    bsf	    PORTA, RA0
    goto    $
    END