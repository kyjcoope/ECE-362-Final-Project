; Include derivative-specific definitions
              INCLUDE 'derivative.inc'

; export symbols
              XDEF find_card
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
              XREF __SEG_END_SSTACK
; variable/data section
my_variable:  SECTION


constants:    SECTION
card_array    dc.b   "2H","3H","4H","5H","6H","7H","8H","9H","TH","JH","QH","KH","AH","2D","3D","4D","5D","6D","7D","8D","9D","TD","JD","QD","KD","AD","2S","3S","4S","5S","6S","7S","8S","9S","TS","JS","QS","KS","AS","2C","3C","4C","5C","6C","7C","8C","9C","TC","JC","QC","KC","AC"

; code section
MyCode:       SECTION
find_card:    puly
              pulb
              ldaa        #1
              aba
              ldx         #card_array
Lp1:          leax        2,x
              dbne        a,Lp1
              pshx
              pshy
              rts