BANKED_WRAM = 1
#INCLUDE "gbz80/all.asm"
#INCLUDE "gbz80/extra/loop.asm"
#INCLUDE "gbz80/extra/pushpop.asm"
#INCLUDE "gbz80/extra/if.asm"

#INCRGBDS "src/main.azle.o"

GBC_SGB_HEADER "Dreams", GB_MBC5_RAM_BATTERY, Start

#INCLUDE "LSD/entitygfx.asm"
#INCLUDE "LSD/rand.asm"
#INCLUDE "LSD/roomtables.asm"
#INCLUDE "LSD/inventory.asm"

#SECTION "MapBuildCode", ROMX, BANK[$0A] {

RoomStartPart: db   .end - @ - 1
  db   $04 ; animation id
  db   $00 | $0D ; room template | floor tile
.end:

RoomBottomDoorPart: db   .end - @ - 1
  db   $74, $F5                ; bottom door
.end:

RoomTopDoorPart: db   .end - @ - 1
  db   $04, $F4                ; top door
.end:
  
RoomLeftDoorPart: db   .end - @ - 1
  db   $30, $F6                ; left door
.end:

RoomRightDoorPart: db   .end - @ - 1
  db   $39, $F7                ; right door
.end:

RoomPartFloorWarp: db   .end - @ - 1
  db   $11, $1D
  db   $E1, $00, $ff, $58, $52 ; object
.end:

RandomEntitiesTable:
    dw EntitiesLikeLike
    dw EntitiesTektite
    dw EntitiesStalfos
    dw EntitiesGibdo
    dw EntitiesZol
    dw EntitiesHidingZol
    dw EntitiesWizrobe
    dw EntitiesGiantGhini

EntitiesLikeLike: db   .end - @ - 1
  db   $52, $23
  db   $27, $23
  db   $ff
.end:
EntitiesTektite: db   .end - @ - 1
  db   $22, $0D
  db   $57, $0D
  db   $ff
.end:
EntitiesStalfos: db   .end - @ - 1
  db   $22, $1E
  db   $57, $1A
  db   $ff
.end:
EntitiesGibdo: db   .end - @ - 1
  db   $22, $1E
  db   $57, $1A
  db   $ff
.end:
EntitiesZol: db   .end - @ - 1
  db   $22, $1B
  db   $57, $1B
  db   $ff
.end:
EntitiesHidingZol: db   .end - @ - 1
  db   $22, $9b
  db   $52, $9b
  db   $27, $9b
  db   $57, $9b
  db   $ff
.end:
EntitiesWizrobe: db   .end - @ - 1
  db   $22, $21
  db   $57, $21
  db   $ff
.end:
EntitiesGiantGhini: db   .end - @ - 1
  db   $34, $11
  db   $ff
.end:



wRandomMapData = $D700 ; use wRoomObjectsArea as scratch area during map generation
wSafetyCheck = $D7FF
wFinalRoom = $D7FE

LSD_GenerateMap:
    ; If we warp to room $FF generate a new map and warp to that.
    ldh  a, [hMapRoom]
    inc  a
    ret  nz
.restartGen:
    ; Clear 
    ld   hl, wRandomMapData
    xor  a
    ld   c, a
    loop c {
        ld   [hl+], a
    }

    ; Random start room.
    call GetRandomByte
    and  $3F
    ldh  [hMapRoom], a

BuildMainPath:
    ; From the start, generate a line of rooms that are connected
    ld   e, a ; keep e as current
    ld   c, 10

    ld   a, $FF
    ld   [wSafetyCheck], a
.retry:
    ; safety check
    ld   hl, wSafetyCheck
    dec  [hl]
    jr   z, LSD_GenerateMap.restartGen
    call MapGenRandomMove
    jr   z, .retry
    ld   h, HIGH(wRandomMapData)
    ld   l, a
    ld   d, a
    ld   a, [hl]
    and  a
    jr   nz, .retry
    call setRoomEdgeOpen
    ld   e, d ; current = next
    dec  c
    jr   nz, .retry
    ; e = final room
    ld   hl, wFinalRoom
    ld   [hl], e

BuildSidePaths:
    ld   c, 6
    ld   a, $FF
    ld   [wSafetyCheck], a
.retry:
    ld   hl, wSafetyCheck
    dec  [hl]
    jr   z, LSD_GenerateMap.restartGen
    call GetRandomByte
    and  $3F
    ld   e, a
    ld   d, HIGH(wRandomMapData)
    ld   a, [de]
    and  a
    jr   z, .retry
    call MapGenRandomMove
    jr   z, .retry
    ld   l, a
    ld   h, HIGH(wRandomMapData)
    ld   a, [hl]
    and  a
    jr   nz, .retry
    ld   d, l
    call setRoomEdgeOpen
    dec  c
    jr   nz, .retry

; Try to build cycles
BuildCycles:
    ld   c, 5
    ld   a, $FF
    ld   [wSafetyCheck], a
.retry:
    ld   hl, wSafetyCheck
    dec  [hl]
    jr   z, LSD_GenerateMap.restartGen
    call GetRandomByte
    and  $3F
    ld   e, a
    ld   d, HIGH(wRandomMapData)
    ld   a, [de]
    and  a
    jr   z, .retry
    call MapGenRandomMove
    jr   z, .retry
    ld   l, a
    ld   h, HIGH(wRandomMapData)
    ld   a, [hl]
    and  a
    jr   z, .retry
    ld   d, l
    call setRoomEdgeOpen
    dec  c
    jr   nz, .retry


BuildRooms:
    call EnableSRAM

    ld   hl, sDynamicRoomData + 63 * $80
    loop c, 64 {
        pushpop bc {
            pushpop hl {
                ld   a, BANK(sDynamicRoomData)
                ld   [$4000], a

                ; Get the flags for this room in b
                ld   b, HIGH(wRandomMapData)
                dec  c
                ld   a, [bc]
                pushpop bc {
                    inc  c
                    ld   b, a

                    ld   de, RoomStartPart
                    call CopyRoomPart

                    bit  0, b
                    ld   de, RoomRightDoorPart
                    call nz, CopyRoomPart
                    bit  1, b
                    ld   de, RoomLeftDoorPart
                    call nz, CopyRoomPart
                    bit  2, b
                    ld   de, RoomBottomDoorPart
                    call nz, CopyRoomPart
                    bit  3, b
                    ld   de, RoomTopDoorPart
                    call nz, CopyRoomPart
                }
                ld   a, [wFinalRoom]
                cp   c
                ld   de, RoomPartFloorWarp
                call z, CopyRoomPart

                ld   [hl], $FE ; end of room data indicator
            }
            pushpop hl {
                ld   a, BANK(sDynamicEntityData)
                ld   [$4000], a
                call GetRandomByte
                and  $0E
                pushpop hl {
                    add  LOW(RandomEntitiesTable)
                    ld   l, a
                    adc  HIGH(RandomEntitiesTable)
                    sub  l
                    ld   h, a
                    ld   a, [hl+]
                    ld   d, [hl]
                    ld   e, a
                }
                call CopyRoomPart
            }
            ld   de, $10000-$0080
            add  hl, de
        }
    }
    ret

CopyRoomPart:
    ld   a, [de]
    inc  de
    ld   c, a
    loop c {
        ld  a, [de]
        inc de
        ld  [hl+], a
    }
    ret

; Input e: yx position of current position
; Output z: set if move failed
;        a: yx position of next
;        b: move direction
MapGenRandomMove:
    call GetRandomByte
    and  $03
    ld   b, a
    jr   z, .right
    dec  a
    jr   z, .left
    dec  a
    jr   z, .up
.down:
    ld   a, e
    and  $38
    cp   $38
    ret  z
    ld   a, e
    add  a, $08 ; guarantees nz
    ret
.up:
    ld   a, e
    and  $38
    ret  z
    ld   a, e
    sub  a, $08
    cp   $FF ; guarantees nz
    ret

.right:
    ld   a, e
    and  $07
    cp   $07
    ret  z
    ld   a, e
    inc  a ; guarantees nz
    ret

.left:
    ld   a, e
    and  $07
    ret  z
    ld   a, e
    dec  a
    cp   $FF ; guarantees nz
    ret

; e = source room
; d = target room
; b = direction
setRoomEdgeOpen:
    ld   h, HIGH(wRandomMapData)
    ld   a, b
    and  a
    jr   z, .right
    dec  a
    jr   z, .left
    dec  a
    jr   z, .up
.down:
    ld   l, e
    set  7, [hl]
    set  2, [hl]
    ld   l, d
    set  7, [hl]
    set  3, [hl]
    ret
.up:
    ld   l, e
    set  7, [hl]
    set  3, [hl]
    ld   l, d
    set  7, [hl]
    set  2, [hl]
    ret
.left:
    ld   l, e
    set  7, [hl]
    set  1, [hl]
    ld   l, d
    set  7, [hl]
    set  0, [hl]
    ret
.right:
    ld   l, e
    set  7, [hl]
    set  0, [hl]
    ld   l, d
    set  7, [hl]
    set  1, [hl]
    ret
}
