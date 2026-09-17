gameplay:
    lda controller
    jsr playerinput
    
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
    
    jsr playermove
    jsr playercollision
    jsr playerdraw
    
    
    ;=====================================test harness animated tile object
    ;lda controller
    ;bit button_A
    ;beq +
    
    lda nmicounter
    bit inverse_bitmasks+2
    bne +
    sta p_0
    lda #$81        ;rom src = $8100-81ff
    sta p_1
    
    ldx #$01        ;x/y, ppu destination = 0090
    ldy #$30
    
    lda #$02        ;size = 2 tiles
    jsr setupgfxbuffer
    
    +
    
    ;==================================================
    
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
