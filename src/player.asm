player_draw:
    ldx oamindex
    
    lda nmicounter
    bit inverse_bitmasks+2
    bne ++
    
    lda playeranimframe
    clc
    adc #$01
    sta playeranimframe
    cmp #$09
    bne +
    
    lda #$00
    sta playeranimframe
    
    +
    clc
    adc #$20
    sta oambuffer+1,x       ;tile index
    
    ++
    
    lda playery
    sta oambuffer+0,x       ;y position
    
    
    lda #%00000000
    sta oambuffer+2,x       ;attributes
    
    lda playerx
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
        
        lda playerxsubspeed
        sec
        sbc #$40
        sta playerxsubspeed
        
        lda playerxspeed
        sbc #$00
        cmp #player_maxspeed_negative    ;cmp #-player_maxspeed
        bmi ++
        sta playerxspeed
        ++
        pla
    +
    
    bit button_R
    beq +
        ;if right pressed:
        pha
        
        lda playerxsubspeed
        clc
        adc #$40
        sta playerxsubspeed
        
        lda playerxspeed
        adc #$00
        cmp #player_maxspeed
        bpl ++
        sta playerxspeed
        ++
        pla
    +
    
    bit button_D
    beq +
        ;if down pressed:
        pha
        
        lda playerysubspeed
        clc
        adc #$40
        sta playerysubspeed
        
        lda playeryspeed
        adc #$00
        cmp #player_maxspeed
        bpl ++
        sta playeryspeed
        ++
        pla
    +
    
    bit button_U
    beq +
        ;if up pressed:
        pha
        
        lda playerysubspeed
        sec
        sbc #$40
        sta playerysubspeed
        
        lda playeryspeed
        sbc #$00
        cmp #player_maxspeed_negative       ;cmp #-player_maxspeed
        bmi ++
        sta playeryspeed
        ++
        pla
    +
    
    bit button_B
    beq +
        ;if B pressed:
        pha
        
        lda #$00
        sta playerxspeed
        sta playeryspeed
        
        sta playerxsubspeed
        sta playerysubspeed
        
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
    
    lda playerx
    eor playery
    sta p_1
    
    lda playerxsubspeed
    eor playerysubspeed
    eor p_1
    and #%00000010
    ora #$01
    sta p_0
    
    ;if nmicounter rolled over,
    lda playerxspeed
    eor p_0
    sta playerxspeed
    
    lda playeryspeed
    eor p_0
    sta playeryspeed
    
    +
    rts
    
player_move:
    ;..y
    lda playersuby
    clc
    adc playerysubspeed
    sta playersuby
    
    lda playery
    adc playeryspeed
    sta playery
        
    ;..x
    lda playersubx
    clc
    adc playerxsubspeed
    sta playersubx
    
    lda playerx
    adc playerxspeed
    sta playerx
    
    rts
    
    
player_bounds_check:       
    lda playerx             ;left bound
    cmp #$04
    bcc +
        lda playerxspeed
        eor #$ff
        clc
        adc #$01
        sta playerxspeed
    +
    
    lda playerx             ;right bound
    cmp #$e8
    bcs +
        lda playerxspeed
        eor #$ff
        clc
        adc #$01
        sta playerxspeed
    +
    
    lda playery             ;top bound
    cmp #$04
    bcc +
        lda playeryspeed
        eor #$ff
        clc
        adc #$01
        sta playeryspeed
    +
    
    lda playery             ;bottom bound
    cmp #$e0
    bcs +
        lda playeryspeed
        eor #$ff
        clc
        adc #$01
        sta playeryspeed
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
    ;((playery/16)*16 + (playerx/16)
    lda playery
    and #$f0
    sta p_0
    
    lda playerx
    lsr
    lsr
    lsr
    lsr
    
    clc
    adc p_0
    
    sta playercollisionindex
    
    tax
    lda collision,x
    beq +
    
    sta playercollisiontype
    
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
    lda playerxsubspeed
    sta p_0
    
    lda playerysubspeed
    eor playery
    sta playerxsubspeed
    
    lda p_0
    eor playerx
    sta playerysubspeed
    
    rts

gem:
    lda playerxspeed
    sta p_0
    
    lda playeryspeed
    sta p_1
    
    lda p_0
    eor #$ff
    sta playeryspeed
    
    lda p_1
    eor #$ff
    sta playerxspeed
    
    rts
    
air:
    ;maybe could want to do something here but maybe not
    ;could skip with beq above
    rts
    
wall:
    lda playercollisiontype
    and #$0f
    
    bit button_L
    beq +
        ;if wall moves player to the left,
        pha
        
        lda playerx
        sec
        sbc #$01
        sta playerx
        
        lda playerxspeed
        eor #$ff
        clc
        adc #$01
        sta playerxspeed
        
        pla
    +
    
    bit button_R
    beq +
        ;if wall moves player to the right,
        pha
        
        lda playerx
        clc
        adc #$01
        sta playerx
        
        lda playerxspeed
        eor #$ff
        clc
        adc #$01
        sta playerxspeed
        
        pla
    +
    
    bit button_U
    beq +
        ;if wall moves player to the up,
        pha
        
        lda playery
        sec
        sbc #$01
        sta playery
        
        lda playeryspeed
        eor #$ff
        clc
        adc #$01
        sta playeryspeed
        
        pla
    +
    
    bit button_D
    beq +
        ;if wall moves player to the down,
        pha
        
        lda playery
        clc
        adc #$01
        sta playery
        
        lda playeryspeed
        eor #$ff
        clc
        adc #$01
        sta playeryspeed
        
        pla
    +
    
    rts
    