    #include <p16f527.inc>

    global  random

RANDOM_DATA UDATA
random.rand	res 1
    #define rand    random.rand

RANDOM_VECTOR	CODE

random:
    banksel rand
    ; resolve zero state
    movf    rand, F
    btfsc   STATUS, Z
    incf    rand, F
    ; actual random function
    rlf	    rand, W
    rlf	    rand, W
    btfsc   rand, 4
    xorlw   0x01
    btfsc   rand, 5
    xorlw   0x01
    btfsc   rand, 3
    xorlw   0x01
    movwf   rand
    return

    END