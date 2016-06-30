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
    
    movf    input, W
    movwf   output
    
    goto    publish
    
    btfsc   input, 0
    bcf     output, 1
    btfsc   input, 1
    bcf     output, 0
    btfsc   input, 2
    bcf     output, 3
    btfsc   input, 3
    bcf     output, 2
    btfsc   input, 4
    bcf     output, 5
    btfsc   input, 5
    bcf     output, 4
    btfsc   input, 6
    bcf     output, 7
    btfsc   input, 7
    bcf     output, 6
    
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