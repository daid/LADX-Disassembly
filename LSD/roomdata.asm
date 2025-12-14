RANDOM_ROOM_COUNT = 1
#SECTION "RandomRoomData", ROMX, BANK[$0A] {
RandomRoomDataTable:
_RandomRoomDataTable:
 dw random_room_0 ; Room0
random_room_0: ; Room0
  ; Primary data
  db 2, $04, $0D
  ; Variations
  db 7
  db $80
  dw random_room_0_variation_0
  db $80
  dw random_room_0_variation_1
  db $80
  dw random_room_0_variation_2
  db $80
  dw random_room_0_variation_3
  db $80
  dw random_room_0_variation_4
  db $80
  dw random_room_0_variation_5
  db $80
  dw random_room_0_variation_6
  ; Entity sets
  db 9
  db $00, $FF
  dw random_room_0_entity_set_0
  db $00, $FF
  dw random_room_0_entity_set_1
  db $00, $FF
  dw random_room_0_entity_set_2
  db $00, $FF
  dw random_room_0_entity_set_3
  db $00, $FF
  dw random_room_0_entity_set_4
  db $00, $FF
  dw random_room_0_entity_set_5
  db $00, $FF
  dw random_room_0_entity_set_6
  db $00, $FF
  dw random_room_0_entity_set_7
  db $00, $FF
  dw random_room_0_entity_set_8
random_room_0_variation_0:
  db 2, $62, $DF
random_room_0_variation_1:
  db 2, $57, $DF
random_room_0_variation_2:
  db 2, $23, $DF
random_room_0_variation_3:
  db 2, $36, $DF
random_room_0_variation_4:
  db 6, $C2, $34, $0F, $C2, $35, $0F
random_room_0_variation_5:
  db 2, $52, $AE
random_room_0_variation_6:
  db 2, $27, $AE
random_room_0_entity_set_0:
  db 4
  db $43, $0B
  db $36, $0B
random_room_0_entity_set_1:
  db 8
  db $34, $19
  db $35, $19
  db $45, $19
  db $44, $19
random_room_0_entity_set_2:
  db 4
  db $33, $1A
  db $46, $1E
random_room_0_entity_set_3:
  db 2
  db $44, $1F
random_room_0_entity_set_4:
  db 2
  db $43, $29
random_room_0_entity_set_5:
  db 8
  db $45, $9B
  db $44, $9B
  db $35, $9B
  db $34, $1B
random_room_0_entity_set_6:
  db 6
  db $57, $9B
  db $22, $9B
  db $34, $1B
random_room_0_entity_set_7:
  db 4
  db $53, $A1
  db $26, $A1
random_room_0_entity_set_8:
  db 4
  db $34, $14
  db $45, $0B
}
