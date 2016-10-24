    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    #define     delay_settings_short .200
    #define     delay_settings_long  .800
    
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
    extern  serial.in
    extern  switch_control.process, switch_control.init
    extern  delay
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM udata
input              res 1
temp               res 1
cmd                res 1
delay_config_short res 2
delay_config_long  res 2
;</editor-fold>

PROGRAM_VECTOR  code
start:
    call    deactivate_specials
    call    led.init
    call    switch_control.init
    ; configure portc for switch control
    banksel 0
    movlw   0xff
    movwf   PORTC
    movlw   0xc0
    tris    PORTC
    ;configure short delay
    movlw   LOW(delay_settings_short)
    movwf   delay_config_short + 0
    movlw   HIGH(delay_settings_short)
    movwf   delay_config_short + 1
    ;configure long delay
    movlw   LOW(delay_settings_long)
    movwf   delay_config_long + 0
    movlw   HIGH(delay_settings_long)
    movwf   delay_config_long + 1
    call    led.on
    movlw   delay_config_short
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
    movwf   input
    movf    input, W
    btfsc   STATUS, Z ; check if any application is required
    goto    main
    xorlw   0xff
    movwf   PORTC
    movwf   input ; cache current output in $input
    ; short delay
    call    led.on
    movlw   delay_config_short
    movwf   FSR
    call    delay
    ; disable modern drives (no. 1 & no. 3)
    movf    input, W ; load current output from $input
    iorlw   0xf3 ; disable no. 1/3 pins
    movwf   PORTC
    ; sleep long
    movlw   delay_config_long
    movwf   FSR
    call    led.off
    ; disable
    movlw   0xff
    movwf   PORTC
    goto    main
    
PARSE_VEC   code 
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