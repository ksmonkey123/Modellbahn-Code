    #include    <p16f527.inc>
    radix       HEX
    
    global      compress
    
COMPRESSION_DATA    udata
seg_index   res 1
collector   res 1
mul_args    res 2

COMPRESSION_VECTOR  code
compress:
    banksel seg_index
    pagesel compress
    movfw   INDF
    movwf   seg_index
    btfsc   STATUS, Z
    goto    compress_return
    clrf    collector
    ; 1. load next pair
compress_load:
    incf    FSR, F
    movfw   INDF
    movwf   mul_args + 0
    incf    FSR, F
    movfw   INDF
    movwf   mul_args + 1
    ; 2. multiply pair (achieve offset)
    movlw   0x00
    movf    mul_args + 0, F
    btfsc   STATUS, Z
    goto    compress_collect
    addwf   mul_args + 1, W
    decfsz  mul_args + 0, F
    goto    $-2
    ; 3. add to collector
compress_collect:
    addwf   collector, F
    ; 4. if not all pairs are processed, go to 1.
    decfsz  seg_index, F
    goto    compress_load
    ; 5. return collector value
compress_return:
    movfw   collector
    return
    
    end