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
    scrolldirection         dsb 1   ;$c
    nmicounter              dsb 1   ;$d
    oamindex                dsb 1   ;$e
ende

enum $0010
    ;ppu register mirrors
    
    bgxscroll dsb 1         ;$10        ;mirror for $2005
    bgyscroll dsb 1         ;$11        ;mirror for $2005 (second write)
    
    bgxsubscroll dsb 1      ;$12
    bgysubscroll dsb 1      ;$13
    
    rendersettings dsb 1    ;$14        ;mirror for $2001
    
    ppuctrl dsb 1           ;$15        ;mirror for $2000
ende



enum $0040
    ;player variables
    
    playerx                 dsb 1   ;$40
    playersubx              dsb 1   ;$41
    playery                 dsb 1   ;$42
    playersuby              dsb 1   ;$43
    
    playerxspeed            dsb 1   ;$44
    playerxsubspeed         dsb 1   ;$45
    playeryspeed            dsb 1   ;$46
    playerysubspeed         dsb 1   ;$47
    
    playeranimframe         dsb 1   ;$48
    
    playerdirection         dsb 1   ;$49
    
    playercollisiontype     dsb 1   ;$4a
    playercollisionindex    dsb 1   ;$4b
    
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
    
    tobj_instptr_hi     dsb 1*tobj_count+1
    tobj_instptr_lo     dsb 1*tobj_count+1
    
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