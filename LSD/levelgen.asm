#SECTION "DungeonMinimap", SRAM, BANK[6] {
sDungeonMinimap:
_sDungeonMinimap:
  ds 8 * 8
sDungenChestContents:
_sDungenChestContents:
  ds 8 * 8
sDungeonEventTable:
_sDungeonEventTable:
  ds 8 * 8
}

#SECTION "MapBuildCode", ROMX, BANK[$0A] {

RoomPartFloorWarp: db   .end - @ - 1
  db   $11, $1D
  db   $E1, $00, $ff, $58, $52 ; object
.end:
RoomPartChest: db   .end - @ - 1
  db   $11, $A0
.end:

LSD_GenerateMap:
    ; If we warp to room $FF generate a new map and warp to that.
    ldh  a, [hMapRoom]
    inc  a
    ret  nz
    ld   hl, wDungeonDepth
    inc  [hl]

    call EnableSRAM
    ld   a, BANK(sDungeonMinimap)
    ld   [$4000], a
    call _generateRandomMap ; call our C function to randomly generate the map layout
    call _rand8
    and  a, 7
    ldh  [hMapId], a

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
