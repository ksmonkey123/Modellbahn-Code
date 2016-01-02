    #include    <p16f527.inc>
    radix       HEX

; ================= PORTC BUFFERED OUTPUT MANAGER =================
;   - Version: 1.0, 2016-01-02
;   - Author:  Andreas Wälchli
;
; This utility provides functions for double-buffered write access
; to PORTC and its tristate configuration. This also allows changes
; to the tristate setting of a single pin without having to know the
; tristate settings of all other pins.

    global  portc.init
    global  portc.tris.copy
    global  portc.tris.set
    global  portc.tris.unset
    global  portc.tris.flush
    global  portc.data.copy
    global  portc.data.set
    global  portc.data.unset
    global  portc.data.flush

PORTC_RAM   udata
portc.tris  res 1
portc.data  res 1

PORTC_VEC   code
portc.init:
    banksel portc.tris
    movlw   0xff
    movwf   portc.tris
    clrf    portc.data
    return
portc.tris.copy:
    banksel portc.tris
    movwf   portc.tris
    return
portc.tris.set:
    banksel portc.tris
    iorwf   portc.tris, F
    return
portc.tris.unset:
    banksel portc.tris
    xorlw   0xff
    andwf   portc.tris, F
    return
portc.tris.flush:
    banksel portc.tris
    movfw   portc.tris
    banksel PORTC
    tris    PORTC
    return
portc.data.copy:
    banksel portc.data
    movwf   portc.data
    return
portc.data.set:
    banksel portc.data
    iorwf   portc.data, F
    return
portc.data.unset:
    banksel portc.data
    xorlw   0xff
    andwf   portc.data, F
    return
portc.data.flush:
    banksel portc.data
    movfw   portc.data
    banksel PORTC
    movwf   PORTC
    return

    end