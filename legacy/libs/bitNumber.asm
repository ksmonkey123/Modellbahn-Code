    IFNDEF BITNUMBER.ALREADY_INCLUDED
    #define BITNUMBER.ALREADY_INCLUDED
    IFDEF DEBUG
    messg   "included bitNumber.asm"
    ENDIF
; #############################################################################
    #include "../libs/globals"
    #define bitnumber.cache _global_0
    #define bitnumber.count _global_1

bitNumber.lowest_index:
    movfw   INDF
    movwf   bitnumber.cache
    clrf    bitnumber.count
    btfss   bitnumber.cache, 0
    goto    $+3
    movfw   bitnumber.count
    return
    rrf	    bitnumber.cache, F
    incf    bitnumber.count, F
    goto    $-6

    #undefine bitnumber.cache
    #undefine bitnumber.count

; #############################################################################
    ELSE
    IFDEF DEBUG
    messg   "already included!"
    ENDIF
    ENDIF