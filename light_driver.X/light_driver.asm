    #include    <p16f527.inc>
    __config    0x3B4

RESET_VECTOR    code    0x3ff
    goto    0x000

START_VECTOR    code    0x000
    lgoto   start

IRUPT_VECTOR    code    0x004
    retfie

    extern  expansion.write
    extern  expansion.write.load_tris
    extern  deactivate_specials
    extern  random
    extern  delay
    extern  led.on
    extern  led.off
    extern  led.init
    extern  pow2

MAIN_DATA   udata
state   res 2
delay_c res 2
offset  res 1
temp    res 1

MAIN_VECTOR code
start:
    lcall   deactivate_specials
    banksel delay_c
    ; delay settings
    movlw   0x01
    movwf   delay_c + 1
    movlw   0x90
    movwf   delay_c + 0
    ; i/o setup
    lcall   led.init
    lcall   expansion.write.load_tris
    tris    PORTB
    ; state setup
    banksel state
    clrf    state + 0
    clrf    state + 1
    clrf    offset
main:
    movlw   state
    movwf   FSR
    lcall   expansion.write
    movlw   delay_c
    movwf   FSR
    lcall   delay
    lcall   random
    andlw   0x07
    banksel temp
    movwf   temp
    movlw   temp
    movwf   FSR
    lcall   pow2
    movwf   INDF
    movlw   state
    movwf   FSR
    banksel offset
    btfsc   offset, 0
    incf    FSR, F
    movlw   0x01
    xorwf   offset, F
    pagesel apply_activate
    banksel PORTB
    btfsc   PORTB, RB7
    goto    apply_activate
    lgoto   apply_deactivate
apply_activate:
    lcall   led.on
    banksel temp
    movfw   temp
    iorwf   INDF, F
    lgoto   main
apply_deactivate:
    lcall   led.off
    banksel temp
    movfw   temp
    xorlw   0xFF
    andwf   INDF, F
    lgoto   main

    END