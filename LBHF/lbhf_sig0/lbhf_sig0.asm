    #include    <p16f527.inc>
    __config    0x3bc
    radix       HEX
    
    ; #######################################
    ; # LEFT EXIT SIGNAL DECODER            #
    ; #######################################
    ; # Notes                               #
    ; #  - watchdog timer is enabled        #
    ; #  - watchdog ratio is 1:64 (1s)      #
    ; #######################################
    ; # I/O configuration                   #
    ; #  - C<0:3> track exits 1-4           #
    ; #  - C<4:6> entrance command code     #
    ; #######################################

    extern  deactivate_specials
    extern  serial.in

PROGRAM_RAM udata
input   res 1

PROGRAM_VECTOR  code 0x000
start:
    movlw   b'11111101' ; wdt ratio 1:32 ≈ 0.5s
    option
    clrwdt
    call    deactivate_specials
    banksel 0
    clrwdt  
    clrf    PORTC
    movlw   0x80
    tris    PORTC
    movlw   input
    movwf   FSR
main:
    call    serial.in
    clrwdt
    btfsc   input, 6
    goto    process
    clrf    PORTC
    goto    main
process:
    call    resolve
    btfsc   input, 7 ; [7] = 1 --> inbound
    andlw   0xf0
    btfss   input, 7 ; [7] = 0 --> outbound
    andlw   0x0f
    movwf   PORTC
    goto    main
resolve:
    movlw   0x0f
    andwf   input, W
    addwf   PCL, F
    retlw   0x00    ; 0000 => OFF
    retlw   0x11    ; 0001 => 1
    retlw   0x22    ; 0010 => 2
    retlw   0x22    ; 0011 => 2 (1 is passive)
    retlw   0x34    ; 0100 => 3
    retlw   0x34    ; 0101 => 3 (1 is passive)
    retlw   0x34    ; 0110 => 3 (2 is passive)
    retlw   0x34    ; 0111 => 3 (1 & 2 are passive)
    retlw   0x48    ; 1000 => 4
    retlw   0x48    ; 1001 => 4 (1 is passive)
    retlw   0x48    ; 1010 => 4 (2 is passive)
    retlw   0x48    ; 1011 => 4 (1 & 2 are passive)
    retlw   0x00    ; 1100 => ERROR
    retlw   0x00    ; 1101 => ERROR
    retlw   0x00    ; 1110 => ERROR
    retlw   0x00    ; 1111 => ERROR

    end