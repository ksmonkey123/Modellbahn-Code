    #include <p16f527.inc>

    global  log2

LOG2_VECTOR  CODE
; returns the floor of the binary logarithm
; of the content of INDF.
; if INDF holds 0, -1 / 0xFF is returned
; equivalent function:
;   return (INDF == 0) ? -1 : floor(log(INDF) / log(2));
log2:
    btfsc   INDF, 7
    retlw   7
    btfsc   INDF, 6
    retlw   6
    btfsc   INDF, 5
    retlw   5
    btfsc   INDF, 4
    retlw   4
    btfsc   INDF, 3
    retlw   3
    btfsc   INDF, 2
    retlw   2
    btfsc   INDF, 1
    retlw   1
    btfsc   INDF, 0
    retlw   0
    retlw   0xFF

    END