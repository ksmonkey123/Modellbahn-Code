    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    
RESET_VECTOR    code    0x3ff
    goto    0x000
    
START_VECTOR    code    0x000
    goto    start
    
IRUPT_VECTOR    code    0x004
    retfie
    
    extern  deactivate_specials
    extern  multiply
    extern  divide
    
MAIN_RAM    udata
arg0    res 1
arg1    res 1
res0    res 1
arg1b   res 1
res1    res 1
    
MAIN_VECTOR code    0x100
start:
    lcall   deactivate_specials
    movlw   arg0
    movwf   FSR
    
main:
    nop ; break here to change registers
    lcall   multiply
    banksel res0
    movwf   res0
    movfw   arg1
    movwf   arg1b
    incf    FSR, F
    incf    FSR, F
    lcall   divide
    banksel res1
    movwf   res1
    decf    FSR, F
    decf    FSR, F
    lgoto   main
    
    fill    (xorlw 0xff),   (0x200 - $)
    
    end