player_draw:
    ldx oamindex
    
    lda nmicounter
    bit inverse_bitmasks+2
    bne ++
    
    lda player_animframe
    clc
    adc #$01
    sta player_animframe
    cmp #$09
    bne +
    
    lda #$00
    sta player_animframe
    
    +
    clc
    adc #$20
    sta oambuffer+1,x       ;tile index
    
    ++
    
    lda player_y
    sta oambuffer+0,x       ;y position
    
    
    lda #%00000000
    sta oambuffer+2,x       ;attributes
    
    lda player_x
    sta oambuffer+3,x       ;x position
    
    inx
    inx
    inx
    inx
    stx oamindex
    
    rts
    
    
player_input:
    ;a = controller bits
    beq nobuttons
    
    bit button_L
    beq +
        ;if left pressed:
        pha
        
        lda player_x_subspeed
        sec
        sbc #$40
        sta player_x_subspeed
        
        lda player_x_speed
        sbc #$00
        cmp #player_maxspeed_negative    ;cmp #-player_maxspeed
        bmi ++
        sta player_x_speed
        ++
        pla
    +
    
    bit button_R
    beq +
        ;if right pressed:
        pha
        
        lda player_x_subspeed
        clc
        adc #$40
        sta player_x_subspeed
        
        lda player_x_speed
        adc #$00
        cmp #player_maxspeed
        bpl ++
        sta player_x_speed
        ++
        pla
    +
    
    bit button_D
    beq +
        ;if down pressed:
        pha
        
        lda player_y_subspeed
        clc
        adc #$40
        sta player_y_subspeed
        
        lda player_y_speed
        adc #$00
        cmp #player_maxspeed
        bpl ++
        sta player_y_speed
        ++
        pla
    +
    
    bit button_U
    beq +
        ;if up pressed:
        pha
        
        lda player_y_subspeed
        sec
        sbc #$40
        sta player_y_subspeed
        
        lda player_y_speed
        sbc #$00
        cmp #player_maxspeed_negative       ;cmp #-player_maxspeed
        bmi ++
        sta player_y_speed
        ++
        pla
    +
    
    bit button_B
    beq +
        ;if B pressed:
        pha
        
        lda #$00
        sta player_x_speed
        sta player_y_speed
        
        sta player_x_subspeed
        sta player_y_subspeed
        
        pla
    +
    
    bit button_A
    beq +
        ;if A pressed:
        pha
        
        ;fire shot
        ldx #<shot                  ;id lo
        ldy #>shot                  ;id hi
        jsr fae_spawn_findslot
        
        pla
    +
    
    nobuttons:
    
    rts
    
playerrandomizemovement:
    ;pretty much nonsense
    ;not used
    
    lda controller
    bit button_A
    beq +
    
    ;lda nmicounter
    ;bne +
    
    lda player_x
    eor player_y
    sta p_1
    
    lda player_x_subspeed
    eor player_y_subspeed
    eor p_1
    and #%00000010
    ora #$01
    sta p_0
    
    ;if nmicounter rolled over,
    lda player_x_speed
    eor p_0
    sta player_x_speed
    
    lda player_y_speed
    eor p_0
    sta player_y_speed
    
    +
    rts
    
player_move:
    ;..y
    lda player_suby
    clc
    adc player_y_subspeed
    sta player_suby
    
    lda player_y
    adc player_y_speed
    sta player_y
        
    ;..x
    lda player_subx
    clc
    adc player_x_subspeed
    sta player_subx
    
    lda player_x
    adc player_x_speed
    sta player_x
    
    rts
    
    
player_bounds_check:       
    lda player_x             ;left bound
    cmp #$04
    bcc +
        lda player_x_speed
        eor #$ff
        clc
        adc #$01
        sta player_x_speed
    +
    
    lda player_x             ;right bound
    cmp #$e8
    bcs +
        lda player_x_speed
        eor #$ff
        clc
        adc #$01
        sta player_x_speed
    +
    
    lda player_y             ;top bound
    cmp #$04
    bcc +
        lda player_y_speed
        eor #$ff
        clc
        adc #$01
        sta player_y_speed
    +
    
    lda player_y             ;bottom bound
    cmp #$e0
    bcs +
        lda player_y_speed
        eor #$ff
        clc
        adc #$01
        sta player_y_speed
    +
    
    rts

;debugwritecollisionindexdebug:
;    ldx nmicounter
;    
;    lda playercollisionindex
;    sta collisionindexseries,x
;    
;    rts


player_collision:
    ;((player_y/16)*16 + (player_x/16)
    lda player_y
    and #$f0
    sta p_0
    
    lda player_x
    lsr
    lsr
    lsr
    lsr
    
    clc
    adc p_0
    
    sta player_collisionindex
    
    tax
    lda collision,x
    beq +
    
    sta player_collisiontype
    
    and #$f0
    lsr
    lsr
    lsr
    tax         ;for indexing table of words
    
    lda #collisionfunctions,x
    sta p_4
    lda #collisionfunctions+1,x
    sta p_5
    
    jmp (p_4)
    
    +
    rts
    
collisionfunctions:
    ;top nibble of collision byte indexes this
    ;bottom nibble can be passed as an argument
    ;read from playercollisiontype to get bottom nibble if desired
    
    dw air      ;00
    dw wall     ;10
    dw gem      ;20
    dw test     ;30

test:
    lda player_x_subspeed
    sta p_0
    
    lda player_y_subspeed
    eor player_y
    sta player_x_subspeed
    
    lda p_0
    eor player_x
    sta player_y_subspeed
    
    rts

gem:
    lda player_x_speed
    sta p_0
    
    lda player_y_speed
    sta p_1
    
    lda p_0
    eor #$ff
    sta player_y_speed
    
    lda p_1
    eor #$ff
    sta player_x_speed
    
    rts
    
air:
    ;maybe could want to do something here but maybe not
    ;could skip with beq above
    rts
    
wall:
    lda player_collisiontype
    and #$0f
    
    bit button_L
    beq +
        ;if wall moves player to the left,
        pha
        
        lda player_x
        sec
        sbc #$01
        sta player_x
        
        lda player_x_speed
        eor #$ff
        clc
        adc #$01
        sta player_x_speed
        
        pla
    +
    
    bit button_R
    beq +
        ;if wall moves player to the right,
        pha
        
        lda player_x
        clc
        adc #$01
        sta player_x
        
        lda player_x_speed
        eor #$ff
        clc
        adc #$01
        sta player_x_speed
        
        pla
    +
    
    bit button_U
    beq +
        ;if wall moves player to the up,
        pha
        
        lda player_y
        sec
        sbc #$01
        sta player_y
        
        lda player_y_speed
        eor #$ff
        clc
        adc #$01
        sta player_y_speed
        
        pla
    +
    
    bit button_D
    beq +
        ;if wall moves player to the down,
        pha
        
        lda player_y
        clc
        adc #$01
        sta player_y
        
        lda player_y_speed
        eor #$ff
        clc
        adc #$01
        sta player_y_speed
        
        pla
    +
    
    rts
    