; Include derivative-specific definitions
              INCLUDE 'derivative.inc'

; export symbols
              XDEF check_high
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
              XREF __SEG_END_SSTACK
            
; variable/data section 
MY_EXTENDED_RAM: SECTION 
var1: ds.b 1  

constants:    section 
port_t:       equ $240 
 
code:         section   
check_high:   pulx
              ldab port_t ;check if switch 2 high        
              andb #$01         
              cmpb #$01         
              bne  nx0         
              ldab #$01
              pshb
              pshx
              rts
              
nx0:          ldab port_t
              andb #$02         
              cmpb #$02         
              bne  nx1         
              ldab #$02
              pshb
              pshx
              rts 
              
nx1:          ldab port_t     
              andb #$04         
              cmpb #$04         
              bne  none         
              ldab #$04
              pshb
              pshx
              rts 
              
none:         ldab #0
              pshb
              pshx
              rts
                                  