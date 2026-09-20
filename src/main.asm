
;there's no BIT #immediate so it's worth it to bake this into the rom
;at least for the controller checks. possibly for other things
;also, the assembler (asm6f) can't emit a label at $8000 for some reasom,
;so we need something else at the start of the rom instead of one of the 
;vectors. so yeah here we arrive at this being the first thing in the rom

bitmasks:
button_R:
    db $01
button_L:
    db $02
button_D:
    db $04
button_U:
    db $08
button_ST:
    db $10
button_SL:
    db $20
button_B:
    db $40
button_A:
    db $80
    
inverse_bitmasks:
    db $01      ;0
    db $03      ;1
    db $07      ;2
    db $0f      ;3
    db $1f      ;4
    db $3f      ;5
    db $7f      ;6
    db $ff      ;7

; ======================================= interrupts =======================================

nmi:
    pha
    
    txa
    pha
    
    tya
    pha
    
    ;nmi stuff goez here:
    
    ;handle ppu write queue ===============================================
    lda ppu_queue_flag
    beq ++
    
    ldx #tobj_count
    
    -
    lda tobj_id_hi,x
    beq +
    
    
    lda ppu_queue_addr_hi,x
    sta $2006
    lda ppu_queue_addr_lo,x
    sta $2006
    lda ppu_queue_byte,x
    sta $2007
    
    +
    dex
    bpl -
    
    lda #$00
    sta ppu_queue_flag
    ++
    
    ;ppu buffer ========================================================
    
    lda rendersettings
    sta $2001
    
    ;fire dma for oam buffer ===========================================
    lda #>oambuffer
    sta $4014
    
    ;read controller ===================================================
    ;example from wiki
    lda #$01
    sta $4016
    sta controller
    
    lda #$00
    sta $4016
    
    -
    lda $4016
    lsr a
    rol controller
    bcc -
    
    ;ppu graphics buffer ===============================================
    lda gfxbuffer_size
    beq +
    
    lda gfxbuffer_target
    sta $2006
    lda gfxbuffer_target+1
    sta $2006       ;ppu addr
    
    tsx
    stx p_0         ;main stack ptr
    
    ldx #<gfxbuffer
    txs
    
    -
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    pla
    sta $2007
    
    dec gfxbuffer_size
    bne -
    
    ldx p_0         ;restore main stack ptr
    txs
    
    +
    
    ;bg scrolls ========================================================
    lda bgxscroll
    sta $2005
    
    lda bgyscroll
    sta $2005
    
    lda ppuctrl
    sta $2000
    
    inc nmicounter
    
    lda #$00
    sta nmiflag
    
    pla
    tay
    
    pla
    tax
    
    pla
    
    rti
    
irq:
    rti

; ========================================== boot ==========================================

boot:
    ;example from wiki
    sei
    cld
    
    ldx #$40
    stx $4017
    
    ldx #$ff
    txs
    
    inx                     ;x = 0
    
    stx $2000               ;disable nmi
    stx $2001               ;disable rendering
    stx $4010               ;disable DMC irq
    
    bit $2002               ;why? who knows! A isn't in a known state
    
    -
    bit $2002               ;wait for vblank
    bpl -
    
clearram:
    ;x = 0 from above
    lda #$00
    -
    sta $0000,x
    sta $0100,x
    sta $0200,x
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    dex
    bne -
    
    lda #state_setup
    sta programstate
    sta rendersettings
    
    lda #$00
    sta ppu_queue_flag
    sta nmiflag
    
    -
    bit $2002               ;wait for vblank
    bpl -
    
    lda #$80                ;enable nmi
    sta $2000
    sta ppuctrl
    
    
    ;fall through to main

; ========================================== main ==========================================

main:
    ;you know, the program
    
    lda #$01
    sta nmiflag
    ;bit $2002          ;uncomment to show cpu on event viewer
    -
    lda nmiflag
    bne -
    
    lda programstate
    asl
    tax
    
    lda states,x
    sta p_4
    
    lda states+1,x
    sta p_5
    
    lda #>main              ;set return address hi byte
    pha
    
    lda #<main-1            ;lo byte
    pha
    
    jmp (p_4)
    
states:
    ;don't forget to make a corresponding define in defines.asm
    dw setup                ;0 - initial program setup
    dw loadscene            ;1 - load graphics, tilemap, palettes
    dw setupgame            ;2 - set up for gampleay; init player etc
    dw gameplay             ;3 - play the game

; ==================================== top-level states ====================================
   
    
setup:
    ;init player
    lda #$d8
    sta player_x
    
    lda #$10
    sta player_y
    
    lda #$00
    sta bgxscroll
    sta bgyscroll
    
    lda #scene_pee
    sta sceneindex
    
    lda #state_loadscene
    sta programstate        ;return with next state
    
    rts
    
    
loadscene:
    ;top level state which loads graphics, tilemap, palette to ppu
    ;expects sceneindex to be set
    ;proceeds to next state
    
    ;used in routine:
    ;p_8 = backup of sceneindex*2
    
    lda sceneindex
    asl
    tax
    sta p_8
    
    ;load graphics from list
    
    lda scene_gfxlist+1,x
    tay
    
    lda scene_gfxlist,x
    tax
    
    lda #$04                ;size in number of $100 pages
    jsr uploadchr
    
    ;load tilemap from list
    
    ldx p_8
    
    lda scene_maplist+1,x
    tay
    
    lda scene_maplist,x
    tax
    
    lda #$04
    jsr uploadmap
    
    ;load palette from list
    
    ldx p_8
    
    lda scene_pallist+1,x
    tay
    
    lda scene_pallist,x
    tax
    
    jsr uploadpalette
    
    ;get collision map pointer
    
    ldx p_8
    
    lda scene_collisionlist,x
    sta collision_map_ptr
    
    lda scene_collisionlist+1,x
    sta collision_map_ptr+1
    
    ;fae list (unimplemented)
    
    lda scene_faelist,x
    sta faelist_ptr
    
    lda scene_faelist+1,x
    sta faelist_ptr+1
    
    ;tile object list (implemented)
    
    lda scene_tobjlist,x
    sta tobjlist_ptr
    
    lda scene_tobjlist+1,x
    sta tobjlist_ptr+1
    
    ;
    
    lda #state_setupgame
    sta programstate        ;proceed to next state
    
    rts
    
    
setupgame:
    ;do stuff
    
    lda #$00
    sta oamindex
    
    jsr tilemap_obj_clearall        ;clear tilemap objects
    jsr tilemap_obj_spawnall
    jsr tilemap_obj_handle          ;handle tilemap objects
    
    jsr player_draw
    
    jsr fae_clearall
    
    ldx #<mirror_gem                ;id lo
    ldy #>mirror_gem                ;id hi
    jsr fae_spawn_findslot
    
    jsr fae_handleall
    
    ldx #fae_count
    jsr fae_draw                    ;draw fae (first slot test)
    
    lda #%00011110
    sta rendersettings              ;enable background and sprite rendering at next nmi
    
    lda #state_gameplay
    sta programstate                ;return with next state
    
    rts
    
    
scene_gfxlist:
    dw test_gfx         ;0
    dw test_gfx         ;1
    dw test_gfx         ;2
    dw test_gfx         ;3
    
scene_maplist:
    dw water_map        ;0
    dw pipes_map        ;1
    dw hair_map         ;2
    dw pee_map          ;3
    
scene_pallist:
    dw test_pal         ;0
    dw test_pal         ;1
    dw test_pal         ;2
    dw test_pal         ;3

scene_collisionlist:
    dw water_collision  ;0
    dw pipes_collision  ;1
    dw hair_collision   ;2
    dw pee_collision    ;3
    
scene_faelist:          ;(unimplemented)
    dw faelist_water    ;0
    dw faelist_pipes    ;1
    dw faelist_hair     ;2
    dw faelist_pee      ;3
    
scene_tobjlist:
    dw tobjlist_water   ;0
    dw tobjlist_pipes   ;1
    dw tobjlist_hair    ;2
    dw tobjlist_pee     ;3
    

;======================================= ppu routines ======================================

uploadmap:
    ;A = number of $100 byte pages to upload
    
    ;sets ppu address to $2000 for tilemap
    ;then jumps to the common portion for upload
    sta p_3
    
    lda #$20                ;ppu address = $2000
    sta $2006
    lda #$00
    sta $2006
    
    beq uploadtoppu         ;a happens to have just set the zero flag :)

uploadchr:
    ;A = number of $100 byte pages to upload
    
    sta p_3
    
    lda #$00                ;ppu address = $0000
    sta $2006
    sta $2006
    
    ;jmp uploadcommon
    
uploadtoppu:
    ;arguments:
    ;x = ptr lo byte
    ;y = ptr hi byte
    ;expects $2006 to have been set already
    
    ;used in routine:
    ;p_0 = lo byte of pointer
    ;p_1 = hi byte of pointer
    ;p_2 = counter
    ;p_3 = size, number of $100 bytes pages
    
    stx p_0
    sty p_1
    
    ldy #$00
    sty p_2                 ;init loop counter
    
    ;loop
    -
    lda (p_0),y
    sta $2007               ;stuff into ppu hole
    
    iny
    bne -
    
    inc p_1
    
    lda p_2
    clc
    adc #$01
    sta p_2
    
    cmp p_3                 ;check page size for limit reached
    bne -
    
    rts

uploadpalette:
    ;x = lo byte of ptr
    ;y = hi byte of ptr
    ;fixed size $20 bytes
    
    sty p_1                 ;p_0-p_1 = ptr to palette
    stx p_0
    
    lda #$3f                ;ppu address = $3f00
    sta $2006
    lda #$00
    sta $2006
    
    tay                     ;y = 0
    
    -
    lda (p_0),y
    sta $2007
    
    iny
    cpy #$1f                ;fixed size
    bne -
    
    rts

setupgfxbuffer:
    ;p_0 = ptr to source
    ;a   = size in $10 byte tiles
    ;x   = ppu destination lo
    ;y   = ppu destination hi
    
    stx gfxbuffer_target
    sty gfxbuffer_target+1
    sta gfxbuffer_size
    
    asl
    asl
    asl
    asl
    tay
    
    -
    lda (p_0),y
    sta gfxbuffer,y
    dey
    bpl -
    
    rts
    