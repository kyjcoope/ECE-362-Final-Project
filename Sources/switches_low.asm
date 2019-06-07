; Include derivative-specific definitions
            INCLUDE 'derivative.inc'

; export symbols
            XDEF check_low
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
            XREF __SEG_END_SSTACK
            
; variable/data section 
MY_EXTENDED_RAM: SECTION 
var1: ds.b 1  

constants:  section 
port_t:     equ $240 
 
code:       section   
check_low:  pulx
            ldab port_t         
            andb #$ff         
            cmpb #$00   ;check if any switch has been flipped       
            bne  a1
            ldaa #0     ;subroutine returns 0, no switch has been flipped
            psha
            pshx
            rts      ;return
a1:         ldaa #1
            psha
            pshx
            rts