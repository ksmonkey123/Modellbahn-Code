    #include    <p16f527.inc>
    __config    0x3bc
    radix       HEX
    
    ; #######################################
    ; # LEFT EXIT SIGNAL DECODER            #
    ; #######################################
    ; # Notes                               #
    ; #  - watchdog timer is enabled        #
    ; #  - watchdog ratio is 1:64 (1s)      #
    ; #######################################
    ; # I/O configuration                   #
    ; #  - C<0:3> track exits 1-4           #
    ; #  - C<4:6> entrance command code     #
    ; #######################################
    
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
    extern  serial.in
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
input   res 1
output  res 1
;</editor-fold>

PROGRAM_VECTOR  code
start:
    call    deactivate_specials
    ; configure watchdog timer
    movlw   b'11111110' ; wdt ratio 1:64 ≈ 1s
    option
    clrwdt
    ; configure i/o ports
    clrf    PORTC
    movlw   0x80
    tris    PORTC
main:
    movlw   input
    movwf   FSR
    call    serial.in
    clrwdt
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
    btfsc   input, 7 ; [7] = 1 --> inbound
    andlw   0xf0
    btfss   input, 7 ; [7] = 0 --> outbound
    andlw   0x0f
    movwf   output
publish:
    ; WRITE OUTPUT TO PORTC
    movf    output, W
    movwf   PORTC
    goto    main

    end