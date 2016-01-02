    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX

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
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="ram allocation">
memory  udata
buttons     res 2
led_states  res 2
command     res 1
new_command res 1
btn_masks   res 2 ; used by reverse lookup
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="subroutines">
SUBROUTINE_VECTOR code    0x010
; -------------------------- command lookup ---------------------------
get_command_input_low:
    andlw   0x0f
    addwf   PCL, F
    dt  0, 1, 2, 4, 8, 10, 20, 40, 80, 0, 0, 0, 2, 4, 8, 10
get_command_input_high:
    andlw   0x0f
    addwf   PCL, F
    dt  0, 4, 4, 4, 4,  4,  4,  4,  4, 5, 6, 0, 8, 8, 8,  8
search_command:
    banksel new_command
    movlw   0x0f
    movwf   new_command
search_command_0:
    banksel new_command
    movfw   new_command
    call    get_command_input_low
    movwf   btn_masks + 0
    movfw   new_command
    call    get_command_input_high
    movwf   btn_masks + 1
    ; if mask is empty, the command is invalid (keep searching)
    movf    btn_masks + 0, F
    btfss   STATUS, Z
    goto    $+4
    movf    btn_masks + 1, F
    btfsc   STATUS, Z
    goto    search_command_continue
    ; if mask matches buttons, the correct command was found
    movfw   buttons + 0
    xorwf   btn_masks + 0, W
    btfss   STATUS, Z
    goto    search_command_continue ; lower byte does not match
    movfw   buttons + 1
    xorwf   btn_masks + 1, W
    andlw   0x0f ; mask out unused upper nibble
    btfss   STATUS, Z
    goto    search_command_continue ; upper byte does not match
    goto    search_command_break ; match found!
search_command_continue:
    movf    new_command, F
    btfsc   STATUS, Z
    goto    $+3
    decf    new_command, F
    goto    search_command_0
    call    led.off
    banksel new_command
    clrf    new_command
    return
search_command_break:
    call    led.on
    return
;</editor-fold>

PROGRAM_VECTOR  code    0x100
; ======================= START OF MAIN PROGRAM =======================
; -------------- processor setup and i/o initialisation ---------------
start:
    lcall    deactivate_specials
    lcall    portb.init
    lcall    serial.out.init
    lcall    expansion.out.init
    lcall    expansion.in.init
    lcall    led.init
    banksel command
    clrf    command
    clrf    buttons + 0
    clrf    buttons + 1
    clrf    led_states + 0
    clrf    led_states + 1
    movlw   led_states
    movwf   FSR
    lcall    expansion.out
; ------------------------- main program loop -------------------------
main:
    ; READ INPUT
    movlw   buttons
    movwf   FSR
    lcall    expansion.in
    ; PROCESS INPUT
    lcall    search_command
    ; COMMIT CHANGES
    banksel new_command
    movfw   new_command
    btfsc   STATUS, Z
    goto    main_publish
    movwf   command
    movfw   buttons + 0
    movwf   led_states + 0
    movfw   buttons + 1
    andlw   0x0f
    movwf   led_states + 1
    ; PUBLISH DATA
main_publish:
    movlw   led_states
    movwf   FSR
    lcall    expansion.out
    movlw   command
    movwf   FSR
    lcall    serial.out
    ; REPEAT
    lgoto    main

; ======================== END OF MAIN PROGRAM ========================
    fill    (xorlw 0xff), (0x200 - $) ; keep libs out of second quarter

    end