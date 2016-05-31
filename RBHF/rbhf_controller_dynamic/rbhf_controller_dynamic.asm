    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

; INPUT PIN LAYOUT: 0-3 - station tracks 1-4 ; 4,5 - exit tracks
;                   6,7 - reset buttons

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
;</editor-fold>

#define temp    _global_0

PROGRAM_VECTOR  code    0x100
; =========== START OF MAIN PROGRAM ============
; -------- processor setup and i/o init --------
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
; -------------- main program loop -------------
main:
    ; read input
    movlw   input
    movwf   FSR
    lcall   expansion.in
    pagesel main
    banksel input
    movf    input, F
    ; no input?
    btfsc   STATUS, Z
    goto    publish
    ; reset?
    pagesel clear_inner
    btfsc   input, 6
    call    clear_inner
    btfsc   input, 7
    call    clear_outer
    ; count inputs
    movlw   input
    movwf   FSR
    lcall   count_ones
    movwf   temp
    pagesel dirup
    xorlw   0x01
    btfsc   STATUS, Z
    goto    dirup
    movf    temp, W
    pagesel publish
    xorlw   0x02
    btfss   STATUS, Z
    goto    publish
    lgoto   process
    
dirup:
    ; direction update
    banksel input
    movf    input, W
    andlw   0x30
    movlw   0x00
    btfss   STATUS, Z
    movlw   0xc0
    movwf   dircache
    lgoto   publish
    
publish:
    ; publish output and send command
    lcall   build_leds
    movlw   output
    movwf   FSR
    lcall   expansion.out
    movlw   command
    movwf   FSR
    lcall   serial.out
    lgoto   main
    
process:
    banksel input
    pagesel publish
    ; simple validation
    movf    input, W
    andlw   0x30
    btfsc   STATUS, Z
    goto    publish
    movf    input, W
    andlw   0x0f
    btfsc   STATUS, Z
    goto    publish
    ; clear colliding groups
    btfsc   input, 4
    goto    process_clear_inner
    movf    input, W
    andlw   0x03
    btfss   STATUS, Z
    goto    process_clear_inner
process_check_outer:
    btfsc   input, 5
    goto    process_clear_outer
    movf    input, W
    andlw   0x0c
    btfsc   STATUS, Z
    goto    process_update
process_clear_outer:
    lcall   clear_outer
    lgoto   process_update
process_clear_inner:
    lcall   clear_inner
    lgoto   process_check_outer
    
process_update:
    pagesel $
    movf    input, W
    andlw   0x13
    btfsc   STATUS, Z
    goto    process_update_
    movf    dircache, W
    andlw   0x40
    iorwf   input, F
process_update_:
    movf    input, W
    andlw   0x2a
    btfsc   STATUS, Z
    goto    process_update__
    movf    dircache, W
    andlw   0x80
    iorwf   input, F
process_update__:
    movf    input, W
    iorwf   command, F
    lgoto   publish
    
; ========================================
    fill    (xorlw 0xff), (0x200 - $) ; keep libs out of second quarter
    
SUBROUTINES code    0x200
clear_inner:
    ; clear inner group (or all if groups are crossed)
    pagesel clear_all
    banksel command
    clrf    temp
    btfsc   command, 4
    incf    temp, F
    movf    command, W
    andlw   0x03
    btfsc   STATUS, Z
    decf    temp, F
    movf    temp, F
    btfss   STATUS, Z
    goto    clear_all
    movlw   0xac
    andwf   command, F
    return
    
clear_outer:
    ; clear outer group (or all if groups are crossed)
    pagesel clear_all
    banksel command
    clrf    temp
    btfsc   command, 5
    incf    temp, F
    movf    command, W
    andlw   0x0c
    btfsc   STATUS, Z
    decf    temp, F
    movf    temp, F
    btfss   STATUS, Z
    goto    clear_all
    movlw   0x53
    andwf   command, F
    return
    
clear_all:
    ; clear all groups
    banksel command
    clrf    command
    return
    
build_leds:
    ; construct the output from the command
    banksel command
    clrf    output + 0
    clrf    output + 1
    ; inner station tracks
    clrf    temp
    btfsc   command, 0
    bsf     temp, 1
    btfsc   command, 1
    bsf     temp, 3
    btfsc   command, 6
    rrf     temp, W
    andlw   0x0f
    iorwf   output, F
    ; outer station tracks
    clrf    temp
    btfsc   command, 2
    bsf     temp, 1
    btfsc   command, 3
    bsf     temp, 3
    btfsc   command, 7
    rrf     temp, F
    swapf   temp, W
    andlw   0xf0
    iorwf   output, F
    ; inner entrance
    pagesel $
    btfss   command, 4
    goto    build_leds_
    movlw   0x02
    btfsc   command, 6
    movlw   0x01
    iorwf   output + 1, F
    ; outer entrance
build_leds_:
    btfss   command, 5
    return
    movlw   0x08
    btfsc   command, 7
    movlw   0x04
    iorwf   output + 1, F
    return

    END