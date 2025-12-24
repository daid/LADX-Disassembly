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
    ld   a, [hl]
    cp   1 ; First floor, reset IGT
    if z {
      call EnableSRAM
      ld   hl, sLSDIngameTimer
      xor  a
      ld   [hl+], a ; 1/32 of a second
      ld   [hl+], a ; seconds
      ld   [hl+], a ; minutes
      ld   [hl+], a ; hours
    }

    call EnableSRAM
    ld   a, BANK(sDungeonMinimap)
    ld   [$4000], a
    call _generateRandomMap ; call our C function to randomly generate the map layout
    call _buildRandomRoomData ; then call into our function to generate the actual room layouts.
    
    ; Clear the wRoomObjects table, certain parts expect the out-of-bounds areas to be clear
    ld   hl, wRoomObjects
    xor  a
    loop c, 0 {
      ld   [hl+], a
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
}
