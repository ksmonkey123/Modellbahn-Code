    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

; INPUT PIN LAYOUT: 0-3 - station tracks 1-4 ; 4,5 - yard tracks,
;                   6 - exit track ; 7 - reset button

; LED LAYOUT: first byte: station tracks 1-4 (even: red, odd: green)
            ; second byte: remaining tracks (like pins)
            ; 2-bit blocks arranged as: [GR]
            
; command syntax:   <0:3> active station tracks
            ;       <4:6> active yard tracks
            ;       <7>   1 => inbound
            ;             0 => outbound
    
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
;    extern  led.on, led.off, led.init
    extern  portb.init
    extern  count_ones
    extern  _global_0, _global_1
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input   res 2
output  res 2
command res 1
dircache res 1
temp    res 1
MATRIX_MEMORY   udata
matrix_candidate res 4
matrix  res .12
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
;    lcall   led.init
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
    banksel temp
    movlw   .16
    movwf   temp
    movlw   matrix_candidate
    movwf   FSR
    clrf    INDF
    incf    FSR, F
    decfsz  temp, F
    goto    $-3
    clrf    temp
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
    banksel temp
    movlw   .16
    movwf   temp
    movlw   matrix_candidate
    movwf   FSR
    clrf    INDF
    incf    FSR, F
    decfsz  temp, F
    goto    $-3
    lgoto   publish
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
    lgoto   process_set
dirup:
    clrf    dircache
    btfsc   input, 6
    bsf     dircache, 7
    lgoto   publish
process_set:
    banksel input
    pagesel $
    ; A - 1
    movlw   b'0010001'
    xorwf   input, W
    btfss   STATUS, Z
    goto    process_set_B1
    banksel matrix_candidate
    movlw   b'10000' ; mask
    movwf   matrix_candidate + 0
    movlw   b'00010001' ; proto-command
    movwf   matrix_candidate + 1
    movlw   b'00000011' ; exit leds
    movwf   matrix_candidate + 2
    movlw   b'000011' ; entrance leds
    movwf   matrix_candidate + 3
    lgoto   process_matrix
    ; B - 1
process_set_B1:
    movlw   b'0100001'
    xorwf   input, W
    btfss   STATUS, Z
    goto    process_set_C1
    banksel matrix_candidate
    movlw   b'11100' ; mask
    movwf   matrix_candidate + 0
    movlw   b'00100001' ; proto-command
    movwf   matrix_candidate + 1
    movlw   b'00000011' ; exit leds
    movwf   matrix_candidate + 2
    movlw   b'001100' ; entrance leds
    movwf   matrix_candidate + 3
    lgoto   process_matrix
    ; C - 1
process_set_C1:
    movlw   b'1000001'
    xorwf   input, W
    btfss   STATUS, Z
    goto    process_set_B2
    movf    dircache, W
    banksel matrix_candidate
    iorlw   b'01000001' ; proto-command mixed with directional data
    movwf   matrix_candidate + 1
    movlw   b'11111' ; mask
    movwf   matrix_candidate + 0
    movlw   b'00000010' ; outbound exit leds
    btfsc   matrix_candidate + 1, 7
    movlw   b'00000001' ; inbound exit leds
    movwf   matrix_candidate + 2
    movlw   b'010000' ; outbound entrance leds
    btfsc   matrix_candidate + 1, 7
    movlw   b'100000' ; inbound entrance leds
    movwf   matrix_candidate + 3
    lgoto   process_matrix
    ; B - 2
process_set_B2:
    movlw   b'0100010'
    xorwf   input, W
    btfss   STATUS, Z
    goto    process_set_C2
    banksel matrix_candidate
    movlw   b'01100' ; mask
    movwf   matrix_candidate + 0
    movlw   b'00100010' ; proto-command
    movwf   matrix_candidate + 1
    movlw   b'00001100' ; exit leds
    movwf   matrix_candidate + 2
    movlw   b'001100' ; entrance leds
    movwf   matrix_candidate + 3
    lgoto   process_matrix
    ; C - 2
process_set_C2:
    movlw   b'1000010'
    xorwf   input, W
    btfss   STATUS, Z
    goto    process_set_C3
    movf    dircache, W
    banksel matrix_candidate
    iorlw   b'01000010' ; proto-command mixed with directional data
    movwf   matrix_candidate + 1
    movlw   b'01111' ; mask
    movwf   matrix_candidate + 0
    movlw   b'00001000' ; outbound exit leds
    btfsc   matrix_candidate + 1, 7
    movlw   b'00000100' ; inbound exit leds
    movwf   matrix_candidate + 2
    movlw   b'010000' ; outbound entrance leds
    btfsc   matrix_candidate + 1, 7
    movlw   b'100000' ; inbound entrance leds
    movwf   matrix_candidate + 3
    lgoto   process_matrix
    ; C - 3
process_set_C3:
    movlw   b'1000100'
    xorwf   input, W
    btfss   STATUS, Z
    goto    process_set_C4
    movf    dircache, W
    banksel matrix_candidate
    iorlw   b'01000100' ; proto-command mixed with directional data
    movwf   matrix_candidate + 1
    movlw   b'00011' ; mask
    movwf   matrix_candidate + 0
    movlw   b'00100000' ; outbound exit leds
    btfsc   matrix_candidate + 1, 7
    movlw   b'00010000' ; inbound exit leds
    movwf   matrix_candidate + 2
    movlw   b'010000' ; outbound entrance leds
    btfsc   matrix_candidate + 1, 7
    movlw   b'100000' ; inbound entrance leds
    movwf   matrix_candidate + 3
    lgoto   process_matrix
    ; C - 4
process_set_C4:
    pagesel publish
    movlw   b'1001000'
    xorwf   input, W
    btfss   STATUS, Z
    goto    publish
    movf    dircache, W
    banksel matrix_candidate
    iorlw   b'01001000' ; proto-command mixed with directional data
    movwf   matrix_candidate + 1
    movlw   b'000001' ; mask
    movwf   matrix_candidate + 0
    movlw   b'10000000' ; outbound exit leds
    btfsc   matrix_candidate + 1, 7
    movlw   b'01000000' ; inbound exit leds
    movwf   matrix_candidate + 2
    movlw   b'010000' ; outbound entrance leds
    btfsc   matrix_candidate + 1, 7
    movlw   b'100000' ; inbound entrance leds
    movwf   matrix_candidate + 3
    lgoto   process_matrix

process_matrix:
    lcall   apply_matrix_change
    banksel matrix
    movf    matrix + 0x1, W
    iorwf   matrix + 0x5, W
    iorwf   matrix + 0x9, W
    movwf   matrix_candidate + 1
    movf    matrix + 0x2, W
    iorwf   matrix + 0x6, W
    iorwf   matrix + 0xa, W
    movwf   matrix_candidate + 2
    movf    matrix + 0x3, W
    iorwf   matrix + 0x7, W
    iorwf   matrix + 0xb, W
    movwf   matrix_candidate + 3
    movlw   matrix_candidate + 1
    movwf   FSR
    banksel command
    movf    INDF, W
    movwf   command
    incf    FSR, F
    movf    INDF, W
    movwf   output + 0
    incf    FSR, F
    movf    INDF, W
    movwf   output + 1
    lgoto   publish
    
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
    
MATRIX_PROCESSOR    code    0x200
apply_matrix_change:
    banksel matrix
    movlw   3
    movwf   _global_0
    movlw   matrix
    movwf   FSR
    ; remove all colliders
apply_matrix_change_colliders:
    movf    INDF, W
    andwf   matrix_candidate + 0, W
    btfsc   STATUS, Z
    goto    $+8
    movlw   4
    movwf   _global_1
    clrf    INDF
    incf    FSR, F
    decfsz  _global_1, F
    goto    $-3
    goto    $+3
    movlw   4
    addwf   FSR, F
    decfsz  _global_0, F
    goto    apply_matrix_change_colliders
    ; insert candidate into first empty row
    movlw   3
    movwf   _global_0
    movlw   matrix
    movwf   FSR
    ; find row to insert into
apply_matrix_change_findrow:
    movf    INDF, F
    btfsc   STATUS, Z
    goto    apply_matrix_change_insert ; found it
    movlw   4
    addwf   FSR, F
    decfsz  _global_0, F
    goto    apply_matrix_change_findrow
    lgoto   publish ; ERROR => ignore input
apply_matrix_change_insert:
    ; FSR is now at head of first empty row
    movf    matrix_candidate + 0, W
    movwf   INDF
    incf    FSR, F
    movf    matrix_candidate + 1, W
    movwf   INDF
    incf    FSR, F
    movf    matrix_candidate + 2, W
    movwf   INDF
    incf    FSR, F
    movf    matrix_candidate + 3, W
    movwf   INDF
    return

    END