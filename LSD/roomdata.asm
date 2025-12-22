#SECTION "RandomRoomData", ROMX, BANK[$0A] {
_RandomRoomDataTable:
  db 6
  dw RandomRoomDataTable0
  db 1
  dw RandomRoomDataTable1
  db 1
  dw RandomRoomDataTable2
  db 4
  dw RandomRoomDataTable3
  db 3
  dw RandomRoomDataTable4
  db 1
  dw RandomRoomDataTable5
RandomRoomDataTable0:
  dw random_room_0 ; Basic Room
  dw random_room_1 ; Vertical Hallway
  dw random_room_2 ; Horizontal Hallway
  dw random_room_3 ; Random Corners
  dw random_room_8 ; H-Split
  dw random_room_15 ; Water Room
RandomRoomDataTable1:
  dw random_room_5 ; Entrance 1
RandomRoomDataTable2:
  dw random_room_4 ; Exit 1
RandomRoomDataTable3:
  dw random_room_6 ; Treasure 1
  dw random_room_7 ; Treasure Ledge
  dw random_room_9 ; Treasure 2
  dw random_room_11 ; Treasure Kill Room
RandomRoomDataTable4:
  dw random_room_12 ; Big Fairy
  dw random_room_13 ; Shop 1
  dw random_room_14 ; Shop 2
RandomRoomDataTable5:
  dw random_room_10 ; Final Nightmare
random_room_0: ; Basic Room
  db $00, $00 ; allowed filter
  db $21 ; event
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
  db $00 ; event
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
  db $00 ; event
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
  db $00 ; event
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
  db $00 ; event
  ; Primary data
  db 7, $04, $0D, $E1, $00, $FF, $58, $52
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
  db $02, $FF
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
  db 4
  db $24, $89
  db $00, $E7
random_room_4_entity_set_1:
  db 4
  db $34, $59
  db $00, $E7
random_room_5: ; Entrance 1
  db $00, $00 ; allowed filter
  db $00 ; event
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
  db $00 ; event
  ; Primary data
  db 6, $04, $0D, $12, $A0, $22, $0F
  ; Variations
  db 4
  db $80
  dw random_room_6_variation_0
  db $80
  dw random_room_6_variation_1
  db $80
  dw random_room_6_variation_2
  db $80
  dw random_room_6_variation_3
  ; Entity sets
  db 5
  db $00, $FF
  dw random_room_6_entity_set_0
  db $00, $FF
  dw random_room_6_entity_set_1
  db $00, $FF
  dw random_room_6_entity_set_2
  db $00, $FF
  dw random_room_6_entity_set_3
  db $00, $FF
  dw random_room_6_entity_set_4
random_room_6_variation_0:
  db 2, $64, $DF
random_room_6_variation_1:
  db 4, $14, $DF, $36, $DF
random_room_6_variation_2:
  db 16, $60, $27, $61, $2B, $68, $2C, $69, $28, $70, $03, $71, $27, $78, $28, $79, $03
random_room_6_variation_3:
  db 16, $00, $03, $01, $25, $08, $26, $09, $03, $10, $25, $11, $29, $18, $2A, $19, $26
random_room_6_entity_set_0:
  db 0
random_room_6_entity_set_1:
  db 2
  db $44, $9B
random_room_6_entity_set_2:
  db 4
  db $45, $0B
  db $43, $0B
random_room_6_entity_set_3:
  db 4
  db $53, $1E
  db $36, $1A
random_room_6_entity_set_4:
  db 4
  db $43, $0E
  db $46, $0E
random_room_7: ; Treasure Ledge
  db $08, $00 ; allowed filter
  db $00 ; event
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
random_room_8: ; H-Split
  db $00, $00 ; allowed filter
  db $00 ; event
  ; Primary data
  db 24, $04, $0D, $11, $20, $18, $20, $32, $2C, $84, $33, $22, $37, $2B, $42, $2A, $84, $43, $21, $47, $29, $61, $20, $68, $20
  ; Variations
  db 4
  db $80
  dw random_room_8_variation_0
  db $80
  dw random_room_8_variation_1
  db $80
  dw random_room_8_variation_2
  db $80
  dw random_room_8_variation_3
  ; Entity sets
  db 5
  db $00, $FF
  dw random_room_8_entity_set_0
  db $00, $FF
  dw random_room_8_entity_set_1
  db $00, $FF
  dw random_room_8_entity_set_2
  db $00, $FF
  dw random_room_8_entity_set_3
  db $00, $FF
  dw random_room_8_entity_set_4
random_room_8_variation_0:
  db 3, $82, $53, $DF
random_room_8_variation_1:
  db 3, $82, $25, $DF
random_room_8_variation_2:
  db 8, $11, $AC, $18, $AC, $61, $AC, $68, $AC
random_room_8_variation_3:
  db 14, $33, $2B, $C2, $34, $0F, $C2, $35, $0F, $36, $2C, $43, $29, $46, $2A
random_room_8_entity_set_0:
  db 4
  db $55, $0B
  db $24, $0B
random_room_8_entity_set_1:
  db 4
  db $53, $14
  db $26, $14
random_room_8_entity_set_2:
  db 4
  db $57, $A1
  db $22, $A1
random_room_8_entity_set_3:
  db 8
  db $57, $9B
  db $27, $9B
  db $22, $9B
  db $52, $9B
random_room_8_entity_set_4:
  db 4
  db $56, $9C
  db $23, $9C
random_room_9: ; Treasure 2
  db $00, $00 ; allowed filter
  db $00 ; event
  ; Primary data
  db 18, $04, $0D, $11, $A0, $12, $C0, $17, $C0, $18, $0F, $61, $0F, $62, $C0, $67, $C0, $68, $0F
  ; Variations
  db 6
  db $80
  dw random_room_9_variation_0
  db $80
  dw random_room_9_variation_1
  db $80
  dw random_room_9_variation_2
  db $80
  dw random_room_9_variation_3
  db $80
  dw random_room_9_variation_4
  db $80
  dw random_room_9_variation_5
  ; Entity sets
  db 5
  db $00, $03
  dw random_room_9_entity_set_0
  db $00, $FF
  dw random_room_9_entity_set_1
  db $00, $03
  dw random_room_9_entity_set_2
  db $03, $FF
  dw random_room_9_entity_set_3
  db $03, $FF
  dw random_room_9_entity_set_4
random_room_9_variation_0:
  db 6, $C2, $34, $A6, $C2, $35, $A6
random_room_9_variation_1:
  db 4, $73, $C8, $76, $C8
random_room_9_variation_2:
  db 4, $03, $C7, $06, $C7
random_room_9_variation_3:
  db 4, $20, $C9, $50, $C9
random_room_9_variation_4:
  db 4, $29, $CA, $59, $CA
random_room_9_variation_5:
  db 6, $84, $33, $12, $84, $43, $13
random_room_9_entity_set_0:
  db 0
random_room_9_entity_set_1:
  db 4
  db $32, $23
  db $47, $23
random_room_9_entity_set_2:
  db 4
  db $53, $0B
  db $26, $14
random_room_9_entity_set_3:
  db 8
  db $56, $0B
  db $23, $0B
  db $26, $14
  db $53, $14
random_room_9_entity_set_4:
  db 12
  db $22, $9B
  db $57, $9B
  db $27, $9B
  db $52, $9B
  db $55, $1B
  db $24, $1B
random_room_10: ; Final Nightmare
  db $00, $00 ; allowed filter
  db $00 ; event
  ; Primary data
  db 10, $04, $0D, $34, $E7, $35, $E8, $44, $E9, $45, $EA
  ; Variations
  db 2
  db $80
  dw random_room_10_variation_0
  db $80
  dw random_room_10_variation_1
  ; Entity sets
  db 1
  db $00, $FF
  dw random_room_10_entity_set_0
random_room_10_variation_0:
  db 32, $00, $03, $01, $25, $08, $26, $09, $03, $10, $25, $11, $29, $18, $2A, $19, $26, $60, $27, $61, $2B, $68, $2C, $69, $28, $70, $03, $71, $27, $78, $28, $79, $03
random_room_10_variation_1:
  db 4, $12, $AC, $17, $AC
random_room_10_entity_set_0:
  db 2
  db $34, $E6
random_room_11: ; Treasure Kill Room
  db $00, $00 ; allowed filter
  db $61 ; event
  ; Primary data
  db 20, $04, $0D, $02, $C7, $07, $C7, $20, $C9, $28, $A1, $29, $CA, $50, $C9, $59, $CA, $72, $C8, $77, $C8
  ; Variations
  db 5
  db $80
  dw random_room_11_variation_0
  db $80
  dw random_room_11_variation_1
  db $80
  dw random_room_11_variation_2
  db $80
  dw random_room_11_variation_3
  db $80
  dw random_room_11_variation_4
  ; Entity sets
  db 4
  db $00, $02
  dw random_room_11_entity_set_0
  db $02, $04
  dw random_room_11_entity_set_1
  db $03, $FF
  dw random_room_11_entity_set_2
  db $00, $FF
  dw random_room_11_entity_set_3
random_room_11_variation_0:
  db 8, $34, $A6, $36, $A6, $43, $A6, $45, $A6
random_room_11_variation_1:
  db 4, $62, $AB, $67, $AB
random_room_11_variation_2:
  db 4, $13, $20, $16, $20
random_room_11_variation_3:
  db 4, $32, $DF, $56, $DF
random_room_11_variation_4:
  db 11, $82, $14, $DF, $C2, $31, $DF, $48, $DF, $82, $64, $DF
random_room_11_entity_set_0:
  db 4
  db $52, $A1
  db $26, $A1
random_room_11_entity_set_1:
  db 6
  db $54, $0B
  db $22, $0B
  db $46, $14
random_room_11_entity_set_2:
  db 8
  db $68, $09
  db $18, $09
  db $11, $09
  db $61, $09
random_room_11_entity_set_3:
  db 8
  db $22, $1E
  db $57, $1E
  db $53, $0B
  db $25, $0B
random_room_12: ; Big Fairy
  db $08, $00 ; allowed filter
  db $00 ; event
  ; Primary data
  db 70, $0C, $0D, $00, $03, $01, $25, $08, $26, $09, $03, $84, $10, $25, $11, $29, $C3, $12, $10, $82, $14, $21, $84, $16, $26, $C3, $17, $11, $18, $2A, $23, $23, $82, $24, $1B, $26, $24, $33, $27, $82, $34, $22, $36, $28, $42, $94, $84, $43, $12, $47, $93, $52, $C0, $57, $C0, $60, $27, $61, $2B, $68, $2C, $69, $28, $70, $03, $71, $27, $78, $28, $79, $03
  ; Variations
  db 0
  ; Entity sets
  db 1
  db $00, $FF
  dw random_room_12_entity_set_0
random_room_12_entity_set_0:
  db 2
  db $24, $84
random_room_13: ; Shop 1
  db $00, $00 ; allowed filter
  db $00 ; event
  ; Primary data
  db 11, $04, $0D, $85, $22, $00, $85, $32, $00, $85, $42, $00
  ; Variations
  db 2
  db $80
  dw random_room_13_variation_0
  db $80
  dw random_room_13_variation_1
  ; Entity sets
  db 1
  db $00, $FF
  dw random_room_13_entity_set_0
random_room_13_variation_0:
  db 9, $85, $22, $07, $85, $32, $07, $85, $42, $07
random_room_13_variation_1:
  db 8, $11, $AC, $18, $AC, $61, $AC, $68, $AC
random_room_13_entity_set_0:
  db 2
  db $24, $4D
random_room_14: ; Shop 2
  db $00, $00 ; allowed filter
  db $00 ; event
  ; Primary data
  db 20, $04, $0D, $85, $11, $07, $85, $21, $07, $85, $31, $07, $85, $44, $00, $85, $54, $00, $85, $64, $00
  ; Variations
  db 3
  db $80
  dw random_room_14_variation_0
  db $80
  dw random_room_14_variation_1
  db $80
  dw random_room_14_variation_2
  ; Entity sets
  db 4
  db $02, $FF
  dw random_room_14_entity_set_0
  db $00, $FF
  dw random_room_14_entity_set_1
  db $00, $FF
  dw random_room_14_entity_set_2
  db $03, $FF
  dw random_room_14_entity_set_3
random_room_14_variation_0:
  db 4, $18, $C0, $61, $C0
random_room_14_variation_1:
  db 10, $C2, $26, $DF, $37, $DF, $82, $42, $DF, $53, $DF
random_room_14_variation_2:
  db 18, $85, $11, $00, $85, $21, $00, $85, $31, $00, $85, $44, $07, $85, $54, $07, $85, $64, $07
random_room_14_entity_set_0:
  db 4
  db $46, $4D
  db $13, $4D
random_room_14_entity_set_1:
  db 2
  db $13, $4D
random_room_14_entity_set_2:
  db 2
  db $46, $4D
random_room_14_entity_set_3:
  db 4
  db $46, $4D
  db $13, $4D
random_room_15: ; Water Room
  db $00, $00 ; allowed filter
  db $00 ; event
  ; Primary data
  db 26, $0C, $0D, $C4, $23, $1B, $C4, $24, $1B, $C4, $25, $1B, $C4, $26, $1B, $86, $32, $1B, $84, $33, $0E, $86, $42, $1B, $84, $43, $0E
  ; Variations
  db 3
  db $80
  dw random_room_15_variation_0
  db $80
  dw random_room_15_variation_1
  db $80
  dw random_room_15_variation_2
  ; Entity sets
  db 5
  db $00, $FF
  dw random_room_15_entity_set_0
  db $00, $FF
  dw random_room_15_entity_set_1
  db $03, $FF
  dw random_room_15_entity_set_2
  db $00, $FF
  dw random_room_15_entity_set_3
  db $04, $FF
  dw random_room_15_entity_set_4
random_room_15_variation_0:
  db 12, $51, $1B, $58, $1B, $61, $0E, $62, $1B, $67, $1B, $68, $0E
random_room_15_variation_1:
  db 12, $11, $0E, $12, $1B, $17, $1B, $18, $0E, $21, $1B, $28, $1B
random_room_15_variation_2:
  db 4, $34, $A6, $45, $A6
random_room_15_entity_set_0:
  db 4
  db $44, $CB
  db $36, $CB
random_room_15_entity_set_1:
  db 4
  db $54, $CC
  db $26, $CC
random_room_15_entity_set_2:
  db 10
  db $32, $99
  db $25, $99
  db $36, $99
  db $55, $99
  db $44, $99
random_room_15_entity_set_3:
  db 8
  db $52, $C5
  db $57, $C5
  db $27, $C5
  db $22, $C5
random_room_15_entity_set_4:
  db 10
  db $53, $A0
  db $42, $A0
  db $26, $A0
  db $46, $CB
  db $33, $CB
}
