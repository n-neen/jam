faelist_water:
    ;dw fae_id      ;if id hi = $ff then end
    ;db x
    ;db y
    ;db var
    
    dw mirror_gem   ;fae id
    db $7d          ;x
    db $80          ;y
    db $00          ;var
    
    dw $ffff        ;end
    
    
faelist_pipes:
    dw $ffff
    
    
faelist_hair:
    dw $ffff
    
    
faelist_pee:
    dw $ffff
    