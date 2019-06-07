; Include derivative-specific definitions
              INCLUDE 'derivative.inc'

; export symbols
              XDEF find_pin
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
              XREF __SEG_END_SSTACK
; variable/data section
my_variable:  SECTION
compare       ds.b   1
add_val       ds.w   1
counter       ds.b   1

constants:    SECTION
kyle_pin:     dc.b   $01,$02,$03,$04
karin_pin:    dc.b   $02,$02,$02,$02
keith_pin:    dc.b   $03,$03,$03,$03
andrew_pin:   dc.b   $04,$04,$04,$04
audrey_pin:   dc.b   $05,$05,$05,$05

; code section
MyCode:       SECTION
         ;INITIALIZATION
find_pin:          pulx
                   puly
                   sty         add_val
                   pshx
                   ;USER KYLE CHECK
                   ldy         add_val
                   ldx         #kyle_pin
                   movb        #4,counter
Lp1:               ldab        1,y+
                   stab        compare         
                   ldaa        1,x+
                   cmpa        compare
                   bne         next1
                   dec         counter
                   ldaa        counter
                   cmpa        #0
                   beq         return1
                   bne         Lp1
return1:           ldaa        #1
                   rts                   
next1:             ;USER KARIN CHECK      
                   ldy         add_val
                   ldx         #karin_pin
                   movb        #4,counter
Lp2:               ldab        1,y+
                   stab        compare         
                   ldaa        1,x+
                   cmpa        compare
                   bne         next2
                   dec         counter
                   ldaa        counter
                   cmpa        #0
                   beq         return2
                   bne         Lp2
return2:           ldaa        #2
                   rts                   
next2:             ;USER KEITH CHECK
                   ldy         add_val
                   ldx         #keith_pin
                   movb        #4,counter
Lp3:               ldab        1,y+
                   stab        compare         
                   ldaa        1,x+
                   cmpa        compare
                   bne         next3
                   dec         counter
                   ldaa        counter
                   cmpa        #0
                   beq         return3
                   bne         Lp3
return3:           ldaa        #3
                   rts                   
next3:             ;USER AUDREY CHECK
                   ldy         add_val
                   ldx         #audrey_pin
                   movb        #4,counter
Lp4:               ldab        1,y+
                   stab        compare         
                   ldaa        1,x+
                   cmpa        compare
                   bne         next4
                   dec         counter
                   ldaa        counter
                   cmpa        #0
                   beq         return4
                   bne         Lp4
return4:           ldaa        #4
                   rts                   
next4:             ;USER ANDREW CHECK
                   ldy         add_val
                   ldx         #andrew_pin
                   movb        #4,counter
Lp5:               ldab        1,y+
                   stab        compare         
                   ldaa        1,x+
                   cmpa        compare
                   bne         next5
                   dec         counter
                   ldaa        counter
                   cmpa        #0
                   beq         return5
                   bne         Lp5
return5:           ldaa        #5
                   rts                   
next5:             ;INCORRECT PIN
                   ldaa        #0
                   rts