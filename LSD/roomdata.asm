#SECTION "RandomRoomData", ROMX, BANK[$0A] {
_RandomRoomDataTable:
  db 4
  dw RandomRoomDataTable0
  db 1
  dw RandomRoomDataTable1
  db 1
  dw RandomRoomDataTable2
  db 2
  dw RandomRoomDataTable3
RandomRoomDataTable0:
  dw random_room_0 ; Basic Room
  dw random_room_1 ; Vertical Hallway
  dw random_room_2 ; Horizontal Hallway
  dw random_room_3 ; Random Corners
RandomRoomDataTable1:
  dw random_room_5 ; Entrance 1
RandomRoomDataTable2:
  dw random_room_4 ; Exit 1
RandomRoomDataTable3:
  dw random_room_6 ; Treasure 1
  dw random_room_7 ; Treasure Ledge
random_room_0: ; Basic Room
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
random_room_1: ; Vertical Hallway
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
  db 5
  db $00, $FF
  dw random_room_1_entity_set_0
  db $00, $FF
  dw random_room_1_entity_set_1
  db $00, $FF
  dw random_room_1_entity_set_2
  db $00, $FF
  dw random_room_1_entity_set_3
  db $00, $FF
  dw random_room_1_entity_set_4
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
random_room_1_entity_set_2:
  db 4
  db $34, $8F
  db $45, $8F
random_room_1_entity_set_3:
  db 4
  db $44, $9B
  db $35, $9B
random_room_1_entity_set_4:
  db 2
  db $45, $29
random_room_2: ; Horizontal Hallway
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
random_room_3: ; Random Corners
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
random_room_4: ; Exit 1
  db $00, $00 ; allowed filter
  ; Primary data
  db 2, $04, $0D
  ; Variations
  db 5
  db $80
  dw random_room_4_variation_0
  db $80
  dw random_room_4_variation_1
  db $80
  dw random_room_4_variation_2
  db $80
  dw random_room_4_variation_3
  db $80
  dw random_room_4_variation_4
  ; Entity sets
  db 2
  db $00, $FF
  dw random_room_4_entity_set_0
  db $00, $FF
  dw random_room_4_entity_set_1
random_room_4_variation_0:
  db 7, $58, $AF, $82, $66, $AF, $68, $01
random_room_4_variation_1:
  db 7, $51, $AF, $61, $01, $82, $62, $AF
random_room_4_variation_2:
  db 7, $82, $16, $B0, $18, $01, $28, $B0
random_room_4_variation_3:
  db 7, $11, $01, $82, $12, $B0, $21, $B0
random_room_4_variation_4:
  db 6, $C4, $34, $0F, $C4, $35, $0F
random_room_4_entity_set_0:
  db 2
  db $24, $89
random_room_4_entity_set_1:
  db 2
  db $14, $8E
random_room_5: ; Entrance 1
  db $00, $00 ; allowed filter
  ; Primary data
  db 10, $04, $0D, $22, $AC, $27, $AC, $52, $AC, $57, $AC
  ; Variations
  db 6
  db $80
  dw random_room_5_variation_0
  db $80
  dw random_room_5_variation_1
  db $80
  dw random_room_5_variation_2
  db $80
  dw random_room_5_variation_3
  db $80
  dw random_room_5_variation_4
  db $80
  dw random_room_5_variation_5
  ; Entity sets
  db 1
  db $00, $FF
  dw random_room_5_entity_set_0
random_room_5_variation_0:
  db 3, $84, $53, $0F
random_room_5_variation_1:
  db 3, $C2, $37, $0F
random_room_5_variation_2:
  db 3, $84, $23, $0F
random_room_5_variation_3:
  db 3, $C2, $32, $0F
random_room_5_variation_4:
  db 4, $33, $AF, $43, $B0
random_room_5_variation_5:
  db 4, $36, $AF, $46, $B0
random_room_5_entity_set_0:
  db 0
random_room_6: ; Treasure 1
  db $00, $00 ; allowed filter
  ; Primary data
  db 6, $04, $0D, $34, $A0, $44, $0F
  ; Variations
  db 1
  db $80
  dw random_room_6_variation_0
  ; Entity sets
  db 3
  db $00, $FF
  dw random_room_6_entity_set_0
  db $00, $FF
  dw random_room_6_entity_set_1
  db $00, $FF
  dw random_room_6_entity_set_2
random_room_6_variation_0:
  db 4, $33, $AE, $35, $AE
random_room_6_entity_set_0:
  db 0
random_room_6_entity_set_1:
  db 2
  db $44, $9B
random_room_6_entity_set_2:
  db 4
  db $45, $0B
  db $43, $0B
random_room_7: ; Treasure Ledge
  db $08, $00 ; allowed filter
  ; Primary data
  db 53, $04, $0D, $02, $26, $03, $2A, $06, $29, $07, $25, $C2, $12, $24, $84, $13, $0F, $14, $A0, $C2, $17, $23, $84, $23, $0F, $32, $2A, $84, $33, $21, $82, $34, $97, $37, $29, $82, $44, $0F, $60, $27, $61, $2B, $68, $2C, $69, $28, $70, $03, $71, $27, $78, $28, $79, $03
  ; Variations
  db 2
  db $80
  dw random_room_7_variation_0
  db $80
  dw random_room_7_variation_1
  ; Entity sets
  db 3
  db $00, $FF
  dw random_room_7_entity_set_0
  db $00, $FF
  dw random_room_7_entity_set_1
  db $00, $FF
  dw random_room_7_entity_set_2
random_room_7_variation_0:
  db 5, $13, $20, $82, $15, $20
random_room_7_variation_1:
  db 4, $52, $AB, $57, $AB
random_room_7_entity_set_0:
  db 0
random_room_7_entity_set_1:
  db 2
  db $24, $14
random_room_7_entity_set_2:
  db 4
  db $44, $9B
  db $45, $9B
}
