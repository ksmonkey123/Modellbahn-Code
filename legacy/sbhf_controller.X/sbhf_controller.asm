    #include <p16f527.inc>
    __CONFIG 0x3B4

RESET_VECTOR CODE 0x3FF
    goto    start

START_VECTOR CODE 0x000
    goto    start

INTER_VECTOR CODE 0x004
    retfie

    extern  expansion.write, expansion.write.load_tris
    extern  expansion.read, expansion.read.load_tris
    extern  network.send, network.send.load_tris, network.send.init
    extern  deactivate_specials
    extern  log2, count_ones
    extern  _global_0

MAIN_VECTOR  CODE
start:
    lcall   deactivate_specials
    lcall   network.send.init
    lcall   network.send.load_tris
    movwf   _global_0
    lcall   expansion.write.load_tris
    andwf   _global_0, W
    tris    PORTB
    lcall   expansion.read.load_tris
    tris    PORTC
    lcall   led.init
    lcall   random
    
    END