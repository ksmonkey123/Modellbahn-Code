    #include    <p16f527.inc>
    radix       HEX
    global      decompress
    
    ; ============= FUNCTION DOCUMENTATION ============
    ;   equivalent pseudo-header:
    ;
    ;       void decompress(int seg_count, int value, int* target, int* factors)
    
DECOMPRESS_DATA udata
decompress_data res 6

    #define index       decompress_data + 0
    #define value       decompress_data + 1
    #define target_loc  decompress_data + 2
    #define factor_loc  decompress_data + 3
    #define temp        decompress_data + 4
       
    ; ============== START OF SUBROUTINE ==============
    
DECOMPRESS_VEC  code
decompress:
    pagesel decompress
    banksel index
    movfw   INDF
    movwf   index
    incf    FSR, F
    movfw   INDF
    movwf   value
    incf    FSR, F
    movfw   INDF
    movwf   target_loc
    incf    FSR, F
    movfw   INDF
    movwf   factor_loc
    ;   do {
loop0:
    ;       temp = 0
    clrf    temp
    ;       W = *factor_loc
    movfw   factor_loc
    movwf   FSR
    movfw   INDF
    ;       do {
loop1:
    ;           temp++
    incf    temp, F
    ;           value -= W
    subwf   value, F
    ;       } while (value >= 0)
    btfsc   STATUS, C
    goto    loop1
    ;       value += W
    addwf   value, F
    ;       temp--
    decf    temp, F
    ;       *target_loc = temp
    movfw   target_loc
    movwf   FSR
    movfw   temp
    movwf   INDF
    ;       target_loc++
    incf    target_loc, F
    ;       factor_loc++
    incf    factor_loc, F
    ;   } while (--i > 0)
    decfsz  index, F
    goto    loop0
    ;   return
    return
    
    ; =============== END OF SUBROUTINE ===============
    
    end