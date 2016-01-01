    #include <p16f527.inc>

    global  pow2

POW2_VECTOR CODE
; returns pow(2, INDF).
; If INDF is not in range 0-7 (inclusive), 0 is returned.
; equivalent function:
;   return (INDF > 7) ? 0 : pow(2, INDF);
pow2:
    banksel PCL
    movlw   0xF8
    andwf   INDF, W
    btfss   STATUS, Z
    retlw   0x00
    pagesel $
    movfw   INDF
    addwf   PCL, F
    dt	1, 2, 4, 8, 10, 20, 40, 80

    END