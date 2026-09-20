enum $0000              ;pseudoregisters 0-8
    p_0 dsb 1
    p_1 dsb 1
    p_2 dsb 1
    p_3 dsb 1
    p_4 dsb 1
    p_5 dsb 1
    p_6 dsb 1
    p_7 dsb 1
    p_8 dsb 1
ende

enum $0009              ;9-f
    ;program state, associated variables
    
    programstate            dsb 1   ;$9
    sceneindex              dsb 1   ;$a
    controller              dsb 1   ;$b
    scrolldirection         dsb 1   ;$c  ;not used
    nmicounter              dsb 1   ;$d
    oamindex                dsb 1   ;$e
ende

enum $0010
    ;ppu register mirrors, other important stuff
    
    bgxscroll dsb 1         ;$10        ;mirror for $2005
    bgyscroll dsb 1         ;$11        ;mirror for $2005 (second write)
    
    bgxsubscroll dsb 1      ;$12        ;not currently used
    bgysubscroll dsb 1      ;$13        ;not currently used
    
    rendersettings dsb 1    ;$14        ;mirror for $2001
    ppuctrl dsb 1           ;$15        ;mirror for $2000
    
    nmiflag dsb 1           ;$16
ende



enum $0040
    ;player variables
    
    player_x                dsb 1   ;$40
    player_subx             dsb 1   ;$41
    player_y                dsb 1   ;$42
    player_suby             dsb 1   ;$43
    
    player_x_speed          dsb 1   ;$44
    player_x_subspeed       dsb 1   ;$45
    player_y_speed          dsb 1   ;$46
    player_y_subspeed       dsb 1   ;$47
    
    player_animframe        dsb 1   ;$48
    
    player_direction        dsb 1   ;$49 ;not used
    
    player_collisiontype    dsb 1   ;$4a
    player_collisionindex   dsb 1   ;$4b
    
    shot_x_speed            dsb 1   ;$4c
    shot_x_subspeed         dsb 1   ;$4d
    shot_y_speed            dsb 1   ;$4d
    shot_y_subspeed         dsb 1   ;$4f
    shot_active             dsb 1   ;$50 ;boolean 0 or 1
ende

enum $0080
    collision_map_ptr       dsb 2   ;$80-81
    faelist_ptr             dsb 2   ;$82-83
    tobjlist_ptr            dsb 2   ;$84-85
    
ende

enum $0100          ;$0100-$0140; needs to be in stack page for popslide
    gfxbuffer        dsb 64
    gfxbuffer_size   dsb 1
    gfxbuffer_target dsb 2
ende

enum $0200      ;$0200-02ff
    ;oam buffer
    
    oambuffer       dsb $ff
    
ende

enum $0300
    tobj_id_hi          dsb 1*tobj_count+1
    tobj_id_lo          dsb 1*tobj_count+1
    
    tobj_tile_hi     dsb 1*tobj_count+1
    tobj_tile_lo     dsb 1*tobj_count+1
    
    tobj_routine_hi     dsb 1*tobj_count+1
    tobj_routine_lo     dsb 1*tobj_count+1
    
    tobj_x              dsb 1*tobj_count+1
    tobj_y              dsb 1*tobj_count+1
    tobj_timer          dsb 1*tobj_count+1
    
    ppu_queue_flag          dsb 1
    ppu_queue_addr_hi       dsb 1*tobj_count+1
    ppu_queue_addr_lo       dsb 1*tobj_count+1
    ppu_queue_byte          dsb 1*tobj_count+1
ende

enum $0400
    fae_id_hi       dsb 1*fae_count
    fae_id_lo       dsb 1*fae_count
    
    fae_x           dsb 1*fae_count
    fae_xradius     dsb 1*fae_count
    fae_y           dsb 1*fae_count
    fae_yradius     dsb 1*fae_count
    fae_drawptr_hi  dsb 1*fae_count
    fae_drawptr_lo  dsb 1*fae_count
    fae_routine_lo  dsb 1*fae_count
    fae_routine_hi  dsb 1*fae_count
    fae_init_hi     dsb 1*fae_count
    fae_init_lo     dsb 1*fae_count
    
    fae_timer       dsb 1*fae_count
ende