
doorlist_hi:
    ;indexed by sceneindex
    db >doorlist_water
    db >doorlist_pipes
    db >doorlist_hair

doorlist_lo:
    db <doorlist_water
    db <doorlist_pipes
    db <doorlist_hair


;scene to transition to
;use defines from defines.asm

;collision type $40: lo nibble = index into this

doorlist_water:
    db scene_pipes  ;scene to transition to
    db $10          ;player x
    db $80          ;player y
    db $00          ;reserved byte
    
    db scene_pipes  ;scene to transition to
    db $80          ;player x
    db $80          ;player y
    db $00          ;reserved byte
    
    
doorlist_pipes:
    db scene_water
    db $40          ;player x
    db $80          ;player y
    db $00          ;reserved byte
    
    db scene_hair
    db $80          ;player x
    db $80          ;player y
    db $00          ;reserved byte
    
    
doorlist_hair:
    db scene_water
    db $80          ;player x
    db $a0          ;player y
    db $00          ;reserved byte