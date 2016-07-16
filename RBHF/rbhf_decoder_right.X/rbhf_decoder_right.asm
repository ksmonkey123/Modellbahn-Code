    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    #define     delay_settings  .2000
    
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
cmd             res 1
;</editor-fold>

PROGRAM_VECTOR  code    0x100
start:
    pagesel $
    call    deactivate_specials
    call    portb.init
    call    serial.in.init
    call    led.init
    call    switch_control.init
    ; configure portc for switch control
    banksel 0
    movlw   0xff
    movwf   PORTC
    movlw   0xc0
    tris    PORTC
    banksel delay_config
    ;configure delay subroutine
    movlw   LOW(delay_settings)
    movwf   delay_config + 0
    movlw   HIGH(delay_settings)
    movwf   delay_config + 1
    call    led.on
    movlw   delay_config
    movwf   FSR
    call    delay
    call    led.off

main:
    movlw   input
    movwf   FSR
    call    serial.in
    movf    INDF, W
    call    parse
    call    switch_control.process
    movwf   INDF
    movf    INDF, W
    btfsc   STATUS, Z
    goto    main
    xorlw   0xff
    banksel PORTC
    movwf   PORTC
    call    led.on
    movlw   delay_config
    movwf   FSR
    call    delay
    call    led.off
    banksel PORTC
    movlw   0xff
    movwf   PORTC
    goto    main
    
    fill (xorlw 0xff), (0x200 - $)
    
PARSE_VEC   code    0x010
parse:
    banksel temp
    movwf   temp
    clrf    cmd
    btfsc   temp, 5
    bsf     cmd, 2
    movf    temp, W
    andlw   0x0c
    btfsc   STATUS, Z
    goto    parse_
    bsf     cmd, 4
    btfss   temp, 4
    goto    parse_
    btfsc   temp, 5
    goto    parse_
    movlw   0x0a
    iorwf   cmd, F
parse_:
    movf    temp, W
    andlw   0x03
    btfss   STATUS, Z
    goto    $+3
    movf    cmd, W
    return
    btfss   temp, 4
    goto    parse__
    movf    cmd, W
    iorlw   0x01
    return
parse__:
    btfsc   temp, 5
    bsf     cmd, 5
    movf    cmd, W
    return
    
    end