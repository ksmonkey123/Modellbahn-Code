    #include <p16f527.inc>
    __CONFIG 0x3B4

    #define DEBUG

    #define network.config.sender
    #define network.out.byte	PORTB
    #define network.out.bit	RB7

    #include "../libs/network"
    #include "../libs/expansion_API"
    #include "../libs/led"
    #include "../libs/default_inits"

    DEFAULT_VECTORS start

main_ram:   UDATA
buttons	res 2

MAIN_VECTOR CODE
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
main:
    movlw   buttons
    movwf   FSR
    call    expansion.read
    call    expansion.write
    call    network.sendByte
    goto    main


    END