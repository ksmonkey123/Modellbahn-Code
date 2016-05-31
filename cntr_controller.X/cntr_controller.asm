    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
    
;<editor-fold defaultstate="collapsed" desc="base vectors">
RESET_VECTOR    code    0x3ff
    goto    0x000
    
START_VECTOR    code    0x000
    lgoto   start

IRUPT_VECTOR    code    0x004
    retfie
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="library imports">
    extern  expansion.in, expansion.in.init
    extern  expansion.out, expansion.out.init
    extern  serial.out, serial.out.init
    extern  deactivate_specials
    extern  portc.init
    extern  portb.init
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_MEMORY  udata
input   res 2
output  res 2
;</editor-fold>

PROGRAM_VECTOR  code    0x100
start:
    lcall   deactivate_specials
    lcall   portb.init
    lcall   portc.init
    lcall   serial.out.init
    lcall   expansion.out.init
    lcall   expansion.in.init
    banksel output
    clrf    output + 0
    clrf    output + 1
    movlw   output
    movwf   FSR
    lcall   expansion.out

main:
    movlw   input
    movwf   FSR
    lcall   expansion.in
    banksel input
    pagesel main
    
decorate:
    movf    input, W
    andlw   0x30
    btfss   STATUS, Z
    goto    validate
    movf    input, W
    andlw   0xc0
    btfsc   STATUS, Z
    goto    validate
    movf    input, W
    andlw   0x03
    btfss   STATUS, Z
    bsf     input, 4
    movf    input, W
    andlw   0x0c
    btfss   STATUS, Z
    bsf     input, 5

validate:
    rlf     input, W
    andlw   0xaa
    andwf   input, W
    btfss   STATUS, Z
    goto    publish

process:
    rlf     input, W
    andlw   0xaa
    xorlw   0xff
    andwf   output, F
    rrf     input, W
    andlw   0x55
    xorlw   0xff
    andwf   output, F
    movf    input, W
    iorwf   output, F
    
publish:
    movlw   output
    movwf   FSR
    lcall   expansion.out
    lcall   serial.out
    lgoto   main
    
    fill (xorlw 0xff), (0x200 - $)
    
    END