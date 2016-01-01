    #include    <p16f527.inc>
    __config    0x3b4
    radix       HEX
; ################################################
; # PASSIVE FASTNET DEBUGGER W/ EXPANSION HEADER #
; #     > Version 1.0                            #
; #     > PIC16F527 (4HMz)                       #
; #     > MasterBoard Rev. A                     #
; #     > ExpansionHeader Rev. A                 #
; ################################################

;<editor-fold defaultstate="collapsed" desc="base vectors">
RESET_VECTOR    code    0x3ff
    goto    0x000

START_VECTOR    code    0x000
    lgoto   start

IRUPT_VECTOR    code    0x004
    retfie
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="library imports">
    extern  fastnet.receive
    extern  deactivate_specials
;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="ram allocation">
PROGRAM_RAM     udata
input       res 1
;</editor-fold>

PROGRAM_VECTOR  code    0x100
; ================== START OF MAIN PROGRAM ==================
; ----------------------- device setup ----------------------
start:
    lcall   deactivate_specials
    banksel 0
    movlw   0xff
    tris    PORTB
    clrf    PORTB
    movlw   0x00
    tris    PORTC
    clrf    PORTC
    banksel input
    clrf    input
    movlw   input
    movwf   FSR
; ------------------- main execution loop -------------------
main:
    lcall   fastnet.receive
    banksel 0
    movfw   INDF
    movwf   PORTC
    lgoto   main
; =================== END OF MAIN PROGRAM ===================
    fill    (xorlw 0xff), (0x200 - $)
    end