#SECTION "RandomRoomData", ROMX, BANK[$0A] {
_RandomRoomDataTableSize:
  db 2
RandomRoomDataTable:
_RandomRoomDataTable:
  dw random_room_0 ; Room0
  dw random_room_1 ; Room1
random_room_0: ; Room0
  db $00, $00 ; allowed filter
  ; Primary data
  db 18, $04, $0D, $03, $C7, $06, $C7, $20, $C9, $29, $CA, $50, $C9, $59, $CA, $73, $C8, $76, $C8
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
random_room_1: ; Room1
  db $03, $00 ; allowed filter
  ; Primary data
  db 34, $04, $93, $02, $25, $84, $03, $21, $07, $26, $C6, $12, $23, $C6, $13, $0D, $C6, $14, $0D, $C6, $15, $0D, $C6, $16, $0D, $C6, $17, $24, $72, $27, $84, $73, $22, $77, $28
  ; Variations
  db 3
  db $80
  dw random_room_1_variation_0
  db $80
  dw random_room_1_variation_1
  db $80
  dw random_room_1_variation_2
  ; Entity sets
  db 2
  db $00, $FF
  dw random_room_1_entity_set_0
  db $00, $FF
  dw random_room_1_entity_set_1
random_room_1_variation_0:
  db 6, $C6, $14, $0F, $C6, $15, $0F
random_room_1_variation_1:
  db 8, $13, $AC, $16, $AC, $63, $AC, $66, $AC
random_room_1_variation_2:
  db 28, $21, $25, $22, $29, $27, $2A, $28, $26, $C2, $31, $23, $C2, $32, $20, $C2, $37, $20, $C2, $38, $24, $51, $27, $52, $2B, $57, $2C, $58, $28
random_room_1_entity_set_0:
  db 4
  db $43, $0B
  db $36, $0B
random_room_1_entity_set_1:
  db 2
  db $35, $B9
}
