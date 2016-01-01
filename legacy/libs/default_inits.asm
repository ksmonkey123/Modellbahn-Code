    IFNDEF DEFAULT_INITS.ALREADY_INCLUDED
    #define DEFAULT_INITS.ALREADY_INCLUDED
    IFDEF   DEBUG
    messg   "included default_inits.asm"
    ENDIF
; ############################################################################
DEFAULT_INIT macro
    IFDEF DEFAULT_INITS.ALREADY_DID_DEFAULT
    ERROR   DEFAULT_INIT should only be used once!
    EXITM
    ENDIF
    #define DEFAULT_INITS.ALREADY_DID_DEFAULT
    IFDEF   DEBUG
    messg   "inserted default init code"
    ENDIF
    banksel INTCON0
    bcf	    INTCON0, GIE	; no interrupts
    banksel INTCON1
    clrf    INTCON1
    banksel ANSEL
    clrf    ANSEL		; no analog inputs
    banksel VRCON
    bcf	    VRCON, VREN		; no voltage reference
    bcf	    CM1CON0, C1ON	; no comparators
    bcf	    CM2CON0, C2ON
    banksel 0
    movlw   0xC0
    option
    ENDM

DEFAULT_VECTORS macro _startPoint
    IFDEF DEFAULT_INITS.ALREADY_DID_VECTORS
    ERROR DEFAULT_VECTORS should only be used once!
    EXITM
    ENDIF
    #define DEFAULT_INITS.ALREADY_DID_VECTORS
    IFDEF   DEBUG
    messg   "inserted default vectors"
    ENDIF
START_VECT  CODE    0x000
    goto    _startPoint
RES_VECT    CODE    0x3FF       ; processor reset vector
    goto    _startPoint
;    goto    _startPoint		; go to beginning of program
INT_VECT    CODE    0x004	; ignore interrupts (are deactivated)
    retfie
    ENDM
; #############################################################################
    ELSE
    IFDEF DEBUG
    messg   "already included!"
    ENDIF
    ENDIF