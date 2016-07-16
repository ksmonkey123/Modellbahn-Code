    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    #define delay_settings .2000

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
    extern  led.init, led.on, led.off
    extern  serial.in, serial.in.init
    extern  switch_control.process, switch_control.init
    extern  portb.init
    extern  delay
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
input           res 1
delay_config    res 2
;</editor-fold>

SUBROUTINE_VEC  code    0x010
parse:
    ; parses the command
    banksel input
    btfss   input, 6 ; nothing?
    retlw   b'0000'
    btfsc   input, 3 ; track 4?
    retlw   b'0001'
    btfsc   input, 2 ; track 3?
    retlw   b'0110'
    retlw   b'1010'  ; default

PROGRAM_VECTOR  code    0x100
start:
    lcall   deactivate_specials
    lcall   portb.init
    lcall   serial.in.init
    lcall   led.init
    lcall   switch_control.init
    ; configure portc for switch control
    banksel 0
    movlw   0xff
    movwf   PORTC
    movlw   0xf0
    tris    PORTC
    banksel delay_config
    ; configure delay subroutine
    movlw   LOW(delay_settings)
    movwf   delay_config + 0
    movlw   HIGH(delay_settings)
    movwf   delay_config + 1
    lcall   led.on
    movlw   delay_config
    movwf   FSR
    lcall   delay
    lcall   led.off
main:
    movlw   input
    movwf   FSR
    lcall   serial.in
    movf    INDF, W
    lcall   parse
    lcall   switch_control.process
    movwf   INDF
    pagesel main
    movf    INDF, W
    btfsc   STATUS, Z   ; change if any application is required
    goto    main
    xorlw   0xff
    banksel PORTC
    movwf   PORTC
    lcall   led.on
    movlw   delay_config
    movwf   FSR
    lcall   delay
    lcall   led.off
    banksel PORTC
    movlw   0xff
    movwf   PORTC
    lgoto   main
    
; ============================================================================
    
    fill    (xorlw 0xff), (0x200 - $)

    end