; Include derivative-specific definitions
              INCLUDE 'derivative.inc'

; export symbols
              XDEF _Startup ,Entry, RTI_Ser, Game
            ; we use export 'Entry' as symbol. This allows us to
            ; reference 'Entry' either in the linker .prm file
            ; or from C/C++ later on
              XREF __SEG_END_SSTACK,init_LCD, display_string,Display, check_high, Hex_Pad,find_pin,step_motor,dc_motor
; variable/data section
my_variable:  SECTION
counter       ds.w      1
sec_counter   ds.w      1
d_flag        ds.b      1
startup       ds.b      1
disp:	        ds.b      33
pin_array     ds.b      4
sw_flag:      ds.b      1
sw_flag1:     ds.b      1
bet_flag:     ds.b      1
Money:        ds.w      1
bet:          ds.w      1
latch:        ds.b      1
keyPad_val    ds.b      1
rand_counter  ds.w      1
lock          ds.b      1
new_hand      ds.b      1
psh_btn       ds.b      1
kyle_m        ds.w      1
karin_m       ds.w      1
keith_m       ds.w      1
audrey_m      ds.w      1
andrew_m      ds.w      1
user          ds.b      1
keyPad_lock   ds.b      1
pin_index     ds.b      1
step_prog     ds.b      1
step_time     ds.b      1
sw_lock       ds.b      1
ms_30count    ds.b      1
step_lock     ds.b      1
ms250         ds.b      1
ms250_count   ds.b      1
lock250       ds.b      1
ms60          ds.b      1
ms60_count    ds.b      1
lock60        ds.b      1
dc_flag       ds.b      1


constants:    SECTION
port_p        equ       $258
port_p_ddr:   equ       $25a  
port_u_ddr    equ       $26a 
port_u_psr    equ       $26d 
port_u_pder   equ       $26c
port_t_ddr    equ       $242


; code section
MyCode:       SECTION
         ;INITIALIZATION
_Startup:
Entry:        lds       #__SEG_END_SSTACK ;initializing ports
              bset      port_u_ddr, #$f0         
              bset      port_u_psr, #$f0         
              bset      port_u_pder,#$0f
              bset      port_p_ddr, #$1e ;might mess up pb
              bset      port_t_ddr, #$08
              movw      #0,sec_counter
              movw      #0,rand_counter
              movb      #0,startup
              movb      #0,lock
              movb      #$80, CRGINT
              movb      #$40, RTICTL 
              movw      #0, counter
              movb      #0, d_flag
              movb      #0, sw_flag
              ldx       #0
              ldy       #0
              ldd       #0
              movw      #0,Money
              movw      #0,bet
              movw      #200,kyle_m
              movw      #200,karin_m
              movw      #200,keith_m
              movw      #200,audrey_m
              movw      #200,andrew_m
              movb      #0,latch
              movb      #0,new_hand
              movb      #0,bet_flag
              movb      #0,sw_flag1
              movb      #0,psh_btn
              movb      #0,pin_index
              movb      #0,user
              movb      #0,sw_lock
              movb      #0,step_prog
              movb      #0,step_time
              movb      #0,step_lock
              movb      #0,ms250
              movb      #0,ms250_count
              movb      #1,lock250
              movb      #0,ms60
              movb      #0,ms60_count
              movb      #1,lock60
              movb      #$20,keyPad_val
              movb      #0,dc_flag
              jsr       init_LCD
              cli
;*********************************************************************         
         ;DISPLAY LOOP
Game:         ;step motor
              ldaa      sw_lock
              cmpa      #1
              bne       skip_step_m
              ldaa      step_lock
              cmpa      #1
              beq       skip_step_m
              ldaa      step_prog
              psha
              ldaa      step_time
              psha
              jsr       step_motor
              inc       step_prog
              movb      #1,step_lock
skip_step_m:  




              ;Hex_Pad read/check
              jsr       Hex_Pad
              pula
              staa      keyPad_val
              psha
              cmpa      #$20
              bne       skip_unlock
              movb      #0,keyPad_lock
 skip_unlock: 
              ;push vals to LCD_display            
              ldaa      user
              psha
              ldaa      d_flag           ;0=wel,1=press any, 2=switches, 3=game
              psha
              ldaa      lock
              psha
              ldx       Money
              pshx
              ldx       bet
              pshx
              ldx       sec_counter
              pshx
              ldx       rand_counter
              pshx
              jsr       Display
              pula                  
              staa      new_hand
              bra       Game
;************************************************************************
;************************************************************************              
;************************************************************************
              ;RTI START         
RTI_Ser:      
;************************************************************************
              ;DC MOTOR TIMER
              ;60ms count
              ;dc motor spin up
              ldaa      lock60
              cmpa      #1
              lbeq      skip_60
              ldaa      dc_flag
              cmpa      #3
              beq       slow_down
              ldaa      ms60
              ldab      ms60_count
              
              cmpa      ms60_count
              bhs       dc_off
              ldaa      #1
              psha
              jsr       dc_motor
              bra       dc_on
dc_off:       ldaa      #0
              psha
              jsr       dc_motor
dc_on:                            
              inc       ms60
              ldaa      ms60
              cmpa      #60
              lbne       skip_60
              movb      #0,ms60
              ldaa      ms60_count
              cmpa      #60
              beq       stop_dc
              inc       ms60_count
              bra       skip_60
              
              ;dc motor slow down
stop_dc:      ldaa      dc_flag
              cmpa      #1
              beq       skip_60
              movw      #0,counter
              movb      #1,dc_flag
              bra       skip_60
                            
slow_down:
              ldaa      ms60
              ldab      ms60_count
              
              cmpa      ms60_count
              bhs       dc_off1
              ldaa      #1
              psha
              jsr       dc_motor
              bra       dc_on1
dc_off1:      ldaa      #0
              psha
              jsr       dc_motor
dc_on1:                            
              inc       ms60
              ldaa      ms60
              cmpa      #60
              bne       skip_60
              movb      #0,ms60
              ldaa      ms60_count
              cmpa      #0
              beq       stop_dc1
              dec       ms60_count
              bra       skip_60
stop_dc1:     movb      #1,lock60
              movb      #0,ms60_count
              movb      #0,ms60
              movb      #0,dc_flag
              ldaa      #0              
              psha
              jsr       dc_motor
              movb      #1,step_prog
              movb      #1,sw_lock
              movw      #0,counter              
skip_60:

;************************************************************************
              ;STEP MOTOR TIMER
              ;250ms count
              ldaa      lock250
              cmpa      #1
              beq       skip_250
              ldaa      ms250
              inc       ms250
              cmpa      #250
              bne       skip_250
              movb      #0,ms250
              inc       ms250_count
skip_250:
              ;30ms count
              ldaa      ms_30count
              inc       ms_30count
              cmpa      #30
              bne       ms_30
              movb      #0,ms_30count
              movb      #0,step_lock
              ldaa      step_prog
              cmpa      #4
              bne       ms_30
              movb      #0,step_prog
ms_30:        
              ldaa      sw_lock
              cmpa      #1
              bne       skip_timer
              ldx       counter
              cpx       #2
              blo       cw_step
              
              movb      #0,lock250
              ldaa      ms250_count
              cmpa      #0
              beq       pause_step
              cmpa      #4
              beq       stop_step
              bra       ccw_step      
              
cw_step:      movb      #0,step_time
              bra       skip_timer
pause_step:   movb      #1,step_time
              bra       skip_timer
ccw_step:     movb      #2,step_time
              bra       skip_timer
stop_step:    movb      #0,sw_lock
              movb      #0,step_time
              movb      #0,ms250_count
              movb      #1,lock250     
skip_timer:   
;****************************************************************           
              ;NEW HAND CHECK
              ldaa      new_hand
              cmpa      #0
              beq       skip_new
              cmpa      #1
              beq       win_mon
              cmpa      #2
              beq       lose_mon
              cmpa      #3
              beq       reset_game
win_mon:      ldd       Money
              addd      bet
              std       Money
              bra       reset_game
lose_mon:     ldd       Money
              subd      bet
              std       Money
              bra       reset_game          
reset_game:                 
              movb      #0,new_hand
              movw      #0,bet
              movb      #0,psh_btn
              movb      #2,d_flag
;************************************************************************
              ;TIMERS              
skip_new      inc       rand_counter
              inc       rand_counter
              ldx       sec_counter       ;1 sec timer
              inx 
              stx       sec_counter
              cpx       #1000
              bne       nex0

timer:        movw      #0,sec_counter    ;5 sec timer
              ldx       counter
              inx 
              stx       counter
              cpx       #4
              bne       nex0
              ldaa      dc_flag
              cmpa      #1
              bne       ski_dc
              movb      #3,dc_flag
ski_dc:       ldaa      d_flag
              cmpa      #6
              bne       ski_mon
              movb      #2,d_flag              
ski_mon:      movw      #0,counter
;********************************************************************* 
              ;PRESS ANY             
              ldab      d_flag            ;after 5 sec go press any key screen
              cmpb      #0
              bne       nex0
              movb      #1,d_flag
              movb      #0,bet_flag
              lbra      END_RTI
              ;END
              
;*********************************************************************'
              ;PUSH BUTTON              
nex0:         ldab      d_flag
              cmpb      #1
              beq       check_psh
              cmpb      #0
              beq       check_psh
              ldab      psh_btn
              cmpb      #1
              beq       ent_pin
              lbra      nex1
check_psh:              
              ldab      port_p            ;check pb press
              andb      #$20
              cmpb      #0
              bne       ent_pin
              movb      #1,psh_btn
              movb      #5,d_flag
              lbra      END_RTI
;*********************************************************************
              ;PIN CHECK
ent_pin:      ldab      d_flag
              cmpb      #5
              lbne       nex1
              ldaa      keyPad_lock
              cmpa      #0
              lbne       no_check
              ldaa      keyPad_val
              cmpa      #$20
              lbeq       no_check
              movb      #1,keyPad_lock
              ldab      pin_index
              cmpb      #0
              bne       pin_c1  
              staa      pin_array
              inc       pin_index
              bra       no_check
              
pin_c1:       cmpb      #1
              bne       pin_c2   
              staa      pin_array+1
              inc       pin_index
              bra       no_check
              
pin_c2:       cmpb      #2
              bne       pin_c3    
              staa      pin_array+2
              inc       pin_index
              bra       no_check
              
pin_c3:       cmpb      #3
              bne       no_check   
              staa      pin_array+3
              movb      #0,pin_index
              
pin_check:    ldx       #pin_array
              pshx
              jsr       find_pin
              cmpa      #0
              bne       nex_u1
              bra       no_check
              ;something should be here
              
nex_u1:       staa      user
              ;set money to kyles money
              cmpa      #1
              bne       nex_u2
              ldx       kyle_m
              stx       Money
              bra       set_flag
nex_u2:       ;set money to karins money
              cmpa      #2
              bne       nex_u3
              ldx       karin_m
              stx       Money
              bra       set_flag
nex_u3:       ;set money to keiths money
              cmpa      #3
              bne       nex_u4
              ldx       keith_m
              stx       Money
              bra       set_flag
nex_u4:       ;set money to audreys money
              cmpa      #4
              bne       nex_u5
              ldx       audrey_m
              stx       Money
              bra       set_flag
nex_u5:       ;set money to andrews money
              cmpa      #5
              bne       set_flag
              ldx       andrew_m
              stx       Money
              bra       set_flag
                    
set_flag:     movb      #6,d_flag
              movw      #0,counter
                                                        
no_check:                   
;*********************************************************************              
              ;GO TO ADD MONEY CHECK
nex1:         ldab     d_flag
              cmpb     #1
              bne      nex2
              jsr      check_high
              pulb
              cmpb     #0
              bne      nex2
              lbra     END_RTI
              
;*********************************************************************              
              ;ADD MONEY SWITCH START          
nex2:         ldaa      d_flag
              cmpa      #4
              lbeq      bet_
              cmpa      #3
              lbeq      skip_sw
              ldaa      keyPad_val
              cmpa      #$0a
              lbeq      bet_
              ;check cash out
              cmpa      #$0c
              bne       dont_cash
              ldx       #0
              ldaa      user
              cmpa      #1
              bne       u1
              stx       kyle_m
u1:           cmpa      #2
              bne       u2
              stx       karin_m
u2:           cmpa      #3
              bne       u3
              stx       keith_m
u3:           cmpa      #4
              bne       u4
              stx       audrey_m
u4:           cmpa      #5
              bne       u5
              stx       andrew_m
u5:           movw      #0,Money
              movb      #1,d_flag
              movb      #0,user
              movb      #0,lock60
              lbra      END_RTI
dont_cash:   ;leave game
              cmpa      #$0f
              bne       dont_cash1
              ldx       Money
              ldaa      user
              cmpa      #1
              bne       u11
              stx       kyle_m
u11:           cmpa      #2
              bne       u21
              stx       karin_m
u21:           cmpa      #3
              bne       u31
              stx       keith_m
u31:           cmpa      #4
              bne       u41
              stx       audrey_m
u41:           cmpa      #5
              bne       u51
              stx       andrew_m
u51:          
              movb      #1,d_flag
              movb      #0,user
              lbra      END_RTI
dont_cash1:    ;ADD MONEY          
              movb      #0,bet_flag
              ldaa      sw_lock
              cmpa      #1
              lbeq      END_RTI
              jsr       check_high         ;check which and if switches were flipped
              pulb
              cmpb      #1                 ;check sw0 high
              bne       sw1
              movb      #2,d_flag
              movb      #1,sw_flag
              jmp       END_RTI
              
sw1:          cmpb      #2                 ;check sw1 high
              bne       sw2
              movb      #2,d_flag
              movb      #2,sw_flag
              jmp       END_RTI
              
sw2:          cmpb      #4                 ;check sw2 high
              bne       sw_0
              movb      #2,d_flag
              movb      #4,sw_flag
              jmp       END_RTI
              ;wait for switch to go low
sw_0:         ldab      sw_flag            ;no switch flipped low
              andb      #$ff
              cmpb      #$00
              lbeq       END_RTI
              
              ldab      sw_flag
              ldx       Money
              cmpb      #1                 ;check if add $5
              bne       Moo_10
              ldab      #5
              abx
              stx       Money
              clr       sw_flag            ;start spin
              movb      #1,sw_lock
              movb      #1,step_prog
              movw      #0,counter
              jmp       END_RTI
             
Moo_10:       ldab      sw_flag
              ldx       Money
              cmpb      #2                 ;check if add $10
              bne       Moo_20
              ldab      #10
              abx
              stx       Money
              clr       sw_flag            ;start spin
              movb      #1,sw_lock
              movb      #1,step_prog
              movw      #0,counter
              jmp       END_RTI                     
              
Moo_20:       ldab      sw_flag
              ldx       Money
              cmpb      #4                 ;check if prev was 1
              lbne       END_RTI
              ldab      #20
              abx
              stx       Money
              clr       sw_flag           ;start spin
              movb      #1,step_prog
              movb      #1,sw_lock
              movw      #0,counter
              jmp       END_RTI
              ;END
;*********************************************************************              
              ;BET SWITCH START          
bet_:         
              ldaa      d_flag
              cmpa      #0
              lbeq       END_RTI
              cmpa      #1
              lbeq       END_RTI
              cmpa      #3
              lbeq      skip_sw
              ldaa      bet_flag
              cmpa      #0
              bne       skip_
              movb      #1,bet_flag
              movb      #4,d_flag
skip_         ldaa      keyPad_val
              cmpa      #1
              lbeq      skip_sw       ;if keypad press branch            
              ldaa      d_flag
              cmpa      #3
              lbeq      skip_sw       ;if playing game branch
              jsr       check_high         ;check which and if switches were flipped
              pulb
              cmpb      #1                 ;check sw0 high
              bne       sw3
              movb      #4,d_flag
              movb      #1,sw_flag1
              jmp       END_RTI
              
sw3:          cmpb      #2                 ;check sw1 high
              bne       sw4
              movb      #4,d_flag
              movb      #2,sw_flag1
              jmp       END_RTI
              
sw4:          cmpb      #4                 ;check sw2 high
              bne       sw_5
              movb      #4,d_flag
              movb      #4,sw_flag1
              jmp       END_RTI
              ;wait for switch to go low
sw_5:         ldab      sw_flag1            ;no switch flipped low
              andb      #$ff
              cmpb      #$00
              lbeq       END_RTI
              
              ldab      sw_flag1
              ldx       bet
              cmpb      #1                 ;check if add $5
              bne       Moo_11
              ldx       bet
              ldab      #5
              abx
              xgdx
              cpd       Money
              bhi       dont_5
              ldx       bet
              ldab      #5
              abx
              stx       bet
dont_5:       clr       sw_flag1
              jmp       END_RTI
             
Moo_11:       ldab      sw_flag1
              cmpb      #2                 ;check if add $10
              bne       Moo_22
              ldx       bet
              ldab      #10
              abx
              xgdx
              cpd       Money
              bhi       dont_10
              ldx       bet
              ldab      #10
              abx
              stx       bet
dont_10:      clr       sw_flag1
              jmp       END_RTI                     
              
Moo_22:       ldab      sw_flag1
              cmpb      #4                 ;check if prev was 1
              bne       END_RTI
              ldx       bet
              ldab      #20
              abx
              xgdx
              cpd       Money
              bhi       dont_20
              ldx       bet
              ldab      #20
              abx
              stx       bet
dont_20:      clr       sw_flag1
              jmp       END_RTI
              ;END              
;*********************************************************************              
              ;GAME
skip_sw:      ldaa      d_flag
              cmpa      #0
              beq       END_RTI     ;dont run game if at welcome screen
              movb      #3,d_flag
              
              ldaa      keyPad_val
              cmpa      #$20
              bne       unlock       ;unlock if keypad pressed, lock if not
              movb      #1,lock
              bra       skip_un
unlock:       
              movb      #0,lock
                            
skip_un:                            
;**************************************************************
                                                       
END_RTI:      movb      #$80, CRGFLG 
              rti
;*********************************************************************