    #include <p16f527.inc>
    __CONFIG 0x3B4

GLOBALS UDATA_SHR
calibration res 1
prescaler   res 1
temp	    res 1

    #define output PORTC
    #define reference PORTB, RB4
    #define led	PORTA, RA1

RAM UDATA
sample_bin res 4

START_VECTOR CODE 0x000
    goto    start

RESET_VECTOR CODE 0x3FF
    retlw   0x7F

INTERRUPT_VECTOR CODE 0x004
    retfie

MAIN_VECTOR CODE
start:
    movwf   OSCCAL
    bcf	    INTCON0, GIE
    movlb   3
    clrf    INTCON1
    clrf    ANSEL
    movlb   1
    bcf	    VRCON, VREN
    bcf	    CM1CON0, C1ON
    bcf	    CM2CON0, C2ON
    movlb   0
    movlw   0xC7
    option
    movlw   0xFD
    tris    PORTA ; portA is LED output only
    movlw   0xFF
    tris    PORTB ; portB is reference signal and control input
    movlw   0x00
    tris    PORTC ; portC is 8-bit parallel output of current osccal
    movfw   OSCCAL
    movwf   PORTC
    clrf    PORTA
    goto    main

single_sample:
    movlb   0
    btfsc   reference
    goto    $-1
    btfss   reference
    goto    $-1
    clrf    TMR0
    btfsc   reference
    goto    $-1
    btfss   reference
    goto    $-1
    movfw   TMR0
    movwf   INDF
    return

sample:
    movlw   sample_bin
    movwf   FSR
    movlw   0x04
    movwf   temp
    call    single_sample
    incf    FSR, F
    decfsz  temp, F
    goto    sample
    return

target_lookup:
    andlw   0x07
    andwf   PCL, F
    retlw   0x0F
    retlw   0x87
    retlw   0xC3
    retlw   0xE1
    retlw   0x74
    retlw   0x38
    retlw   0x9C
    retlw   0x4E

update_prescaler:
    movfw   prescaler
    andlw   0xC7
    option
    return

update_osccal:
    movfw   calibration
    andlw   0xFE
    movwf   OSCCAL
    movwf   output
    return

average_samples:
    movfw   sample_bin + 0
    addwf   sample_bin + 1, F
    rrf	    sample_bin + 1, F
    movfw   sample_bin + 2
    addwf   sample_bin + 3, F
    rrf	    sample_bin + 3, W
    addwf   sample_bin + 1, F
    rrf	    sample_bin + 1, W
    movwf   sample_bin + 0
    return

calibrate: ; calibrates on the current prescaler configuration
    call    sample
    call    average_samples
    movfw   prescaler
    call    target_lookup
    subwf   sample_bin + 0, F
    btfsc   STATUS, Z
    return
    decfsz  sample_bin + 0, W
    goto    $+2
    return
    incfsz  sample_bin + 0, W
    goto    $+2
    return
    incf    calibration, F
    incf    calibration, F
    call    update_osccal
    goto    calibrate

main:
    movlw   0x07
    movwf   prescaler
    movlw   0x7F
    movwf   calibration
    call    update_prescaler
    call    update_osccal
    call    calibrate
    decfsz  prescaler, F
    goto    $+2
    goto    $+3
    call    update_prescaler
    goto    $-5
    ; erase EEPROM
    movlb   1
    movlw   0x00
    movwf   EEADR
    bsf	    EECON, FREE
    bsf	    EECON, WREN
    bsf	    EECON, WR
    ; write OSCCAL to EEPROM
    movlw   0x04
    movwf   temp
    movlw   0x00
    movwf   EEADR
    movfw   calibration
    movwf   EEDATA
    bsf	    EECON, WREN
    bsf	    EECON, WR
    decfsz  temp, F
    goto    $-7
    ; activate status LED & enter dead-lock (job done)
    movlb   0
    bsf	    led
    goto    $+0

    END