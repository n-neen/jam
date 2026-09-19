    
shot:
    dw shot_spritemap           ;spritemap pointer
    dw shot_routine             ;main routine pointer
    dw shot_init                ;init routine pointer
    db $04                      ;x radius
    db $04                      ;y radius
    
    
shot_init:
    ;x = fae index
    lda shot_active
    bne +
    
    lda player_x
    sta fae_x,x
    
    lda player_y
    sta fae_y,x
    
    lda player_x_speed
    sta shot_x_speed
    
    lda player_y_speed
    
    sta shot_y_speed
    
    lda #$01
    sta shot_active
    
    rts
    
    +
    jsr fae_clear
    rts


shot_routine:
    ;x = fae index
    
    lda fae_timer,x
    clc
    adc #$01
    sta fae_timer,x
    
    cmp #$40
    beq shot_routine_delete
    
    lda fae_x,x
    clc
    adc shot_x_speed
    sta fae_x,x
    
    lda fae_y,x
    clc
    adc shot_y_speed
    sta fae_y,x
    
    rts
    
    
    shot_routine_delete:
        jsr fae_clear
        lda #$00
        sta shot_active
        
        rts
    
    
shot_spritemap:
    ;number of sprites
    db $04
       ;xx,  tt, attributs,  yy
    db $fe, $06, %00000000, $fe
    db $fe, $06, %00000001, $02
    
    db $02, $06, %00000010, $fe
    db $02, $06, %00000011, $02
