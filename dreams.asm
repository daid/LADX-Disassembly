BANKED_WRAM = 1
#INCLUDE "gbz80/all.asm"
#INCLUDE "gbz80/extra/loop.asm"
#INCLUDE "gbz80/extra/pushpop.asm"
#INCLUDE "gbz80/extra/if.asm"
#INCLUDE "gbz80/extra/ld16.asm"

#INCRGBDS "src/main.azle.o"
#INCSDCC "LSD/mapgen.rel"

GBC_SGB_HEADER "Dreams", GB_MBC5_RAM_BATTERY, Start

#INCLUDE "LSD/const.asm"
#INCLUDE "LSD/roomdata.asm"
#INCLUDE "LSD/levelgen.asm"
#INCLUDE "LSD/entitygfx.asm"
#INCLUDE "LSD/rand.asm"
#INCLUDE "LSD/roomtables.asm"
#INCLUDE "LSD/inventory.asm"
#INCLUDE "LSD/pop.asm"
#INCLUDE "LSD/playergfx.asm"
#INCLUDE "LSD/init.asm"

#INCLUDE "LSD/exitroom.asm"
#INCLUDE "LSD/shop.asm"
#INCLUDE "LSD/seed.asm"

#SECTION "LSD_updateIngameTimer", ROM0 {
LSD_updateIngameTimer:
    ld   a, [wGameplayType] ;Get the gameplay type
    dec  a          ; and if it was 1
    ret  z          ; we are at the credits and the counter should stop.

    ; Check if the timer expired
    ld   hl, $FF0F
    bit  2, [hl]
    ret  z
    res  2, [hl]

    ; Increase the "subsecond" counter, and continue if it "overflows"
    call EnableSRAM ; Enable SRAM
    ld   hl, sLSDIngameTimer
    ld   a, [hl]
    inc  a
    cp   $20
    ld   [hl], a
    ret  nz
    xor  a
    ld   [hl+], a

    ; Increase the seconds counter/minutes/hours counter
increaseSecMinHours:
    ld   a, [hl]
    inc  a
    daa
    ld   [hl], a
    cp   $60
    ret  nz
    xor  a
    ld   [hl+], a
    jr   increaseSecMinHours
}