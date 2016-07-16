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
temp            res 1
;</editor-fold>

SUBROUTINE_VEC  code    0x010
parse:
    ; parses the command
    banksel input
    movlw   0x00
    btfsc   input, 5 ; B in use?
    movlw   b'000010'
    btfsc   input, 1 ; track 2 in use?
    iorlw   b'000100'
    btfss   input, 0 ; track 4 in use?
    goto    $+6
    btfss   input, 4 ; A in use?
    goto    $+3
    iorlw   b'100000'; A in use
    goto    $+2
    iorlw   b'011000'; A not in use
    btfss   input, 6 ; global exit used?
    return
    btfsc   input, 2
    return
    btfsc   input, 3
    return
    iorlw   b'000001'
    return

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
    movlw   0xc0
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