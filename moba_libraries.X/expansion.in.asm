; #############################################
; # READ FUNCTION FOR EXPANSION HEADER REV. A #
; #############################################
; # VERSION                                   #
; #   1.0.0 (2015-12-13)                      #
; #############################################
; # TARGET HARDWARE                           #
; #   - PIC16F527			                  #
; #   - MasterBoard Rev. A		              #
; #   - ExpansionHeader Rev. A		          #
; #############################################
; # EXPORTED LABELS                           #
; #   expansion.read (main function)	      #
; #     reads the 16-bit input on the header  #
; #	and stores them at a given location.      #
; #   expansion.read.load_tris		          #
; #     returns the tris configuration needed #
; #     for operation.			              #
; #############################################
; # DESCRIPTION 			                  #
; #   This function handles communication     #
; #   with the input section of the expansion #
; #   header (RC1-RC5).			              #
; #############################################
; # I/O CONSIDERATIONS 			              #
; #   This function assumes RC1, RC2 and RC3  #
; #   to be configured as outputs, and RC4    #
; #   and RC5 to be configured as inputs.     #
; #   RC0, RC6 and RC7 are no affected aside  #
; #   from the usual bsf/bcf side-effects.    #
; #############################################
; # MEMORY CONSIDERATIONS		              #
; #   This function requires 4 bytes of RAM.  #
; #   bank-shared memory will not be modified #
; #   bank- and page-handling are included    #
; #############################################
; # FUNCTION CALL / RETURN CONTRACT	          #
; #   This function assumes FSR to contain    #
; #   the destination adress for the first    #
; #   byte of return data. The lower byte     #
; #   (T0-T7) will be written to the address  #
; #   contained in FSR. The higher byte	      #
; #   (T8-T15) will be written into the next  #
; #   memory location. At return the FSR will #
; #   contain the same value as when calling  #
; #   the function.                           #
; #############################################
; # CHANGELOG                                 #
; #   1.0.0 - initial release                 #
; #############################################
    #include <p16f527.inc>
    global  expansion.in
    global  expansion.in.init

    #define a0	RA3
    #define a1	RA2
    #define a2	RA1
    #define d0	RA4
    #define d1	RA5

EXPANSION_READ_DATA	  UDATA
expansion.read.index	  res 1
expansion.read.value_low  res 1
expansion.read.value_high res 1
expansion.read.target	  res 1

    #define index           expansion.read.index
    #define value_low	    expansion.read.value_low
    #define value_high	    expansion.read.value_high
    #define target_pointer  expansion.read.target

    extern  portc.tris.set
    extern  portc.tris.unset
    extern  portc.tris.flush

EXPANSION_READ_VECTOR CODE
expansion.in.init:
    movlw   b'00110000'
    lcall   portc.tris.set
    movlw   b'00001110'
    lcall   portc.tris.unset
    lcall   portc.tris.flush
    return
expansion.in:
    pagesel expansion.in
    banksel target_pointer
    movfw   FSR
    movwf   target_pointer
    movlw   PORTC
    movwf   FSR
    movlw   0x08
    movwf   index
expansion.read_0:
    decf  index, F
    bcf	    INDF, a0
    bcf	    INDF, a1
    bcf	    INDF, a2
    btfsc   index, 0
    bsf	    INDF, a0
    btfsc   index, 1
    bsf	    INDF, a1
    btfsc   index, 2
    bsf	    INDF, a2
    bcf	    STATUS, C
    btfss   INDF, d0
    bsf	    STATUS, C
    rlf	    value_low, F
    bcf	    STATUS, C
    btfss   INDF, d1
    bsf	    STATUS, C
    rlf	    value_high, F
    movf    index, F
    btfsc   STATUS, Z
    goto    expansion.read_1
    goto    expansion.read_0
expansion.read_1:
    ; cleanup & result output
    movfw   target_pointer
    movwf   FSR
    movfw   value_low
    movwf   INDF
    incf    FSR, F
    movfw   value_high
    movwf   INDF
    decf    FSR, F
    bcf	    STATUS, C
    return

    END