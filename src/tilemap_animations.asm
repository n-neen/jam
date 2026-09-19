;still need:
;init routines
;spawn routine which finds a slot


tilemap_obj_clear:
    ;x = object index
    
    lda #$00
    
    sta tobj_id_hi,x
    sta tobj_id_lo,x
    sta tobj_x,x
    sta tobj_y,x
    sta tobj_instptr_hi,x
    sta tobj_instptr_lo,x
    sta tobj_timer,x
    
    rts
    
tilemap_obj_clearqueue:
    ;x = obj index
    
    lda #$00
    
    sta ppu_queue_addr_hi,x
    sta ppu_queue_addr_lo,x
    sta ppu_queue_byte,x
    
    rts
    
tilemap_obj_clearall:
    ldx #tobj_count
    
    -
    jsr tilemap_obj_clear
    dex
    bpl -
    
    rts

tilemap_obj_handle:
    ldx #tobj_count
    
    -
    lda tobj_id_hi,x
    beq +
    
    lda tobj_routine_lo,x
    sta p_4
    
    lda tobj_routine_hi,x                    ;set jmp pointer
    sta p_5
    
    lda #>tilemap_obj_routine_return
    pha
    lda #<tilemap_obj_routine_return-1       ;set return address
    pha
    
    jmp (p_4)                               ;run routine
    
    tilemap_obj_routine_return:
    
    jsr tilemap_obj_write                   ;write
    
    
    +
    dex
    bpl -
    
    rts
    
    
tilemap_obj_write:
    ;x = tilemap object index
    
    ;tilemap index =
    ;objy*32 + objx
    
    lda #$00
    sta p_1
    
    lda tobj_y,x
    cmp #$ff
    beq tilemap_obj_write_end
    sta p_0
    
    clc
    
    rol p_0
    rol p_0
    rol p_0
    rol p_1
    
    rol p_0
    rol p_1
    
    rol p_0
    rol p_1
    
    lda p_0
    clc
    adc tobj_x,x
    sta p_0
    
    lda p_1
    clc
    adc #$20
    sta ppu_queue_addr_hi,x     ;ppu addr hi byte = $20 + high nibble of tilemap index
    lda p_0
    sta ppu_queue_addr_lo,x     ;ppu addr lo byte = lo nibble of tilemap index
    
    lda tobj_instptr_lo,x       ;byte to write
    sta ppu_queue_byte,x
    
    lda #$01
    sta ppu_queue_flag
    
    tilemap_obj_write_end:
    rts
    
    
tilemap_obj_spawnall:
    lda tobjlist_ptr
    sta p_0
    
    lda tobjlist_ptr+1
    sta p_1
    
    ldx #tobj_count
    
    -
    ldy #$00
    
    lda (p_0),y     ;lo byte of tilemap object id
    sta p_2
    
    iny
    
    lda (p_0),y     ;hi byte
    sta p_3
    
    cmp #$ff        ;terminator. only care about hi byte
    beq tobj_spawnall_end
    
    jsr tilemap_obj_spawn
    
    lda p_0
    clc
    adc #tobj_list_entry_length
    sta p_0
    
    lda p_1
    adc #$00
    sta p_1
    
    dex
    
    bpl -
    
    tobj_spawnall_end:
    rts
    
    
tilemap_obj_spawn:
    ;p_0 = tobj list ptr lo
    ;p_1 = tobj list ptr hi
    ;p_2 = object id lo
    ;p_3 = object id hi
    ;x = tilemap object index
    
    lda p_2
    sta tobj_id_lo,x
    
    lda p_3
    sta tobj_id_hi,x
    
    ldy #$02
    lda (p_0),y
    
    sta tobj_x,x
    
    iny
    
    lda (p_0),y
    sta tobj_y,x
    
    lda p_2
    clc
    adc #tobj_header_length
    sta p_2
    sta tobj_routine_lo,x
    
    lda p_3
    adc #$00
    sta p_3
    sta tobj_routine_hi,x
    
    jmp (p_2)
    
    
spawntestobj:
    ;deprecated
    
    
    ;test harness =============
    
    ;x = obj index
    ;a = obj x
    ;y = obj y
    
    ;ldx #$10                ;obj index
    
    sta tobj_x,x
    
    tya
    sta tobj_y,x
    
    lda #water_obj+1
    sta tobj_id_hi,x
    sta p_0
    
    lda #water_obj
    sta tobj_id_lo,x
    sta p_1
    
    lda p_0
    sta tobj_routine_lo,x
    
    lda p_1
    sta tobj_routine_hi,x
    
    rts
    
    
animated_tile_obj:
    dw animated_tile_routine

    animated_tile_routine:
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
        rts
    
    
    
water_obj:
    ;if you add pointers here you need to modify the adc in spawn routine
    dw testtobj_routine
    
    testtobj_routine:
        ;x = obj index
        
        lda nmicounter
        bit inverse_bitmasks+1
        bne ++
        
        lda tobj_timer,x
        clc
        adc #$01
        sta tobj_timer,x
        
        cmp #$05
        bne +
        
        lda #$00
        sta tobj_timer,x
        
        +
        
        tay
        
        lda testtobj_animationframes,y
        sta tobj_instptr_lo,x
        
        lda tobj_x,x
        clc
        adc #$01
        sta tobj_x,x
        
        cmp #$20
        bne +
        
        lda #$00
        sta tobj_x,x
        +
        
        
        
        ++
        rts
        
    testtobj_animationframes:
        db $31, $33, $34, $33, $34, $33