; #######################################
; # RBHF CONTROLLER (MATRIX PROCESSING) #
; #######################################
; # Designed for PIC16F527              #
    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
; #######################################
; # INPUT PIN LAYOUT                    #
; #   - <0:3> station tracks            #
; #   - <4:5> exit tracks               #
; #   - <6:7> reset buttons             #
; # LED OUTPUT LAYOUT                   #
; #   - <0:7> station tracks            #
; #   - <8:B> exit tracks               #
; #   colors are arranged in [GR]       #
; #   blocks. (even: red, odd: green)   #
; # COMMAND LAYOUT                      #
; #   - <0:3> active station tracks     #
; #   - <4:5> active exit tracks        #
; #   - <6:7> direction flags           #
; #         0 => outbound               #
; #         1 => inbound                #
; #######################################

;<editor-fold defaultstate="collapsed" desc="BASE VECTORS">
RESET_VECTOR    code    0x3ff
    goto    0x000
    
START_VECTOR    code    0x000
    lgoto   start
    
IRUPT_VECTOR    code    0x004
    retfie
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="LIBRARY IMPORTS">
    extern  expansion.in, expansion.in.init
    extern  expansion.out, expansion.out.init
    extern  serial.out, serial.out.init
    extern  deactivate_specials
    extern  portb.init
    extern  count_ones
    extern  _global_0, _global_1
;</editor-fold>
;<editor-fold defaultstate="collapsed" desc="RAM ALLOCATION">
PROGRAM_MEMORY  udata
input    res 2
output   res 2
command  res 1
dircache res 1
temp     res 1
MATRIX_MEMORY   udata
matrix_candidate res   4
matrix           res .12
;</editor-fold>

PROGRAM_VECTOR  code    0x100
; ============= START OF MAIN PROGRAM =============
; ----------- processor setup & i/o init ----------
start:
    lcall   deactivate_specials
    lcall   portb.init
    lcall   serial.out.init
    lcall   expansion.out.init
    lcall   expansion.in.init
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
    pagesel start
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
    lgoto   main
    
update_body:
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
    
; ------------- main program loop -------------
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
    ; any kind or reset?
    ;   -> reset is handled through jump block. skip directional update
    movlw   b'11000000'
    andwf   input, W
    btfss   STATUS, Z
    goto    jump_block
    ; directional update?
    movlw   input
    movwf   FSR
    lcall   count_ones
    banksel temp
    movwf   temp
    pagesel directional_update
    xorlw   0x01
    btfsc   STATUS, Z
    goto    directional_update
    ; jump block
jump_block:
    ; copy all into global RAM
    movf    input, W
    movwf   _global_0
    movf    dircache, W
    movwf   _global_1
    banksel matrix
    pagesel process_0x11
    ; normal commands
    movlw   0x11
    xorwf   _global_0, W
    btfsc   STATUS, Z
    goto    process_0x11
    movlw   0x12
    xorwf   _global_0, W
    btfsc   STATUS, Z
    goto    process_0x12
    movlw   0x14
    xorwf   _global_0, W
    btfsc   STATUS, Z
    goto    process_0x14
    movlw   0x18
    xorwf   _global_0, W
    btfsc   STATUS, Z
    goto    process_0x18
    movlw   0x21
    xorwf   _global_0, W
    btfsc   STATUS, Z
    goto    process_0x21
    movlw   0x22
    xorwf   _global_0, W
    btfsc   STATUS, Z
    goto    process_0x22
    movlw   0x24
    xorwf   _global_0, W
    btfsc   STATUS, Z
    goto    process_0x24
    movlw   0x28
    xorwf   _global_0, W
    btfsc   STATUS, Z
    goto    process_0x28
    ; reset buttons
    movf    _global_0, W
    andlw   0xc0
    xorlw   0x40
    btfsc   STATUS, Z
    goto    process_0x7f
    movf    _global_0, W
    andlw   0xc0
    xorlw   0x80
    btfsc   STATUS, Z
    goto    process_0xbf
    movf    _global_0, W
    andlw   0xc0
    xorlw   0xc0
    btfsc   STATUS, Z
    goto    process_0xff
    lgoto    publish
    

; directional update
directional_update:
    clrf    dircache
    movlw   b'00110000'
    andwf   input, W
    btfss   STATUS, Z
    bsf     dircache, 0
    goto    publish
    
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
apply_matrix_change_colliders
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
apply_matrix_change_findrow
    movf    INDF, F
    btfsc   STATUS, Z
    goto    apply_matrix_change_insert ; found it
    movlw   4
    addwf   FSR, F
    decfsz  _global_0, F
    goto    apply_matrix_change_findrow
    lgoto   publish ; ERROR => ignore input
apply_matrix_change_insert
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
    
        ; update subroutines
process_0x11:
    movlw   b'011001'
    movwf   matrix_candidate + 0
    movlw   b'00010001'
    btfsc   _global_1, 0
    movlw   b'01010001'
    movwf   matrix_candidate + 1
    movlw   b'00000010'
    btfsc   _global_1, 0
    movlw   b'00000001'
    movwf   matrix_candidate + 2
    movlw   b'0001'
    btfsc   _global_1, 0
    movlw   b'0010'
    movwf   matrix_candidate + 3
    goto    update
process_0x12:
    movlw   b'011001'
    movwf   matrix_candidate + 0
    movlw   b'00010010'
    btfsc   _global_1, 0
    movlw   b'01010010'
    movwf   matrix_candidate + 1
    movlw   b'00001000'
    btfsc   _global_1, 0
    movlw   b'00000100'
    movwf   matrix_candidate + 2
    movlw   b'0001'
    btfsc   _global_1, 0
    movlw   b'0010'
    movwf   matrix_candidate + 3
    goto    update
process_0x14:
    movlw   b'100111'
    movwf   matrix_candidate + 0
    movlw   b'00010100'
    btfsc   _global_1, 0
    movlw   b'01010100'
    movwf   matrix_candidate + 1
    movlw   b'00100000'
    btfsc   _global_1, 0
    movlw   b'00010000'
    movwf   matrix_candidate + 2
    movlw   b'0001'
    btfsc   _global_1, 0
    movlw   b'0010'
    movwf   matrix_candidate + 3
    goto    update
process_0x18:
    movlw   b'100111'
    movwf   matrix_candidate + 0
    movlw   b'00011000'
    btfsc   _global_1, 0
    movlw   b'01011000'
    movwf   matrix_candidate + 1
    movlw   b'10000000'
    btfsc   _global_1, 0
    movlw   b'01000000'
    movwf   matrix_candidate + 2
    movlw   b'0001'
    btfsc   _global_1, 0
    movlw   b'0010'
    movwf   matrix_candidate + 3
    goto    update
process_0x21:
    movlw   b'011110'
    movwf   matrix_candidate + 0
    movlw   b'00100001'
    btfsc   _global_1, 0
    movlw   b'10100001'
    movwf   matrix_candidate + 1
    movlw   b'00000010'
    btfsc   _global_1, 0
    movlw   b'00000001'
    movwf   matrix_candidate + 2
    movlw   b'0100'
    btfsc   _global_1, 0
    movlw   b'1000'
    movwf   matrix_candidate + 3
    goto    update
process_0x22:
    movlw   b'011110'
    movwf   matrix_candidate + 0
    movlw   b'00100010'
    btfsc   _global_1, 0
    movlw   b'10100010'
    movwf   matrix_candidate + 1
    movlw   b'00001000'
    btfsc   _global_1, 0
    movlw   b'00000100'
    movwf   matrix_candidate + 2
    movlw   b'0100'
    btfsc   _global_1, 0
    movlw   b'1000'
    movwf   matrix_candidate + 3
    goto    update
process_0x24:
    movlw   b'100110'
    movwf   matrix_candidate + 0
    movlw   b'00100100'
    btfsc   _global_1, 0
    movlw   b'10100100'
    movwf   matrix_candidate + 1
    movlw   b'00100000'
    btfsc   _global_1, 0
    movlw   b'00010000'
    movwf   matrix_candidate + 2
    movlw   b'0100'
    btfsc   _global_1, 0
    movlw   b'1000'
    movwf   matrix_candidate + 3
    goto    update
process_0x28:
    movlw   b'100110'
    movwf   matrix_candidate + 0
    movlw   b'00101000'
    btfsc   _global_1, 0
    movlw   b'10101000'
    movwf   matrix_candidate + 1
    movlw   b'10000000'
    btfsc   _global_1, 0
    movlw   b'01000000'
    movwf   matrix_candidate + 2
    movlw   b'0100'
    btfsc   _global_1, 0
    movlw   b'1000'
    movwf   matrix_candidate + 3
    goto    update
process_0x7f:
    movlw   b'011001'
    movwf   matrix_candidate + 0
    clrf    matrix_candidate + 1
    clrf    matrix_candidate + 2
    clrf    matrix_candidate + 3
    goto    update
process_0xbf:
    movlw   b'100110'
    movwf   matrix_candidate + 0
    clrf    matrix_candidate + 1
    clrf    matrix_candidate + 2
    clrf    matrix_candidate + 3
    goto    update
process_0xff:
    movlw   b'111111'
    movwf   matrix_candidate + 0
    clrf    matrix_candidate + 1
    clrf    matrix_candidate + 2
    clrf    matrix_candidate + 3
    goto    update
    
update:
    lgoto   update_body
    
    end