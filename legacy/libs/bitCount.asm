    IFNDEF BITCOUNT.ALREADY_INCLUDED
    #define BITCOUNT.ALREADY_INCLUDED
    IFDEF DEBUG
    messg   "included bitCount.asm"
    ENDIF
; #############################################################################
    #include "../libs/globals"

    #define bitcount.count _global_0
    #define bitcount.data  _global_1
    #define bitcount.index _global_2

bitCount.count_ones:
    movfw   INDF
    movwf   bitcount.data
    clrf    bitcount.count
    movlw   0x08
    movwf   bitcount.index
    rrf	    bitcount.data, F
    btfsc   STATUS, C
    incf    bitcount.count, F
    decfsz  bitcount.index, F
    goto    $-4
    movfw   bitcount.count
    return

    #undefine bitcount.count
    #undefine bitcount.data
    #undefine bitcount.index

; #############################################################################
    ELSE
    IFDEF DEBUG
    messg   "already included!"
    ENDIF
    ENDIF