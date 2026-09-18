fae_clear:
    ;x = fae index
    
    lda #$00
    
    sta fae_id_hi,x
    sta fae_id_lo,x
    sta fae_x,x
    sta fae_xradius,x
    sta fae_y,x
    sta fae_yradius,x
    sta fae_drawptr_hi,x
    sta fae_drawptr_lo,x
    sta fae_routine_lo,x
    sta fae_routine_hi,x
    sta fae_init_hi,x
    sta fae_init_lo,x
    sta fae_timer,x
    
    rts
    
    
fae_clearall:
    ldx #fae_count
    
    -
    jsr fae_clear
    dex
    bne -
    
    rts
    
    
fae_handleall:
    ldx #fae_count
    
    -
    lda fae_id_hi,x
    beq +
    jsr fae_handle
    +
    dex
    bne -
    
    rts
    
    
fae_handle:
    ;x = fae index
    
    lda fae_routine_lo,x
    sta (p_4)
    
    lda fae_routine_hi,x
    sta (p_5)
    
    jmp (p_4)
    ;tail call opt ^
    
    
fae_drawall:
    ldx #fae_count
    
    -
    lda fae_id_hi,x
    beq +
    jsr fae_draw
    +
    dex
    bne -
    
    rts
    
    
fae_draw:
    ;x = fae index
    
    txa
    pha
    
    ldy #$00
    
    lda fae_drawptr_lo,x
    sta p_0
    
    lda fae_drawptr_hi,x
    sta p_1
    
    lda fae_x,x
    sta p_2
    
    lda fae_y,x
    sta p_3
    
    ldx oamindex
    
    lda (p_0),y         ;number of tiles
    sta p_4
    iny
    
    ;write buffer:
    
    fae_draw_loop:
    
    lda (p_0),y
    clc
    adc p_3
    sta oambuffer+0,x       ;y pos
    
    iny
    
    lda (p_0),y
    sta oambuffer+1,x       ;tile
    
    iny
    
    lda (p_0),y
    sta oambuffer+2,x       ;attributes
    
    iny
    
    lda (p_0),y
    clc
    adc p_2
    sta oambuffer+3,x       ;x pos
    
    iny
    
    inx
    inx
    inx
    inx
    
    dec p_4
    bne fae_draw_loop
    
    stx oamindex
    
    pla
    tax
    
    rts
    
fae_spawn_test:
    ;callsite:
    ldx #<testfae       ;id lo
    ldy #>testfae       ;id hi
    lda #fae_count      ;fae index
    
    ;spawn routine:
    
    stx p_0
    sty p_1
    
    ldy #$00
    tax
    
    lda p_0
    sta fae_id_lo,x
    
    lda p_1
    sta fae_id_hi,x
    
    lda (p_0),y
    sta fae_drawptr_lo,x
    iny
    
    lda (p_0),y
    sta fae_drawptr_hi,x
    iny
    
    lda (p_0),y
    sta fae_routine_lo,x
    iny
    
    lda (p_0),y
    sta fae_routine_hi,x
    iny
    
    lda (p_0),y
    sta fae_init_lo,x
    sta p_4
    iny
    
    lda (p_0),y
    sta fae_init_hi,x
    sta p_5
    iny
    
    lda (p_0),y
    sta fae_xradius,x
    iny
    
    lda (p_0),y
    sta fae_yradius,x
    iny
    
    jmp (p_4)               ;run init routine. returns to our caller
    
    ;rts
    
    
testfae:
    dw testfae_spritemap        ;spritemap pointer
    dw testfae_routine          ;main routine pointer
    dw testfae_init             ;init routine pointer
    db $04                      ;x radius
    db $04                      ;y radius
    
    
testfae_init:
    ;x = fae index
    
    lda #$7d
    sta fae_x,x
    
    lda #$80
    sta fae_y,x
    
    rts


testfae_routine:
    lda fae_timer,x
    clc
    adc #$01
    sta fae_timer,x
    
    cmp #$08
    bne +
    
    lda #$00
    sta fae_timer,x
    +
    
    
    lda playerx
    eor #$ff
    clc
    adc #$01
    sta fae_x,x
    
    lda playery
    eor #$ff
    clc
    adc #$01
    sta fae_y,x
    
    rts
    
    
testfae_spritemap:
    testfae_spritemap_0:
        ;number of sprites
        db $01
           ;xx,  tt, attributs,  yy
        db $00, $06, %00000010, $00
