tobjlist_water:
    ;dw tobj_id         ;if id hi = $ff then end
    ;db x
    ;db y
    
    dw water_obj
    db $00
    db $13
    
    dw water_obj
    db $08
    db $13
    
    dw water_obj
    db $10
    db $13
    
    dw water_obj
    db $18
    db $13
    
    dw animated_tile_obj
    db $ff
    db $ff
    
    dw $ffff            ;end
    
    
tobjlist_pipes:
    dw animated_tile_obj
    db $ff              
    db $ff              ;y = $ff is flag to not draw
    
    dw $ffff
    