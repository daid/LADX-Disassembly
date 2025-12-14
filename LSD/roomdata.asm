#SECTION "RandomRoomData", ROMX, BANK[$0A] {
_RandomRoomDataTableSize:
  db 4
RandomRoomDataTable:
_RandomRoomDataTable:
  dw random_room_0 ; Room0
  dw random_room_1 ; Room1
  dw random_room_2 ; Room2
  dw random_room_3 ; Room3
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
random_room_2: ; Room2
  db $0C, $00 ; allowed filter
  ; Primary data
  db 77, $04, $93, $11, $25, $86, $12, $21, $13, $C7, $16, $C7, $18, $26, $20, $25, $21, $29, $86, $22, $B0, $C4, $23, $0D, $C4, $24, $0D, $C4, $25, $0D, $C4, $26, $0D, $28, $2A, $29, $26, $C2, $30, $23, $C2, $31, $0D, $C2, $32, $0D, $C2, $37, $0D, $C2, $38, $0D, $C2, $39, $24, $50, $27, $51, $2B, $52, $AF, $57, $AF, $58, $2C, $59, $28, $61, $27, $86, $62, $22, $63, $C8, $66, $C8, $68, $28
  ; Variations
  db 4
  db $80
  dw random_room_2_variation_0
  db $80
  dw random_room_2_variation_1
  db $80
  dw random_room_2_variation_2
  db $80
  dw random_room_2_variation_3
  ; Entity sets
  db 3
  db $00, $FF
  dw random_room_2_entity_set_0
  db $00, $FF
  dw random_room_2_entity_set_1
  db $00, $FF
  dw random_room_2_entity_set_2
random_room_2_variation_0:
  db 3, $84, $53, $AF
random_room_2_variation_1:
  db 3, $84, $23, $B0
random_room_2_variation_2:
  db 4, $47, $AF, $57, $01
random_room_2_variation_3:
  db 4, $22, $01, $32, $B0
random_room_2_entity_set_0:
  db 4
  db $43, $20
  db $36, $20
random_room_2_entity_set_1:
  db 2
  db $45, $A0
random_room_2_entity_set_2:
  db 4
  db $27, $B2
  db $52, $B2
random_room_3: ; Room3
  db $00, $00 ; allowed filter
  ; Primary data
  db 14, $04, $0D, $82, $12, $DF, $82, $16, $DF, $83, $61, $DF, $83, $66, $DF
  ; Variations
  db 5
  db $80
  dw random_room_3_variation_0
  db $80
  dw random_room_3_variation_1
  db $80
  dw random_room_3_variation_2
  db $80
  dw random_room_3_variation_3
  db $80
  dw random_room_3_variation_4
  ; Entity sets
  db 6
  db $00, $FF
  dw random_room_3_entity_set_0
  db $00, $FF
  dw random_room_3_entity_set_1
  db $00, $FF
  dw random_room_3_entity_set_2
  db $00, $FF
  dw random_room_3_entity_set_3
  db $00, $FF
  dw random_room_3_entity_set_4
  db $00, $FF
  dw random_room_3_entity_set_5
random_room_3_variation_0:
  db 16, $C2, $00, $03, $C2, $01, $03, $02, $25, $12, $23, $20, $25, $21, $21, $22, $29
random_room_3_variation_1:
  db 16, $50, $27, $51, $22, $52, $2B, $C2, $60, $03, $C2, $61, $03, $62, $23, $72, $27
random_room_3_variation_2:
  db 16, $07, $26, $C2, $08, $03, $C2, $09, $03, $17, $24, $27, $2A, $28, $21, $29, $26
random_room_3_variation_3:
  db 16, $57, $2C, $58, $22, $59, $28, $67, $24, $C2, $68, $03, $C2, $69, $03, $77, $28
random_room_3_variation_4:
  db 6, $C2, $34, $C0, $C2, $35, $C0
random_room_3_entity_set_0:
  db 4
  db $34, $19
  db $35, $19
random_room_3_entity_set_1:
  db 4
  db $43, $18
  db $36, $18
random_room_3_entity_set_2:
  db 2
  db $36, $91
random_room_3_entity_set_3:
  db 6
  db $43, $EC
  db $46, $EE
  db $25, $ED
random_room_3_entity_set_4:
  db 4
  db $43, $1A
  db $36, $1A
random_room_3_entity_set_5:
  db 4
  db $43, $0D
  db $36, $0D
}
