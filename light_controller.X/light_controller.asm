; ###################################
; # Light Controller                #
; ###################################
; #  - Author:    Andreas Wälchli   #
; #  - Version:   1.1 - 2016/04/29  #
; #  - Processor: PIC16F527         #
; ###################################
; # Description                     #
; #     This controller acts as a   #
; #     T-flip-flop controlling the #
; #     global activation state of  #
; #     all lights.                 #
; #     An additional feature is    #
; #     the control of an R/G-LED   #
; #     acting as a system state    #
; #     indicator (SSI).            #
; ###################################
; # Feature Documentation           #
; #  - Light Controller             #
; #     On startup the lights       #
; #     default to [off]. On each   #
; #     falling edge of the input   #
; #     the lights are toggled.     #
; #     Each toggle is followed by  #
; #     a 0.1s cooldown timer to    #
; #     filter button bouncing      #
; #  - System State Indicator (SSI) #
; #     The Indicator defaults to   #
; #     [red] whenever the AC       #
; #     system has power but the DC #
; #     system is offline.          #
; #     When the DC system is       #
; #     powered, the SSI switches   #
; #     to the [yellow] state.      #
; #     2 seconds after entering    #
; #     the [yellow] phase a final  #
; #     transition puts the SSI     #
; #     into the [green] state.     #
; #     This indicates that all     #
; #     controllers should be in an #
; #     operational state.          #
; ###################################
; # I/O Layout                      #
; #  - B<7>   light command out (d) #
; #  - C<0>   light toggle in (dpu) #
; #  - C<1>   lights out (d)        #
; #  - C<2:3> ssi out (d) [!R, G]   #
; ###################################
    #include    <p16f527.inc>
    __config    0x3B4
    
    #define     delay_value_long    .2000
    #define     delay_value_short   .0100
    
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
    extern  delay
;</editor-fold>
    
;<editor-fold defaultstate="collapsed" desc="program memory">
PROGRAM_MEMORY  udata
delay_config    res 2
;</editor-fold>

PROGRAM_VECTOR  code
start:
    call   deactivate_specials
    call   led.init
    call   led.on
    movlw   0x7f
    tris    PORTB
    clrf    PORTB
    ; set SSI to [yellow]
    movlw   0xf1
    tris    PORTC
    movlw   0x08
    movwf   PORTC
    ; SSI DELAY (2000ms)
    movlw   delay_config
    movwf   FSR
    movlw   LOW(delay_value_long)
    movwf   delay_config + 0
    movlw   HIGH(delay_value_long)
    movwf   delay_config + 1
    call    delay
    ; set SSI to [green]
    movlw   0x0c
    movwf   PORTC
    ; SSI cleanup, configure delay routine
    call    led.off
    movlw   LOW(delay_value_short)
    movwf   delay_config + 0
    movlw   HIGH(delay_value_short)
    movwf   delay_config + 1
main:
    ; await button press
    btfsc   PORTC, 0
    goto    $-1
    call    delay
    ; turn on
    movlw   0x0e
    movwf   PORTC
    bsf     PORTB, 7
    call    led.on
    ; await button release
    btfss   PORTC, 0
    goto    $-1
    call    delay
    ; await button press
    btfsc   PORTC, 0
    goto    $-1
    call    delay
    ; turn off
    movlw   0x0c
    movwf   PORTC
    bcf     PORTB, 7
    call    led.off
    ; await button release
    btfss   PORTC, 0
    goto    $-1
    call    delay
    goto    main
    
    end