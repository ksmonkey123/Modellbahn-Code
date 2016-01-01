;###############################################
;# SBHF CONTROLLER		               #
;###############################################
;# A<1>   status LED			       #
;# C<1:3> button multiplexer inputs (reversed) #
;# C<4:5> multiplexed data inputs	       #
;# B<4:6> led control			       #
;# B<7>   network driver (external p/u), only  #
;#		use tristate control w/ fixed  #
;#		0 (false) output to avoid p/u  #
;#		stress. Inverted logic needed  #
;#		to compensate inner inverter.  #
;###############################################
    #include <p16f527.inc>
    __CONFIG 0x3B4

    ; network configs
    #define network.config.sender
    #define network.out.byte PORTB
    #define network.out.bit  RB7

    ; library imports
    #include "../libs/expansion_API"
    #include "../libs/default_inits"
    #include "../libs/network"
    #include "../libs/led"
    #include "../libs/bitCount"
    #include "../libs/bitNumber"

    DEFAULT_VECTORS start

main_vars UDATA
buttons	       res 2
temp	       res 2

MAIN_PROG   CODE                ; let linker place main program

start:
    DEFAULT_INIT
    LED_INIT
    LED_OFF
    clrf    PORTB
    call    network.init
    movlw   0x0F
    tris    PORTB
    movlw   0xF1
    tris    PORTC
    clrf    buttons + 0
    clrf    buttons + 1
    call    expansion.write
    goto    main

main:
    ; read buttons
    movlw   buttons
    movwf   FSR
    call    expansion.read
    banksel buttons
    ; check if only one root is pressed
    movfw   buttons + 1
    andlw   0x0A
    movwf   temp
    movlw   temp
    movwf   FSR
    call    bitCount.count_ones
    banksel temp
    movwf   temp
    movfw   temp ; update zero flag
    btfsc   STATUS, Z
    goto    main ; nok (no buttons pressed)
    decfsz  temp, F
    goto    main ; nok (both buttons pressed)
    ; check if only one target is pressed
    movfw   buttons + 0
    movwf   temp
    movlw   temp
    movwf   FSR
    call    bitCount.count_ones
    banksel temp
    movwf   temp + 1 ; temp[1] = # of ones in lower byte
    movfw   buttons + 1
    andlw   0x03
    movwf   temp
    movlw   temp
    movwf   FSR
    call    bitCount.count_ones
    banksel temp
    addwf   temp + 1, F ; temp[1] = # of selected targets
    movfw   temp + 1
    btfsc   STATUS, Z
    goto    main ; nok (no target selected)
    decfsz  temp + 1, F
    goto    main ; nok (multiple targets selected)
    ; if buttons 11 is selected, confirm that button 1, 2, 3 or 4 is selected
    btfss   buttons + 1, 3
    goto    $+5
    movfw   buttons + 0
    andlw   0x1E
    btfsc   STATUS, Z
    goto    main ; nok (button 11 is selected, but not 1, 2, 3 or 4)
    ; selection ok. update led
    movlw   buttons
    movwf   FSR
    call    expansion.write
    ; resolve & send
    ; convert target button to target index
    movlw   buttons
    movwf   FSR
    call    bitNumber.lowest_index
    banksel buttons
    movwf   temp
    movfw   temp
    btfss   STATUS, Z
    goto    $+8 ; skip high-byte processing
    movlw   buttons + 1
    movwf   FSR
    call    bitNumber.lowest_index
    banksel buttons
    movwf   temp
    movlw   0x08
    addwf   temp, F
    ; resolve indices to commands
    movlw   0x01
    btfss   buttons + 1, 2 ; K?
    movlw   0x0B
    addwf   temp, F
    ; send command
    movlw   temp
    movwf   FSR
    call    network.sendByte
    goto    main

    END