    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    #define     delay_settings  .2000
    
    
    ; code for both center decoders. The pcb determines the used channel.
    ;   -> for channel 0 pull RB4 low
    ;   -> for channel 1 pull RB4 high
    
    
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
ch_select       res 1
delay_config    res 2
;</editor-fold>

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
    ; determine channel to use
    banksel 0
    movlw   0x00
    btfsc   PORTB, RB4
    iorlw   0x01
    banksel ch_select
    movwf   ch_select
    ; finish setup
    lcall   led.on
    movlw   delay_config
    movwf   FSR
    lcall   delay
    lcall   led.off
    lgoto   main
main:
    ; read input and extract channel
    movlw   input
    movwf   FSR
    lcall   serial.in
    movfw   INDF
    banksel ch_select
    btfsc   ch_select, 0
    swapf   INDF, f
    movlw   0x0f
    andwf   INDF, f
    ; validate channel
;    rrf     INDF, w
;    andwf   INDF, w
;    andlw   0x05
;    pagesel main
;    btfsc   STATUS, Z
;    goto    main        ; channel was invalid (a switch was overdriven)
    ; process output
    movfw   INDF
    lcall   switch_control.process
    movwf   INDF
    pagesel main
    movfw   INDF
    btfsc   STATUS, Z
    goto    main        ; channel was unaltered
    ; apply output
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
    fill    (xorlw 0xff), (0x200 - $)
    
    end