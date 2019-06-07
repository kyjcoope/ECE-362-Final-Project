; Include derivative-specific definitions
            INCLUDE 'derivative.inc'

; export symbols
              XDEF RTI_Ser
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on

              XREF __SEG_END_SSTACK
     
; variable/data section
my_variable:  SECTION
sec_counter   ds.w 1
d_flag          ds.b 1
counter       ds.w 1
; code section
MyCode:       SECTION
RTI_Ser:      ldx       sec_counter       ;1 sec timer
              inx  
              stx       sec_counter
              cpx       #1000
              bne       nex0
           
              movw      #0,sec_counter    ;5 sec timer
              ldx       counter
              inx 
              stx       counter
              cpx       #4
              bne       nex0              ;
              movw      #0,counter
              movb      #1,d_flag
           
nex0:         ldab      port_p            ;check pb press
              andb      #$20
              cmpb      #0
              bne       nex1
              movb      #1,d_flag
           
nex1:         jsr       check_low         ;check switches low
              cmpa      #0
              bne       sw_high        
              movb      #3,d_flag
              
                            
END_RTI:      movb      #$80, CRGFLG 
              rti