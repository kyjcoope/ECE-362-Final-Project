; Include derivative-specific definitions
              INCLUDE 'derivative.inc'

; export symbols
              XDEF step_motor
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
              XREF __SEG_END_SSTACK
variables:    section 
counter       ds.b      1
step_         ds.b      1  

constants:    section  
cw_values     dc.b      $0c,$14,$12,$0a
ccw_values    dc.b      $0a,$12,$14,$0c
port_p        equ       $258
  
Code:         section 
step_motor:   
              pulx
              pulb 
              stab step_
              pulb
              stab counter
              pshx
              ldaa step_
              cmpa #0
              beq  cw
              cmpa #1
              beq  pause
              cmpa #2
              beq  ccw
cw:           ldx  #cw_values
              bra  run_m
ccw:          ldx  #ccw_values     
                            
run_m:                    
              abx         
              ldaa 0,x            ;move through values using counter              
              staa port_p         ;output to motor            
pause:        rts 