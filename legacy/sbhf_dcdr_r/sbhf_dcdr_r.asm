;###############################################
;# SBHF DECODER RIGHT (R - W9,10,11)           #
;###############################################
;# A<0> is status LED. ON == SETUP / ILL INPUT #
;# B<7:4> need external pull-up (Input)        #
;# C<5:0> are LC-OC outputs                    #
;###############################################
   ORTA, RA0
ENDM

LED_OFF MACRO
    BCF PORTA, RA0
ENDM

SET_TRIS MACRO port, value
    MOVLW value
    TRIS port
ENDM

READ_INPUT MACRO
    call RECEIVE
    movfw   input
    andlw   0x0F
    movwf   input
ENDM

WRITE_OUTPUT MACRO
    MOVFW output
    MOVWF PORTC
ENDM
    
SWITCH_9a MACRO
    BSF output, 0
    BTFSC state, 0
    BCF output, 0
    BSF state, 0
    BCF state, 1
    ENDM
SWITCH_9b MACRO
    BSF output, 1
    BTFSC state, 1
    BCF output, 1
    BSF state, 1
    BCF state, 0
    ENDM
SWITCH_10a MACRO
    BSF output, 2
    BTFSC state, 2
    BCF output, 2
    BSF state, 2
    BCF state, 3
    ENDM
SWITCH_10b MACRO
    BSF output, 3
    BTFSC state, 3
    BCF output, 3
    BSF state, 3
    BCF state, 2
    ENDM
SWITCH_11a MACRO
    BSF output, 4
    BTFSC state, 4
    BCF output, 4
    BSF state, 4
    BCF state, 5
    ENDM
SWITCH_11b MACRO
    BSF output, 5
    BTFSC state, 5
    BCF output, 5
    BSF state, 5
    BCF state, 4
    ENDM


; GLOBAL VARIABLES (in shared memory)
UDATA_SHR
    output res 1
    input res 1
    state res 1

UDATA
    temp res 1
    temp2 res 1

; CODE

START_VECT  CODE    0x000
    GOTO START

RES_VECT    CODE    0x3FF       ; processor reset vector
    GOTO START			; go to beginning of program

INT_VECT    CODE    0x004	; ignore interrupts (are deactivated)
    RETFIE

MAIN_PROG   CODE                ; let linker place main program

START:
    ; setup
    MOVLB 0
    BCF INTCON0, GIE	; no interrupts
    MOVLB 3
    CLRF INTCON1
    CLRF ANSEL		; no analog inputs
    MOVLB 1
    BCF VRCON, VREN	; no voltage reference
    BCF CM1CON0, C1ON	; no comparators
    BCF CM2CON0, C2ON
    MOVLB 0
    MOVLW 0xC0
    OPTION
    clrf    state
    clrf    PORTC
    ; PORT SETUP
    SET_TRIS PORTA, 0xFE
    LED_ON
    SET_TRIS PORTB, 0xFF
    SET_TRIS PORTC, 0xC0
    ; port setup done, wait for system to be idle
START0:
    READ_INPUT
    MOVFW input
    BTFSS STATUS, Z
    GOTO START0
    LED_OFF
    GOTO MAIN
    
RECEIVE:
    ; detect falling edge
    btfss   PORTB, 4
    goto $-1
    btfsc   PORTB, 4
    goto $-1
    ; verify reset
    movlw   0x03
    movwf   temp
    decfsz  temp, F
    goto $-1
    movlw   0x09
    movwf   temp2
    btfsc   PORTB, 4
    goto RECEIVE
    goto $+1
    goto $+1
    ; loop (the first 6µs have already passed)
receive_0
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
    goto receive_0    
; MAIN PROGRAM
MAIN:
    LED_OFF
    CLRF output
    READ_INPUT
    ; all operations on 11xx
    BTFSS input, 3
    GOTO MAIN
    BCF input, 3
    BTFSS input, 2
    GOTO MAIN
    BCF input, 2
    ; now all valid codes are of shape 00xx
    ; dispatch table for operation routines
    MOVFW input
    ADDWF PCL, F
    GOTO TRACK_B
    GOTO TRACK_C
    GOTO TRACK_D
    GOTO TRACK_E

TRACK_B:
    SWITCH_9a
    SWITCH_10a
    SWITCH_11a
    GOTO APPLY

TRACK_C:
    SWITCH_9a
    SWITCH_10a
    SWITCH_11b
    GOTO APPLY
    
TRACK_D:
    SWITCH_9a
    SWITCH_10b
    GOTO APPLY
    
TRACK_E:
    SWITCH_9b
    GOTO APPLY
    
APPLY:
    WRITE_OUTPUT
    LED_ON
    CALL DELAY
    CLRF output
    WRITE_OUTPUT
    GOTO MAIN
    
DELAY:
    ;49993 cycles
    movlw	0x0E
    movwf	temp
    movlw	0x28
    movwf	temp2
Delay_0:
    decfsz	temp, f
    goto	$+2
    decfsz	temp2, f
    goto	Delay_0
    ;3 cycles
    goto	$+1
    nop
    ;4 cycles (including call)
    return

END