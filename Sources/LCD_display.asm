; Include derivative-specific definitions
              INCLUDE 'derivative.inc'
; export symbols
              XDEF Display
              XREF __SEG_END_SSTACK, init_LCD, display_string, Game, find_card,find_val
     
; variable/data section
my_variable:  SECTION
wait_counter  ds.w  1
Money:        ds.w  1
bet           ds.w  1
random_num1   ds.w  1
random_num2   ds.w  1
counter1      ds.w  1
counter2      ds.w  1
disp:	        ds.b  33
temp:         ds.b  1
var           ds.b  1
dealer_card   ds.b  1
user_card     ds.b  1
dealer_card2  ds.b  1
user_card2    ds.b  1
lock_disp     ds.b  1
deal_total    ds.b  1
user_total    ds.b  1
user_ace      ds.b  1
dealer_ace    ds.b  1
user_bust     ds.b  1
dealer_bust   ds.b  1
d_flag        ds.b  1
first_hand    ds.b  1
tie_flag      ds.b  1
dealer_stay   ds.b  1
user_stay     ds.b  1
keyPad        ds.b  1
user_21       ds.b  1
dealer_21     ds.b  1
wait_lock     ds.b  1
new_hand      ds.b  1
cur_user      ds.b  1




constants:    SECTION
welcome:      dc.b        "Welcome                         "
menu:         dc.b        "PB to Swipe     SW1-3 for Guest "
add_Moola:    dc.b        "Add Money:      $               "
add_bet:      dc.b        "Bet:            $               "
game_panel1:  dc.b        "Dealer:         User:           " ;dealer:disp+7,disp+8;User:disp+21,disp+22
game_panel2:  dc.b        "Dealer:XX     XXUser:           "
user_busted:  dc.b        "YOU LOSE:$      D:          U:  "
dealer_busted:dc.b        "YOU WIN:$       D:          U:  "
tie:          dc.b        "TIE             D:          U:  "
pin:          dc.b        "ENTER PIN                       "
kyle:         dc.b        "KYLE:$                          "
karin:        dc.b        "KARIN:$                         "
keith:        dc.b        "KEITH:$                         "
audrey:       dc.b        "AUDREY:$                        "
andrew:       dc.b        "ANDREW:$                        "

                                                             

; code section
MyCode:       SECTION
Display:
;*************************************************************************
              ;PULLING DATA FROM STACK/COUNTERS/INTI
              inc         counter1
              inc         counter2
              inc         counter2
              movb        #0,disp+32    ;get A
              pulx
              puly
              sty         random_num1
              puly
              sty         random_num2
              puly        
              sty         bet
              puly
              sty         Money
              pula
              staa        lock_disp
              pula
              staa        d_flag
              pula        
              staa        cur_user
              pula      
              staa        keyPad
              ldaa        #0            ;default new hand value
              psha
              pshx
;***************************************************************************              
              ;WELCOME DISPLAY
              ldaa        d_flag
              cmpa        #0            
              bne         ne0
              ldx         #welcome
              jmp         s_disp
;***************************************************************************           
              ;PRESS ANY DISP
ne0:          ldaa        d_flag
              cmpa        #1
              bne         ne1        
              ldx         #menu
              jmp         s_disp
;***************************************************************************              
              ;ADD MONEY DISP/INIT
ne1:          ldaa        d_flag
              cmpa        #2         
              lbne         ne11
              ;new hand INIT
              movb        #0,deal_total
              movb        #0,user_total
              movb        #0,user_card
              movb        #0,dealer_card
              movb        #0,lock_disp
              movb        #0,var
              movb        #0,temp
              movb        #0,user_ace
              movb        #0,dealer_ace
              movb        #0,user_bust
              movb        #0,dealer_bust
              movb        #0,first_hand
              movb        #0,tie_flag
              movb        #0,dealer_stay
              movb        #0,user_stay
              movb        #0,user_21
              movb        #0,dealer_21
              movb        #0,wait_lock
              movw        #0,wait_counter
              movb        #0,new_hand
              ;add money disp
              ldx         #add_Moola
              ldy         #disp
              ldab        #32
Lp1:          movb        1,x+,1,y+
              dbne        b,Lp1
              ldd         Money
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+17
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+18
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+19
              xgdx
              ldaa        #$30
              aba
              staa        disp+20                  
              jmp         done 
;*************************************************************************************              
              ;ADD BET DISP
ne11:         ldaa        d_flag
              cmpa        #4         
              bne         psh_1
              ldx         #add_bet
              ldy         #disp
              ldab        #32
Lp10:         movb        1,x+,1,y+
              dbne        b,Lp10
              ldd         bet
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+17
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+18
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+19
              xgdx
              ldaa        #$30
              aba
              staa        disp+20                  
              jmp         done
;*************************************************************************************
              ;ENTER PIN
psh_1:        ldaa        d_flag
              cmpa        #5
              bne         load_u
              ldx         #pin
              jmp         s_disp 
;*************************************************************************************
              ;LOAD USER 
load_u:       ldaa        d_flag
              cmpa        #6
              lbne         ne2
              ;check if cur kyle
              ldaa        cur_user
              cmpa        #1
              lbne         ne_u1
              ;load kyle
              ldx         #kyle
              ldy         #disp
              ldab        #32
Lp11:         movb        1,x+,1,y+
              dbne        b,Lp11
              ldd         Money
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+6
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+7
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+8
              xgdx
              ldaa        #$30
              aba
              staa        disp+9
              jmp         done
ne_u1:       ;check if cur karin
              ldaa        cur_user
              cmpa        #2
              bne         ne_u2
              ;load karin
              ldx         #karin
              ldy         #disp
              ldab        #32
Lp12:         movb        1,x+,1,y+
              dbne        b,Lp12
              ldd         Money
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+7
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+8
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+9
              xgdx
              ldaa        #$30
              aba
              staa        disp+10
              jmp         done
ne_u2:       ;check if cur keith
              ldaa        cur_user
              cmpa        #3
              bne         ne_u3
              ;load keith
              ldx         #keith
              ldy         #disp
              ldab        #32
Lp13:         movb        1,x+,1,y+
              dbne        b,Lp13
              ldd         Money
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+7
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+8
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+9
              xgdx
              ldaa        #$30
              aba
              staa        disp+10
              jmp         done
ne_u3:        ;check if cur audrey
              ldaa        cur_user
              cmpa        #4
              bne         ne_u4
              ;load kyle
              ldx         #audrey
              ldy         #disp
              ldab        #32
Lp14:         movb        1,x+,1,y+
              dbne        b,Lp14
              ldd         Money
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+8
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+9
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+10
              xgdx
              ldaa        #$30
              aba
              staa        disp+11
              jmp         done
ne_u4:        ;check if cur andrew
              ldaa        cur_user
              cmpa        #1
              lbne         done
              ;load andrew
              ldx         #andrew
              ldy         #disp
              ldab        #32
Lp15:         movb        1,x+,1,y+
              dbne        b,Lp15
              ldd         Money
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+8
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+9
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+10
              xgdx
              ldaa        #$30
              aba
              staa        disp+11
              jmp         done
              
;*************************************************************************************
              ;FIRST TWO CARDS
ne2:          ldaa        d_flag
              cmpa        #3
              lbne        s_disp        ;press anykey display
              ldaa        first_hand
              cmpa        #0
              lbeq        first
              
              ldaa        keyPad
              cmpa        #0
              bne         dont_stay2
              movb        #1,user_stay
dont_stay2:   ;dealer stay check

              ;wait for a little bit on each panel
              ldaa        wait_lock
              cmpa        #0
              beq         not_lock
              ldx         wait_counter
              inx
              stx         wait_counter
              cpx         #20
              lbne         done
              movw        #0,wait_counter
              movb        #0,wait_lock
not_lock:     ;new game check
              ldaa        new_hand
              cmpa        #0
              lbne        new_h
              ;Dealer stay check
              ldaa        deal_total
              cmpa        #17
              bhs         stay1
              bra         dont_stay1
stay1:        movb        #1,dealer_stay
              ;double stay check
              ldaa        user_stay
              cmpa        #1
              bne         dont_stay1
              ldaa        dealer_stay
              cmpa        #1
              lbeq         check_win                   
dont_stay1:   ;over 21 check
              ldaa        deal_total
              cmpa        #21
              lbhs         check_win
              ldaa        user_total
              cmpa        #21
              lbhs         check_win
              ;bust check                         
              ldaa        user_bust
              cmpa        #1
              lbeq        bust_u
              ldaa        dealer_bust
              cmpa        #1
              lbeq        bust_d
              ;keypad press check, skip if user stay
              ldaa        user_stay
              cmpa        #1
              beq         skip_keypad
              ldab        keyPad
              cmpb        #$20
              lbeq        done
skip_keypad:  ;first hand check            
              ldaa        first_hand
              cmpa        #0
              lbne        second_hand
              
first:        ;PREP GAME PANEL
              movb        #1,first_hand
              ldx         #game_panel2
              ldy         #disp
              ldab        #32
Lp5:          movb        1,x+,1,y+
              dbne        b,Lp5
              
              ;RANDOM CARD 1 DEALER
              ldd         random_num1
              ldx         #52
              idiv
              stab        dealer_card
              ;find val dealer card
              pshb        
              jsr         find_val
              pulx
              ldaa        0,x
              ;ace check
              cmpa        #$0B
              bne         no_ace_d2   ;branch if not ace, inc ace flag if ace
              inc         dealer_ace
no_ace_d2:    ;end ace check
              staa        deal_total
              
              
              ;RANDOM CARD 2 DEALER
              ldd         counter1
              ldx         #52
              idiv
              stab        dealer_card
              ;find val dealer card
              pshb        
              jsr         find_val
              pulx
              ldaa        0,x
              ;ace check
              cmpa        #$0B
              bne         no_ace_d3   ;branch if not ace, inc ace flag if ace
              inc         dealer_ace
no_ace_d3:    ;end ace check
              ;add up dealer total
              ldab        deal_total
              aba
              staa        deal_total
              ;dealer double ace check
              cmpa        #21
              bhi         ace_d1
              bra         dont_stay0
ace_d1:       dec         dealer_ace
              ldaa        deal_total
              ldab        #10
              sba
              staa        deal_total                  
              ;output dealer cards
dont_stay0:   ldab        dealer_card
              pshb
              jsr         find_card
              pulx
              ldaa        0,x
              staa        temp
              movb        temp,disp+9
              ldaa        1,x
              staa        temp
              movb        temp,disp+10
              
              ;RANDOM CARD 1 USER
              ldd         random_num2
              ldx         #52
              idiv
              stab        user_card
              ;find val user card
              pshb        
              jsr         find_val
              pulx
              ldaa        0,x
              ;ace check
              cmpa        #$0B
              bne         no_ace_u2   ;branch if not ace, inc ace flag if ace
              inc         user_ace
no_ace_u2:    ;end ace check
              staa        user_total
              ;output user cards
              ldab        user_card
              pshb
              jsr         find_card
              pulx
              ldaa        0,x
              staa        temp
              movb        temp,disp+21
              ldaa        1,x
              staa        temp
              movb        temp,disp+22
              
              ;RANDOM CARD 2 USER
              ldd         counter2
              ldx         #52
              idiv
              stab        user_card
              ;find val user card
              pshb        
              jsr         find_val
              pulx
              ldaa        0,x
              ;ace check
              cmpa        #$0B
              bne         no_ace_u3   ;branch if not ace, inc ace flag if ace
              inc         dealer_ace
no_ace_u3:    ;end ace check
              ;add up user total
              ldab        user_total
              aba
              staa        user_total
              ;user double ace check
              cmpa        #21
              bhi         ace_u1
              bra         no_u_bust1
ace_u1:       dec         user_ace
              ldaa        user_total
              ldab        #10
              sba
              staa        user_total
              ;output user total
no_u_bust1:   
              ldaa        #0
              ldab        user_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+30
              xgdx
              ldaa        #$30
              aba
              staa        disp+31
              ;output user cards
              ldab        user_card
              pshb
              jsr         find_card
              pulx
              ldaa        0,x
              staa        temp
              movb        temp,disp+23
              ldaa        1,x
              staa        temp
              movb        temp,disp+24
              ;*****************
              ;blackjack check              
              ldaa        deal_total
              cmpa        #21
              bne         no_blackja1
              movb        #1,user_bust
no_blackja1:  ldaa        user_total
              cmpa        #21
              bne         no_blackja2
              movb        #1,dealer_bust
no_blackja2:
              ldaa        dealer_bust
              cmpa        #1
              bne         no_blackja3
              ldaa        user_bust
              cmpa        #1
              bne         no_blackja3
              movb        #1,tie_flag
              
no_blackja3:  movb        #1,wait_lock
              jmp         done     
;********************************************************************             
              ;GAME
              
              
second_hand:  
              ;game panel setup
              ldx         #game_panel1
              ldy         #disp
              ldab        #32
Lp2:          movb        1,x+,1,y+
              dbne        b,Lp2
              ldaa        dealer_stay
              cmpa        #1
              lbeq        no_d_bust
              ;RANDOM CARD FOR DEALER
              ldd         random_num1
              ldx         #52
              idiv
              stab        dealer_card
              ;find dealer card val
              pshb        
              jsr         find_val
              pulx
              ldaa        0,x
              ;ace check
              cmpa        #$0B
              bne         no_ace_d   ;branch if not ace, inc ace flag if ace
              inc         dealer_ace
no_ace_d:     ;end ace check
              ;add up dealer total
              ldab        deal_total
              aba
              staa        deal_total
              ;dealer bust check
              cmpa        #21
              bhi         che_d_bust
              bra         no_d_bust
che_d_bust:   ldaa        dealer_ace
              cmpa        #0
              bne         ace_d
              movb        #1,dealer_bust
              lbra        no_d_bust                 ;dont go to bust yet
ace_d:        dec         dealer_ace
              ldaa        deal_total
              ldab        #10
              sba
              staa        deal_total
              ;disp dealer total
no_d_bust:    ldaa        #0
              ldab        deal_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+14
              xgdx
              ldaa        #$30
              aba
              staa        disp+15
              ;disp dealer card
              ldab        dealer_card
              pshb
              jsr         find_card
              pulx
              ldaa        0,x
              staa        temp
              movb        temp,disp+7
              ldaa        1,x
              staa        temp
              movb        temp,disp+8
                  
        
              ;user stay check
              ldaa        user_stay
              cmpa        #1
              beq         no_u_bust
              ;RANDOM CARD FOR USER
              ldd         random_num2
              ldx         #52
              idiv
              stab        user_card
              ;find user card val
              pshb     
              jsr         find_val
              pulx
              ldaa        0,x
              ;ace check
              cmpa        #$0B
              bne         no_ace_u   ;branch if not ace, inc ace flag if ace
              inc         user_ace
no_ace_u:     ;add up user total
              ldab        user_total
              aba
              staa        user_total
              ;user bust check    
              cmpa        #21
              bhi         che_u_bust
              bra         no_u_bust
che_u_bust:   ldaa        user_ace
              cmpa        #0
              bne         ace_u
              movb        #1,user_bust
              bra         no_u_bust             ;dont go to bust yet
ace_u:        dec         user_ace
              ldaa        user_total
              ldab        #10
              sba
              staa        user_total                  
no_u_bust:    ;user total output        
              ldaa        #0
              ldab        user_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+30
              xgdx
              ldaa        #$30
              aba
              staa        disp+31
              ;output user card
              ldab        user_card
              pshb
              jsr         find_card
              pulx
              ldaa        0,x
              staa        temp
              movb        temp,disp+21
              ldaa        1,x
              staa        temp
              movb        temp,disp+22
              ;*****************
              ;blackjack check              
              ldaa        deal_total
              cmpa        #21
              bne         no_blackja4
              movb        #1,user_bust
no_blackja4:  ldaa        user_total
              cmpa        #21
              bne         no_blackja5
              movb        #1,dealer_bust
no_blackja5:
              ldaa        dealer_bust
              cmpa        #1
              bne         no_blackja6
              ldaa        user_bust
              cmpa        #1
              bne         no_blackja6
              movb        #1,tie_flag
no_blackja6:                
              ;double stay check/win conditions
              bne         no_doub
check_win:    ldaa        deal_total
              cmpa        user_total
              bhi         u_lose
              cmpa        user_total
              beq         u_tie
              bra         u_win
              
u_lose:       ldaa        deal_total
              cmpa        #21
              bls         lose
              bra         u_win
lose:         movb        #1,user_bust
              lbra        bust_u
              
u_win:        ldaa        user_total
              cmpa        #21
              bls         win
              cmpa        #21
              bhi         lose
              bra         u_tie
win:          movb        #1,dealer_bust
              lbra        bust_d
              
u_tie:        movb        #1,tie_flag
              lbra        _tie
              
no_doub:      movb        #1,wait_lock      
              jmp         done
;*****************************************************************************
              ;USER LOSE              
bust_u:       ldx         #user_busted
              ldy         #disp
              ldab        #32
Lp3:          movb        1,x+,1,y+
              dbne        b,Lp3
              ;lose money
              ldd         bet
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+10
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+11
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+12
              xgdx
              ldaa        #$30
              aba
              staa        disp+13
              ;user total
              ldaa        #0
              ldab        user_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+30
              xgdx
              ldaa        #$30
              aba
              staa        disp+31
              ;dealer total
              ldaa        #0
              ldab        deal_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+18
              xgdx
              ldaa        #$30
              aba
              staa        disp+19
              movb        #2,new_hand  
              movb        #1,wait_lock 
              jmp         done 
              
;********************************************************************************
              ;USER WIN              
bust_d:       ldx         #dealer_busted
              ldy         #disp
              ldab        #32
Lp4:          movb        1,x+,1,y+
              dbne        b,Lp4
              ;win money
              ldd         bet
              ldx         #1000
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+9
              ldd         var
              ldx         #100
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+10
              ldd         var
              ldx         #10
              idiv
              std         var
              xgdx
              ldaa        #$30
              aba
              staa        disp+11
              xgdx
              ldaa        #$30
              aba
              staa        disp+12
              ;user total
              ldaa        #0
              ldab        user_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+30
              xgdx
              ldaa        #$30
              aba
              staa        disp+31
              ;dealer total
              ldaa        #0
              ldab        deal_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+18
              xgdx
              ldaa        #$30
              aba
              staa        disp+19
              movb        #1,new_hand
              movb        #1,wait_lock 
              jmp         done                
             
;***************************************************************************
              ;TIE
_tie:         ldx         #tie
              ldy         #disp
              ldab        #32
Lp6:          movb        1,x+,1,y+
              dbne        b,Lp6
              ;user total
              ldaa        #0
              ldab        user_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+30
              xgdx
              ldaa        #$30
              aba
              staa        disp+31
              ;dealer total
              ldaa        #0
              ldab        deal_total
              ldx         #10
              idiv
              xgdx
              ldaa        #$30
              aba
              staa        disp+18
              xgdx
              ldaa        #$30
              aba
              staa        disp+19
              movb        #3,new_hand
              movb        #1,wait_lock 
              jmp         done
                           
;************************************************************************************              
              ;DEFAULT OUTPUT
s_disp:       ldab        #32          ;put into disp
              ldy         #disp           
Lp:           movb        1,x+,1,y+ 
              dbne        b,Lp 
               
;************************************************************************************           
              ;OUTPUT
done:         ldd         #disp         ;diplay
              
              jsr         display_string
              rts
;************************************************************************************
new_h:        pulx
              ldaa        new_hand
              psha
              pshx
              rts