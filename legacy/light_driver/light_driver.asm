;####################################################
;# LIGHT DRIVER				            #
;####################################################
;# VERSION 0.0.1 - 2015/12/04                       #
;####################################################
;# PIN LAYOUT					    #
;#  - B<4:6> serial light driver                    #
;#  - B<7>   digital input (p/u)		    #
;#  - A<1>   status LED				    #
;####################################################
    #include <p16f527.inc>
    __CONFIG 0x3F4
;####################################################
;# MEMORY ALLOCATION				    #
UDATA_SHR
    temp    res 3 ; 3 temp registers
UDATA
    d	    res 3 ; delay registers
    rand    res 1 ; random register
    output  res 2 ; output states
    lastind res 1 ; last register active
;####################################################
;# MACROS & DEFS				    #
; LED CONTROL
LED_ON MACRO
    bsf	    PORTA, 1
    ENDM
LED_OFF MACRO
    bcf	    PORTA, 1
    ENDM
; OUTPUT SEQUENCES
STROBE MACRO
    bsf	    PORTB, 6
    bcf	    PORTB, 6
    ENDM
CLOCK_PULSE MACRO
    bsf	    PORTB, 5
    bcf	    PORTB, 5
    ENDM
#define INPUT PORTB, 7
#define D_OUT PORTB, 4

;####################################################
;# CODE VECTORS					    #
START_VECT  CODE    0x000
    goto start
RES_VECT    CODE    0x3FF
    goto start
INT_VECT    CODE    0x004
    retfie
;####################################################
;# FUNCTION VECTOR				    #
FUNC_VECT   CODE    0x005
bit_lookup:
    addwf   PCL, F
    retlw   b'00000001'
    retlw   b'00000010'
    retlw   b'00000100'
    retlw   b'00001000'
    retlw   b'00010000'
    retlw   b'00100000'
    retlw   b'01000000'
    retlw   b'10000000'

random:
    banksel rand
    rlf	    rand, W
    rlf	    rand, W
    btfsc   rand, 4
    xorlw   0x01
    btfsc   rand, 5
    xorlw   0x01
    btfsc   rand, 3
    xorlw   0x01
    movwf   rand
    andlw   0x07
    return

delay: ; delay 400 ms
    banksel d
    movlw   0x35
    movwf   d
    movlw   0xE0
    movwf   d + 1
    movlw   0x01
    movwf   d + 2
delay_0
    decfsz  d, f
    goto $+2
    decfsz  d + 1, f
    goto $+2
    decfsz  d + 2, f
    goto delay_0
    goto $+1
    goto $+1
    return

flush: ; write 16-bit output and strobe
    banksel output
    movlw   output + 0
    movwf   FSR
    call send_byte
    banksel output
    incf    FSR, F
    call send_byte
    STROBE
    return
send_byte ; sends the data in the byte addressed by FSR
    movlw   0x08
    movwf   temp + 0 ; temp[0] = 'bits remaining'
    movfw   INDF
    movwf   temp + 1 ; temp[1] = 'byte to work on'
    banksel 0
    bcf	    D_OUT
send_byte_0
    rlf	    temp + 1, F ; temp[1] << 1
    btfsc   STATUS, C
    bsf	    D_OUT
    CLOCK_PULSE
    bcf	    D_OUT
    decfsz  temp + 0, F ; temp[0]--;
    goto send_byte_0	; if (temp[0] == 0) continue
    return		; else return

;####################################################
;# MAIN CODE VECTOR				    #
MAIN_PROG   CODE
; STARTUP CODE
start:
    movlb   0
    bcf	    INTCON0, GIE	; no interrupts
    movlb   3
    clrf    INTCON1
    clrf    ANSEL		; no analog inputs
    movlb   1
    bcf	    VRCON, VREN		; no voltage reference
    bcf	    CM1CON0, C1ON	; no comparators
    bcf	    CM2CON0, C2ON
    movlb   0
    movlw   0xC0
    option
    ; PORT SETUP
    movlw   b'11111101'
    tris    PORTA
    bsf	    PORTA, 1
    clrf    PORTB
    movlw   b'10001111'
    tris    PORTB
    banksel rand
    movlw   0xCE
    movwf   rand
    banksel lastind
    movlw   0x00
    movwf   lastind
    call delay
    banksel output
    clrf    output + 0
    clrf    output + 1
    call flush
    banksel 0
    bcf	    PORTA, 1
    goto main
; MAIN EXECUTION LOOP
main:
    call random
    call bit_lookup
    movwf   temp + 0
    banksel lastind
    movfw   lastind
    btfss   STATUS, Z
    goto $+3
    movlw   0x01
    goto $+2
    movlw   0x00
    movwf   lastind
    movwf   temp + 1
    banksel output
    ; calculate target file pointer
    movlw   output + 0
    addwf   temp + 1, W
    movwf   FSR
    ; apply changes to target
    banksel 0
    btfss   INPUT
    goto main_on
    ; must turn off
    LED_OFF
    movfw   temp + 0 ; W = 'target bit'
    xorlw   0xFF
    andwf   INDF     ; disable selected bit (leave others)
    goto main_finish
    ; must turn on
main_on
    LED_ON
    movfw   temp + 0 ; W = 'target bit'
    iorwf   INDF     ; activate selected bit (leave others)
    ; continue
main_finish
    call flush ; write output
    call delay ; sleep for 0.4 seconds
    goto main


;####################################################
END