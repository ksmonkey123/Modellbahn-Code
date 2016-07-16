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
    btfsc   temp, 2
    bsf     cmd, 4
    btfsc   temp, 3
    bsf     cmd, 5
    btfss   temp, 0
    goto    $+3
    bsf     cmd, 2
    goto    parse_
    btfss   temp, 1
    goto    $+3
    bsf     cmd, 3
    goto    parse_
    movf    cmd, W
    return
parse_:
    movf    cmd, W
    btfss   temp, 4
    iorlw   0x02
    btfsc   temp, 4
    iorlw   0x01
    return
    
    end