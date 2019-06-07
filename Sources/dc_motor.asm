; Include derivative-specific definitions
              INCLUDE 'derivative.inc'

; export symbols
              XDEF dc_motor
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
              XREF __SEG_END_SSTACK
variables:    section 
on_off        ds.b      1
  

constants:    section  
port_t        equ       $240
  
Code:         section 
dc_motor:   
              pulx
              pulb
              stab      on_off
              pshx
              ldab      on_off
              cmpb      #0
              beq       off
              cmpb      #1
              beq       on
              bra       dc_done
off:          ldaa      #$00
              staa      port_t
              bra       dc_done
on:           ldaa      #$08
              staa      port_t
              bra       dc_done               
dc_done:      rts 