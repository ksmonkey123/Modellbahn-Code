    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

; <0:3> track exits 1-4
; <4:6> entrance command code
    
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
    extern  serial.in, serial.in.init
    extern  portb.init
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
input   res 1
output  res 1
;</editor-fold>

PROGRAM_VECTOR  code
start:
    call    deactivate_specials
    call    portb.init
    call    serial.in.init
    banksel 0
    ; configure portc for output
    clrf    PORTC
    movlw   0x80
    tris    PORTC
main:
    movlw   input
    movwf   FSR
    call   serial.in
    ; ACTIVE?
    btfsc   input, 6
    goto    $+3
    clrf    output
    goto    publish
    ; TRACK_4?
    movlw   0x48
    btfsc   input, 3
    goto    store
    ; TRACK_3?
    movlw   0x34
    btfsc   input, 2
    goto    store
    ; TRACK_2?
    movlw   0x22
    btfsc   input, 1
    goto    store
    ; TRACK_1?
    movlw   0x11
    btfss   input, 0
    clrw
store:
    ; SELECT DIRECTION
    movwf   output
    movlw   0xf0 ; [7] = 1 --> inbound
    btfss   input, 7
    movlw   0x0f ; [7] = 0 --> outbound
    andwf   output, F
publish:
    ; WRITE OUTPUT TO PORTC
    movf    output, W
    movwf   output
    goto    main

    end