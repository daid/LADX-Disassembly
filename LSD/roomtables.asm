
#SECTION "IndoorRoomsA", ROMX, BANK[$0A] {
IndoorsARoomPointers:
ColorDungeonRoomPointers:
    ; For the first 64 rooms, point to SRAM
    #FOR n, 0, $40 {
        dw sDynamicRoomData + n * $80
    }
    #FOR n, $40, $100 {
        dw sDynamicRoomData
    }
}

#SECTION "IndoorRoomsB", ROMX, BANK[$0A] {
IndoorsBRoomPointers:
    ; For the first 64 rooms, point to SRAM
    #FOR n, 0, $40 {
        dw sDynamicRoomData + n * $80
    }
    #FOR n, $40, $100 {
        dw StartRoom
    }
StartRoom:
  db   $04 ; animation id
  db   $00 | $0D ; room template | floor tile
  db   $85, $11, $0F           ; object
  db   $85, $21, $0F           ; object
  db   $85, $31, $0F           ; object
  db   $85, $41, $0F           ; object
  db   $21, $C5                ; object
  db   $31, $C6                ; object
  db   $23, $C5                ; object
  db   $33, $C6                ; object
  db   $C2, $18, $A6           ; object
  db   $82, $61, $20           ; object
  db   $48, $C0                ; object
  db   $68, $C0                ; object
  db   $57, $9B                ; object
  db   $58, $9C                ; object
  db   $07, $99                ; object
  db   $17, $9A                ; object
  db   $74, $FD                ; object
  db   $E1, $00, $ff, $58, $52 ; object
  db   $FE
}

#SECTION "RoomEntities", ROMX, BANK[$16] {
OverworldEntitiesPointersTable:
    #FOR n, 0, $100 {
        dw NoEntities
    }
IndoorsAEntitiesPointersTable:
    #FOR n, 0, 64 {
        dw sDynamicEntityData + n * $80
    }
    #FOR n, 64, $100 {
        dw NoEntities
    }
IndoorsBEntitiesPointersTable:
    #FOR n, 0, $100 {
        dw NoEntities
    }
ColorDungeonEntitiesPointersTable:
    #FOR n, 0, $20 {
        dw NoEntities
    }
NoEntities:
    db   $FF
}

#SECTION "DynamicRoomData", SRAM, BANK[1] {
sDynamicRoomData:
    ds $2000
}
#SECTION "DynamicEntityData", SRAM, BANK[2] {
sDynamicEntityData:
    ds $2000
}
