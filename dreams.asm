BANKED_WRAM = 1
#INCLUDE "gbz80/all.asm"
#INCLUDE "gbz80/extra/loop.asm"
#INCLUDE "gbz80/extra/pushpop.asm"
#INCLUDE "gbz80/extra/if.asm"
#INCLUDE "gbz80/extra/ld16.asm"

#INCRGBDS "src/main.azle.o"
#INCSDCC "LSD/mapgen.rel"

GBC_SGB_HEADER "Dreams", GB_MBC5_RAM_BATTERY, Start

#SECTION "LSDfarcall", ROM0 {
; call function hl in bank a
LSDfarcall:
    ldh  [hLSDTemporary0], a
    ld   a, [wCurrentBank]
    pushpop af {
        ldh  a, [hLSDTemporary0]
        call SwitchBank
        call jumpHL
    }
    call SwitchBank
    ret
}
#MACRO farcall _target {
    ld a, BANK(_target)
    ld hl, _target
    call LSDfarcall
}

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
#INCLUDE "LSD/timer.asm"

#INCLUDE "LSD/exitroom.asm"
#INCLUDE "LSD/shop.asm"
#INCLUDE "LSD/seed.asm"
#INCLUDE "LSD/colorguardian.asm"
