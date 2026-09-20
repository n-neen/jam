    
mirror_gem:
    dw mirror_gem_spritemap     ;spritemap pointer
    dw mirror_gem_routine       ;main routine pointer
    dw mirror_gem_init          ;init routine pointer
    db $04                      ;x radius
    db $04                      ;y radius
    
    
mirror_gem_init:
    ;x = fae index
    
    lda #$7d
    sta fae_x,x
    
    lda #$80
    sta fae_y,x
    
    rts


mirror_gem_routine:
    lda fae_timer,x
    clc
    adc #$01
    sta fae_timer,x
    
    cmp #$08
    bne +
    
    lda #$00
    sta fae_timer,x
    +
    
    
    lda player_x
    eor #$ff
    clc
    adc #$f8
    sta fae_x,x
    
    lda player_y
    eor #$ff
    clc
    adc #$e8
    sta fae_y,x
    
    rts
    
    
mirror_gem_spritemap:
    mirror_gem_spritemap_0:
        ;number of sprites
        db $01
           ;xx,  tt, attributs,  yy
        db $00, $06, %00000010, $00
