; Include derivative-specific definitions
                  INCLUDE 'derivative.inc'
; export symbols
                  XDEF find_val
                  XREF __SEG_END_SSTACK,
     
; variable/data section
my_variable:      SECTION


constants:        SECTION
card_val_array    dc.b   $02,$03,$04,$05,$06,$07,$08,$09,$0A,$0A,$0A,$0A,$0B,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0A,$0A,$0A,$0B,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0A,$0A,$0A,$0B,$02,$03,$04,$05,$06,$07,$08,$09,$0A,$0A,$0A,$0A,$0B

; code section
MyCode:           SECTION
find_val:         puly
                  pulb
                  ldaa        #1
                  aba
                  ldx         #card_val_array
Lp1:              leax        1,x
                  dbne        a,Lp1
                  pshx
                  pshy
                  rts