    IFNDEF  AUTOCAL.ALREADY_INCLUDED
    #define AUTOCAL.ALREADY_INCLUDED
    IFDEF   DEBUG
    messg   "included autocal.asm"
    ENDIF
; #############################################################################
    #include "../libs/globals"

    #define autocal.cal  _global_0
    #define autocal.scal _global_1
    #define autocal.temp _global_2

    #define autocal.out PORTC
    #define autocal.ref PORTB, RB4
    #define autocal.led	PORTA, RA1

AUTOCAL_RAM UDATA
autocal.samples res 4

AUTOCAL_VECTOR  CODE    0x200
autocal.load:
    pagesel autocal.calibrate
    movlb   1
    movlw   0x00
    movwf   EEADR
    bsf	    EECON, RD
    movfw   EEDATA
    movlb   0
    movwf   OSCCAL
    return

autocal.calibrate:
    pagesel autocal.calibrate
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
    goto    autocal.main

autocal.single_sample:
    movlb   0
    btfsc   autocal.ref
    goto    $-1
    btfss   autocal.ref
    goto    $-1
    clrf    TMR0
    btfsc   autocal.ref
    goto    $-1
    btfss   autocal.ref
    goto    $-1
    movfw   TMR0
    movwf   INDF
    return

autocal.sample:
    movlw   autocal.samples
    movwf   FSR
    movlw   0x04
    movwf   autocal.temp
    call    autocal.single_sample
    incf    FSR, F
    decfsz  autocal.temp, F
    goto    $-7
    return

autocal.target_lookup:
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

autocal.update_prescaler:
    movfw   autocal.scal
    andlw   0xC7
    option
    return

autocal.update_osccal:
    movfw   autocal.cal
    andlw   0xFE
    movwf   OSCCAL
    movwf   autocal.out
    return

autocal.average_samples:
    movfw   autocal.samples + 0
    addwf   autocal.samples + 1, F
    rrf	    autocal.samples + 1, F
    movfw   autocal.samples + 2
    addwf   autocal.samples + 3, F
    rrf	    autocal.samples + 3, W
    addwf   autocal.samples + 1, F
    rrf	    autocal.samples + 1, W
    movwf   autocal.samples + 0
    return

autocal.calibrate: ; calibrates on the current prescaler configuration
    call    autocal.sample
    call    autocal.average_samples
    movfw   autocal.scal
    call    autocal.target_lookup
    subwf   autocal.samples + 0, F
    btfsc   STATUS, Z
    return
    decfsz  autocal.samples + 0, W
    goto    $+2
    return
    incfsz  autocal.samples + 0, W
    goto    $+2
    return
    incf    autocal.cal, F
    incf    autocal.cal, F
    call    autocal.update_osccal
    goto    autocal.calibrate

autocal.main:
    movlw   0x07
    movwf   autocal.scal
    movlw   0x7F
    movwf   autocal.cal
    call    autocal.update_prescaler
    call    autocal.update_osccal
    call    autocal.calibrate
    decfsz  autocal.scal, F
    goto    $+2
    goto    $+3
    call    autocal.update_prescaler
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
    movwf   autocal.temp
    movlw   0x00
    movwf   EEADR
    movfw   autocal.cal
    movwf   EEDATA
    bsf	    EECON, WREN
    bsf	    EECON, WR
    decfsz  autocal.temp, F
    goto    $-7
    ; activate status LED & enter dead-lock (job done)
    movlb   0
    bsf	    autocal.led
    goto    $+0

; #############################################################################
    ELSE
    IFDEF   DEBUG
    messg   "already included!"
    ENDIF
    ENDIF