include "./src/defines.asm"
include "./src/header.asm"                      ;ines header
include "./src/ram_labels.asm"                  ;labels for ram, yea

org $8000
    include "./src/main.asm"                    ;main, if you can believe it
    include "./src/gameplay.asm"
    include "./src/player.asm"
    include "./src/tilemap_animations.asm"
    include "./src/fae.asm"
        include "./src/fae/mirrorgem.asm"
        include "./src/fae/shot.asm"
        
    faelist:    include "./data/faelists.asm"
    tobjlist:   include "./data/tobjlists.asm"
    include "./data/doorlist.asm"
    
    test_gfx:   incbin "./data/test.chr"        ;tiles
    test_pal:   incbin "./data/pal.pal"         ;palette
    water_map:  incbin "./data/water.map"       ;tilemap
    pipes_map:  incbin "./data/pipes.map"       ;tilemap
    hair_map:   incbin "./data/hair.map"        ;tilemap
    


org $f000
    ;should be page-aligned for optimization
    water_collision: include "./data/collision_maps/water_collision.asm"
    pipes_collision: include "./data/collision_maps/pipes_collision.asm"
    hair_collision:  include "./data/collision_maps/hair_collision.asm"
 
org $fffa
    include "./src/vectors.asm"                 ;interrupt vectors

