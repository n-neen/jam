gameplay:
    lda controller
    jsr player_input
    
    ;lda controller     ;this doesn't wok anymore cause of oamfillbuffer :[
    ;bit button_SL
    ;bne +
    ;lda #$00
    ;sta oamindex
    ;+
    
    lda #$00
    sta oamindex
    
    lda #$00
    sta ppu_queue_flag
    
    jsr player_move
    jsr player_collision
    jsr player_draw
    
    jsr fae_handleall
    jsr fae_drawall
    
    jsr tilemap_obj_handle
    
    jsr oamfillbuffer
    
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
