    IFNDEF GLOBALS.ALREADY_INCLUDED
    #define GLOBALS.ALREADY_INCLUDED
    IFDEF DEBUG
    messg   "included globals.asm"
    ENDIF
; #############################################################################
    UDATA_SHR
_global_0 res 1
_global_1 res 1
_global_2 res 1
_global_3 res 1
    #define _global _global_0
; #############################################################################
    ELSE
    IFDEF DEBUG
    messg   "already included!"
    ENDIF
    ENDIF