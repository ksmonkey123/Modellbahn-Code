;####################################################
;# SWITCH DECODER SBHF M1 (W3, W4, W5)              #
;####################################################
;# VERSION 2.0.1 - 2015/10/11                       #
;####################################################
;# PIN LAYOUT					    #
;#  - C<0:5> boosted O/C output			    #
;#  - B<4>   digital input (p/u)		    #
;#  - A<0>   status LED				    #
;####################################################
    #include <p16f527.inc>
    __CONFIG 0x3B4
;####################################################
;# MEMORY ALLOCATION				    #
UDATA_SHR
    input   res 1
    output  res	1
    state   res 1
UDATA
    temp    res 1
    temp2   res 1
    temp3   res 1
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
; NETWORK RECEIVER
receive_data:
    btfss   PORTB, 4
    goto $-1
    btfsc   PORTB, 4
    goto $-1
    movlw   0x03
    movwf   temp
    decfsz  temp, F
    goto $-1
    movlw   0x09
    movwf   temp2
    btfsc   PORTB, 4
    goto receive_data
    goto $+1
    goto $+1
receive_data_0
    decfsz  temp2, F
    goto $+2
    return
    movlw   0x02
    movwf   temp
    decfsz  temp, F
    goto $-1
    goto $+1
    rrf	    input, F
    goto $+1
    btfss   PORTB, 4
    goto $+3
    bsf	    input, 7
    goto $+3
    bcf	    input, 7
    nop
    goto receive_data_0
; LOGICAL INPUT READ
read_input:
    call receive_data
    movlw   0x0F
    andwf   input, F
    return
; OUTPUT ROUTINE (argument in output)
write_output:
    ;bcf	    PORTA, 0
    movfw   output
    ;btfss   STATUS, Z
    ;bsf	    PORTA, 0
    ; publish output
    andwf   state, W
    xorwf   output, W
    btfsc   STATUS, Z
    return
    xorlw   0xFF
    iorlw   0xC0
    movwf   PORTC
    tris    PORTC
    bsf	    PORTA, 1
    ; calculate new state
    btfsc   output, 0
    bcf	    state, 1
    btfsc   output, 1
    bcf	    state, 0
    btfsc   output, 2
    bcf	    state, 3
    btfsc   output, 3
    bcf	    state, 2
    btfsc   output, 4
    bcf	    state, 5
    btfsc   output, 5
    bcf	    state, 4
    movfw   output
    iorwf   state, F
    call delay
    movlw   0xFF
    tris    PORTC
    movwf   PORTC
    bcf	    PORTA, 1
    return
; DELAY 1s
delay:		;999990 cycles
    movlw	0x07
    movwf	temp
    movlw	0x2F
    movwf	temp2
    movlw	0x03
    movwf	temp3
delay_0
    decfsz	temp, f
    goto	$+2
    decfsz	temp2, f
    goto	$+2
    decfsz	temp3, f
    goto	delay_0

			;6 cycles
    goto	$+1
    goto	$+1
    goto	$+1

			;4 cycles (including call)
    return
;####################################################
;# RESOLUTION TABLE (argument in input)		    #
resolve:
    movfw   input
    andlw   0x0F
    addwf   PCL
    retlw   b'000000' ;-  0000
    retlw   b'000000' ;A  0001
    retlw   b'000000' ;B  0010
    retlw   b'000000' ;C  0011
    retlw   b'001001' ;D  0100
    retlw   b'100101' ;E  0101
    retlw   b'010101' ;F  0110
    retlw   b'010101' ;G  0111
    retlw   b'000110' ;H  1000
    retlw   b'000110' ;I  1001
    retlw   b'000110' ;J  1010
    retlw   b'000000' ;0  1011
    retlw   b'000000' ;BK 1100
    retlw   b'000000' ;CK 1101
    retlw   b'000000' ;DK 1110
    retlw   b'000000' ;EK 1111
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
    clrf    output
    clrf    state
    ; PORT SETUP
    movlw   0xFD
    tris    PORTA
    bsf	    PORTA, 1
    movlw   0xFF
    tris    PORTB
    tris    PORTC
    movwf   PORTC
    call delay
    bcf	    PORTA, 1
    call delay
    goto main
; MAIN EXECUTION LOOP
main:
    call read_input
    call resolve
    movwf   output
    call write_output
    goto main
;####################################################
END