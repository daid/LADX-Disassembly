#SECTION "DungeonMinimap", SRAM, BANK[6] {
sDungeonMinimap:
_sDungeonMinimap:
  ds 8 * 8
sDungenChestContents:
_sDungenChestContents:
  ds 8 * 8
}

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
RoomPartChest: db   .end - @ - 1
  db   $11, $A0
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

LSD_GenerateMap:
    ; If we warp to room $FF generate a new map and warp to that.
    ldh  a, [hMapRoom]
    inc  a
    ret  nz
.restartGen:
    call EnableSRAM
    ld   a, BANK(sDungeonMinimap)
    ld   [$4000], a
    call _generateRandomMap ; call our C function to randomly generate the map layout
    call _rand8
    and  a, 7
    ldh  [hMapId], a

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
                bit  7, b
                ld   de, RoomPartFloorWarp
                call nz, CopyRoomPart
                bit  5, b
                ld   de, RoomPartChest
                call nz, CopyRoomPart

                ld   [hl], $FE ; end of room data indicator
            }
            pushpop hl {
                ld   a, BANK(sDynamicEntityData)
                ld   [$4000], a
                call _rand8
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

    ; Clear wGlobalInventoryTable
    ld   a, BANK(wGlobalInventoryTable)
    ldh  [rSVBK], a
    xor  a
    ld   hl, wGlobalInventoryTable
.clearwGlobalInventoryTableLoop:
    ld   [hl+], a
    bit  5, h
    jr   z, .clearwGlobalInventoryTableLoop
    ldh  [rSVBK], a

    ; Clear room status for all rooms
    ld   hl, wOverworldRoomStatus
    ld   de, $300
    xor  a
    loop d {
      loop e {
        ld   [hl+], a
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
}
