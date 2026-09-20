.ignorenl

    state_setup     equ 0
    state_loadscene equ 1
    state_setupgame equ 2
    state_gameplay  equ 3

    player_maxspeed             equ 2
    player_maxspeed_negative    equ -2

    tobj_count              equ 16
    tobj_header_length      equ 2   ;number of bytes between header and routine start
    tobj_list_entry_length  equ 4
    
    fae_count       equ 16

    scene_water     equ 0
    scene_pipes     equ 1
    scene_hair      equ 2
    scene_pee       equ 3

.endinl