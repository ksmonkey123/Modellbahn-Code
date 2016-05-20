    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

; INPUT PIN LAYOUT: 0-3 - station tracks 1-4 ; 4,5 - yard tracks,
;                   6 - exit track ; 7 - reset button

; LED LAYOUT: first byte: station tracks 1-4 (even: red, odd: green)
            ; second byte: remaining tracks (like pins)
    
;<editor-fold defaultstate="collapsed" desc="base vectors">
RESET_VECTOR    code    0x3ff
    goto    0x000
    
START_VECTOR    code    0x000
    lgoto   start

IRUPT_VECTOR    code    0x004
    retfie
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="library imports">
    extern  expansion.in, expansion.in.init
    extern  expansion.out, expansion.out.init
    extern  serial.out, serial.out.init
    extern  deactivate_specials
    extern  led.on, led.off, led.init
    extern  portb.init
    extern  count_ones
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input   res 2
output  res 2
command res 1
dircache res 1
temp    res 1
;</editor-fold>

PROGRAM_VECTOR  code    0x100
; =========== START OF MAIN PROGRAM ============
; -------- processor setup and i/o init --------
start:
    lcall   deactivate_specials
    lcall   portb.init
    lcall   serial.out.init
    lcall   expansion.out.init
    lcall   expansion.in.init
    lcall   led.init
    banksel input
    clrf    input + 0
    clrf    input + 1
    clrf    output + 0
    clrf    output + 1
    clrf    command
    clrf    dircache
    movlw   output
    movwf   FSR
    lcall   expansion.out
; -------------- main program loop -------------
main:
    ; READ INPUT
    movlw   input
    movwf   FSR
    lcall   expansion.in
    ; PROCESS INPUT
    pagesel main
    banksel input
    movf    input, F
    ; no input?
    btfsc   STATUS, Z
    goto    publish
    ; reset?
    btfss   input, 7
    goto    main_0
    clrf    command
    clrf    output + 0
    clrf    output + 1
    goto    publish
main_0:
    movlw   input
    movwf   FSR
    lcall   count_ones
    banksel temp
    movwf   temp
    pagesel dirup
    xorlw   0x01
    btfsc   STATUS, Z
    goto    dirup
    movfw   temp
    pagesel publish
    xorlw   0x02
    btfss   STATUS, Z
    goto    publish
    lgoto   process_1C
dirup:
    clrf    dircache
    btfsc   input, 6
    bsf     dircache, 7
    lgoto   publish
process_1C:
    movfw   input
    xorlw   b'01000001'
    btfss   STATUS, Z
    goto    process_1B
    ; apply 1-C
    movfw   dircache
    iorlw   b'01000001'
    movwf   command
    btfsc   dircache, 7
    goto    process_1C_
    movlw   b'00000001'
    movwf   output
    movlw   b'00100000'
    movwf   output + 1
    goto   publish
process_1C_:
    movlw   b'00000010'
    movwf   output
    movlw   b'00010000'
    movwf   output + 1
    goto   publish
process_1B:
    movfw   input
    xorlw   b'00100001'
    btfss   STATUS, Z
    goto    process_1A
    ;apply 1-B
    movfw   command
    andlw   b'00001100'
    btfsc   STATUS, Z
    goto    $+4
    clrf    command
    clrf    output + 0
    clrf    output + 1
    movfw   command
    andlw   b'11001100'
    iorlw   b'00100001'
    movwf   command
    movfw   output
    andlw   b'11110000'
    iorlw   b'00000011'
    movwf   output
    movfw   output + 1
    andlw   b'00110000'
    iorlw   b'00001100'
    movwf   output + 1
    goto    publish
process_1A:
    movfw   input
    xorlw   b'00010001'
    btfss   STATUS, Z
    goto    process_2C
    ; apply 1-A
    movfw   command
    andlw   b'00110011'
    xorlw   b'00100001'
    btfss   STATUS, Z
    goto    process_1A_
    ; change from 1-B
    movfw   command
    andlw   b'11011101'
    iorlw   b'00010001'
    movfw   command
    goto    publish
process_1A_:
    movfw   command
    andlw   b'01111111'
    xorlw   b'01000001'
    btfss   STATUS, Z
    goto    process_1A__
    ; change from 1-A
    movlw   b'00010001'
    movwf   command
    movlw   b'00000011'
    movwf   output
    movwf   output + 1
    goto    publish
process_1A__:
    ; change from any other state
    movlw   b'00010001'
    iorwf   command, F
    movlw   b'00000011'
    iorwf   output + 0, F
    iorwf   output + 1, F
    goto    publish
process_2C:
    movfw   input
    xorlw   b'01000010'
    btfss   STATUS, Z
    goto    process_2B
    ; apply 2-C
    movfw   command
    andlw   b'00010001'
    xorlw   b'00000001'
    btfss   STATUS, Z
    goto    $+4
    clrf    command
    clrf    output
    clrf    output + 1
    movfw   command
    andlw   b'01010011'
    iorwf   dircache, W
    movwf   command
    movlw   b'00000011'
    andwf   output + 0, F
    andwf   output + 1, F
    btfsc   dircache, 7
    goto    process_2C_
    movlw   b'00000100'
    iorwf   output + 0, F
    movlw   b'00100000'
    iorwf   output + 1, F
    goto    publish
process_2C_:
    movlw   b'00001000'
    iorwf   output + 0, F
    movlw   b'00010000'
    iorwf   output + 1, F
    goto    publish
process_2B:
    nop

publish:
    ; PUBLISH DATA TO LEDS AND NETWORK
    movlw   output
    movwf   FSR
    lcall   expansion.out
    movlw   command
    movwf   FSR
    lcall   serial.out
    ; REPEAT
    lgoto   main
    
; ========================================
    fill    (xorlw 0xff), (0x200 - $) ; keep libs out of second quarter
    
    END