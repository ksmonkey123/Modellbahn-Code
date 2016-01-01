    #include <p16f527.inc>

    global  count_ones

COUNT_ONES_DATA	UDATA
count_ones.byte	    res 1
count_ones.count    res 1
count_ones.index    res 1

    #define  byte    count_ones.byte
    #define  count   count_ones.count
    #define  index   count_ones.index

COUNT_ONES_VECTOR   CODE
count_ones:
    pagesel count_ones
    banksel byte
    movfw   INDF
    movwf   byte
    clrf    count
    movlw   0x08
    movwf   index
    rrf	    byte, F
    btfsc   STATUS, C
    incf    count, F
    decfsz  index, F
    goto    $-4
    movfw   count
    return

    END