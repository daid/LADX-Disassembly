BANKED_WRAM = 1
#INCLUDE "gbz80/all.asm"
#INCLUDE "gbz80/extra/loop.asm"
#INCLUDE "gbz80/extra/pushpop.asm"
#INCLUDE "gbz80/extra/if.asm"

#INCRGBDS "src/main.azle.o"
#INCSDCC "LSD/mapgen.rel"

GBC_SGB_HEADER "Dreams", GB_MBC5_RAM_BATTERY, Start

#INCLUDE "LSD/levelgen.asm"
#INCLUDE "LSD/entitygfx.asm"
#INCLUDE "LSD/rand.asm"
#INCLUDE "LSD/roomtables.asm"
#INCLUDE "LSD/inventory.asm"
#INCLUDE "LSD/init.asm"
