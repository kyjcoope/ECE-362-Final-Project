; Include derivative-specific definitions
              INCLUDE 'derivative.inc'

; export symbols
              XDEF Hex_Pad
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
              XREF __SEG_END_SSTACK
;variable/data section 
MY_EXTENDED_RAM:  SECTION 
val               ds.b       1 
counter_HEX       ds.b       1 
counter_INDEX     ds.b       1 
flag              ds.b       1 
 
constants:        section 
hex_values        dc.b        $70,$b0,$d0,$e0 
index_values      dc.b        $eb,$77,$7b,$7d,$b7,$bb,$bd,$d7,$db,$dd,$e7,$ed, $7e, $be,$de,$ee 
port_u            equ       $268  
;code section 
Code:             SECTION
Hex_Pad:                
                  ldaa #0                    
                  staa counter_HEX 
loop1:            ldx  #hex_values         
                  ldab counter_HEX ;counter to move through values1         
                  cmpb #5         
                  bne  cont     ;     ;used to get around out of range error
                  ldaa #$20
                  pulx
                  psha
                  pshx   
                  rts      ;return no button pressed     
cont:             inc  counter_HEX ;         
                  abx                
                  ldaa 0,x         
                  staa port_u    ;write values1 to port_u         
                  jsr  delay1      ;delay for debounce         
                  ldaa port_u    ;take output from port_u to see if key was pressed         
                  staa val       ;save output to val for later         
                  anda #$0f         
                  cmpa #$0f      ;check to see if anything was pressed         
                  beq  loop1 ;keep loop1 iterating until input received         ;END HEX LOOP         
                  ldaa #$00         
                  staa counter_INDEX          ;START INDEX LOOP      
loop2:            ldx  #index_values         
                  ldab counter_INDEX         
                  abx         
                  ldab 0,x         
                  ldaa counter_INDEX         
                  cmpb val         
                  beq  new ;found index value, branch         
                  inc  counter_INDEX         
                  cmpa #$0f         
                  bne  loop2 ;keep iterating loop2 until correct index found         
                  ldaa #$20
                  pulx
                  psha
                  pshx
                  rts 
new:              ldaa counter_INDEX      
                  pulx
                  psha
                  pshx 
                  rts         
                  ;END INDEX LOOP 
                  ;START DEBOUNCE       
delay1:           pshx
                  ldx  #1000 
loop3:            dex         
                  bne  loop3         
                  pulx         
                  rts            
                  ;END DEBOUNCE 