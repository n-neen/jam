include "./src/defines.asm"
include "./src/header.asm"                      ;ines header
include "./src/ram_labels.asm"                  ;labels for ram, yea

org $8000
    include "./src/main.asm"                    ;main, if you can believe it
    include "./src/gameplay.asm"
    include "./src/player.asm"
    include "./src/tilemap_animations.asm"
    
org $d000
    test_gfx:   incbin "./data/test.chr"        ;tiles
    test_pal:   incbin "./data/pal.pal"         ;palette
    
    test_map:   incbin "./data/test.map"        ;tilemap
    hair_map:   incbin "./data/hair.map"        ;tilemap
    hedron_map: incbin "./data/hedron.map"      ;tilemap
    water_map:  incbin "./data/water.map"       ;tilemap

org $fe00
    include "./data/collision_map.asm"          ;full page for one screen
 
org $fffa
    include "./src/vectors.asm"                 ;interrupt vectors

