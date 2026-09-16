gameplay:
    lda controller
    jsr playerinput
    
    lda controller
    bit button_SL
    bne +
    lda #$00
    sta oamindex
    +
    
    lda #$00
    sta ppu_queue_flag
    
    jsr playermove
    jsr playercollision
    jsr playerdraw
    
    
    ;=====================================test harness
    ;lda controller
    ;bit button_A
    ;beq +
    
    lda nmicounter
    sta p_0
    lda #$80        ;rom src = $8100-81ff
    sta p_1
    
    ldx #$00        ;x/y, ppu destination = 0090
    ldy #$90
    
    lda #$01        ;size = 1 tile
    jsr setupgfxbuffer
    
    +
    
    ;==================================================
    
    jsr tilemap_obj_handle
    
    
    rts

oamfillbuffer:
    ;not implemented yet
    
    ldx oamindex
    lda #$f0
    -
    sta oambuffer,x
    inx
    bne -
    
    rts

;    
;handleinput:
;    lda controller
;    beq nobuttons
;    
;    bit button_L
;    beq +
;        ;if left pressed:
;        pha
;        lda #scrolldirection_left
;        sta scrolldirection
;        pla
;    +
;    
;    bit button_R
;    beq +
;        ;if right pressed:
;        pha
;        lda #scrolldirection_right
;        sta scrolldirection
;        pla
;    +
;    
;    bit button_D
;    beq +
;        ;if down pressed:
;        pha
;        lda #scrolldirection_down
;        sta scrolldirection
;        pla
;    +
;    
;    bit button_U
;    beq +
;        ;if up pressed:
;        pha
;        lda #scrolldirection_up
;        sta scrolldirection
;        pla
;    +
;    
;    nobuttons:
;    rts

;
;handlescrolling:
;    lda scrolldirection
;    tax
;    
;    lda scrollfunctions,x
;    sta p_4
;    
;    lda scrollfunctions+1,x
;    sta p_5
;    
;    jmp (p_4)
;    ;routines return to gameplay;;;
;

;scrollfunctions:
;    dw noscroll
;    dw scrollleft
;    dw scrollright
;    dw scrolldown
;    dw scrollup


;noscroll:
;    rts


;scrolldown:
;    lda bgysubscroll
;    sec
;    sbc #$80
;    sta bgysubscroll
;    
;    lda bgyscroll
;    sbc #$00
;    sta bgyscroll
;    
;    rts


;scrollup:
;    lda bgysubscroll
;    clc
;    adc #$80
;    sta bgysubscroll
;    
;    lda bgyscroll
;    adc #$00
;    sta bgyscroll
;    
;    rts


;scrollright:
;    lda bgxsubscroll
;    sec
;    sbc #$80
;    sta bgxsubscroll
;    
;    lda bgxscroll
;    sbc #$00
;    sta bgxscroll
;    
;    rts
    

;scrollleft:
;    lda bgxsubscroll
;    clc
;    adc #$80
;    sta bgxsubscroll
;    
;    lda bgxscroll
;    adc #$00
;    sta bgxscroll
;    
;    rts
    