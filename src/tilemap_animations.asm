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
    
    rts
    
spawntestobj:
    ;test harness =============
    
    ;x = obj index
    ;a = obj x
    ;y = obj y
    
    ;ldx #$10                ;obj index
    
    sta tobj_x,x
    
    tya
    sta tobj_y,x
    
    lda #testtobj+1
    sta tobj_id_hi,x
    sta p_0
    
    lda #testtobj
    sta tobj_id_lo,x
    sta p_1
    
    lda (p_0)
    sta tobj_routine_hi,x
    
    lda (p_1)
    sta tobj_routine_lo,x
    
    ;jsr tilemap_obj_write
    ;jsr tilemap_obj_spawn
    
    ;==========================
    
    rts
    
testtobj:
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
        db $34, $35, $36, $37, $38, $39