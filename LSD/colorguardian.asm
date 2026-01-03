
#SECTION "LSD_ColorGuardianInit", ROMX, BANK[$03] {
EntityInitColorGuardianBlue::
EntityInitColorGuardianRed::
    jp   EntityInitWithShiftedXPosition
}

#SECTION "LSD_ColorGuardian", ROMX, BANK[$36] {
ColorGuardianItemOptions:
    db INVENTORY_PIECE_OF_HEART, INVENTORY_FAIRY_BOTTLE
    db INVENTORY_BOW, INVENTORY_MAGIC_ROD
    db INVENTORY_BOMBS, INVENTORY_RUPEE_200
    db INVENTORY_PIECE_OF_HEART, INVENTORY_POTION2
.end:

ColorGuardianSpriteData:
    db $48, $02, $4A, $02
    db $4C, $02, $4E, $02
    db $48, $02, $4A, $02
    db $4C, $02, $4E, $02
    db $4A, $23, $48, $23
    db $4E, $23, $4C, $23
    db $4A, $23, $48, $23
    db $4E, $23, $4C, $23
    db $40, $02, $42, $03
    db $42, $22, $40, $23

ColorGuardianRedEntityHandler:
ColorGuardianBlueEntityHandler:
    ldh  a, [hActiveEntityState]
    rst  0
dw  .stateInit
dw  .stateGuardian
dw  .stateItem

.stateInit:
    ld   a, BANK(sDungenChestContents)
    ld   [$4000], a
    ldh  a, [hMapRoom]
    ld   d, 0
    ld   e, a
    ld   hl, sDungenChestContents
    add  hl, de
    ld   a, [hl]

    and  a, ((ColorGuardianItemOptions.end - ColorGuardianItemOptions) / 2) - 1
    ld   e, a
    ld   hl, ColorGuardianItemOptions
    add  hl, de
    add  hl, de
    push hl

    ; Left item
    ld   a, $F6
    call SpawnNewEntity_trampoline

    ld   hl, wEntitiesStateTable
    add  hl, de
    ld   [hl], 2 ; stateItem
    ld   hl, wEntitiesSpriteOffsetTable
    add  hl, de
    ld   [hl], b
    pop  hl
    ld   a, [hl+]
    push hl
    ld   hl, wEntitiesSpriteVariantTable
    add  hl, de
    ld   [hl], a

    ld   hl, wEntitiesPosXTable
    add  hl, de
    ldh  a, [hActiveEntityPosX]
    sub  24
    ld   [hl], a

    ld   hl, wEntitiesPosYTable
    add  hl, de
    ldh  a, [hActiveEntityPosY]
    add  24
    ld   [hl], a
    ; Right item
    ld   a, $F6
    call SpawnNewEntity_trampoline

    ld   hl, wEntitiesStateTable
    add  hl, de
    ld   [hl], 2 ; stateItem
    ld   hl, wEntitiesSpriteOffsetTable
    add  hl, de
    ld   [hl], b

    pop  hl
    ld   a, [hl+]
    ld   hl, wEntitiesSpriteVariantTable
    add  hl, de
    ld   [hl], a

    ld   hl, wEntitiesPosXTable
    add  hl, de
    ldh  a, [hActiveEntityPosX]
    add  24
    ld   [hl], a

    ld   hl, wEntitiesPosYTable
    add  hl, de
    ldh  a, [hActiveEntityPosY]
    add  24
    ld   [hl], a

    jp   IncrementEntityState

.stateGuardian:
    ldh  a, [hFrameCounter]
    swap a
    and  $07
    call SetEntitySpriteVariant
    ldh  a, [hRoomStatus]
    and  a, $10
    if   nz {
        ldh  a, [hFrameCounter]
        swap a
        and  $01
        add  a, 8
        call SetEntitySpriteVariant
    }

    ld   de, ColorGuardianSpriteData
    call RenderActiveEntitySpritesPair
    call PushLinkOutOfEntity_36
    ret

.stateItem:
    ldh  a, [hRoomStatus]
    and  a, $10
    jp   nz, UnloadEntity

    farcall DrawInventoryDropSprite

    ; Check if we are close
    ldh  a, [hLinkPositionX]
    ld   hl, wEntitiesPosXTable
    add  hl, bc
    sub  [hl]
    add  $08
    cp   $10
    ret  nc
    ldh  a, [hLinkPositionY]
    ld   hl, wEntitiesPosYTable
    add  hl, bc
    sub  [hl]
    add  $08
    cp   $10
    ret  nc

    ; Prevent usable item usage
    ld   hl, wItemUsageContext
    ld   [hl], $01 ; ITEM_USAGE_NEAR_NPC

    ; Check for button press
    ldh  a, [hJoypadState]
    and  $30 ; A/B
    ret  z

    ; Mark room as finished
    farcall MarkRoomCompleted

    ; Spawn new item for direct pickup.
    ld   a, $13
    call SpawnNewEntity_trampoline
    ld   hl, wEntitiesSpriteVariantTable
    add  hl, bc
    ld   a, [hl]
    ld   hl, wEntitiesSpriteVariantTable
    add  hl, de
    ld   [hl], a
    ld   hl, wEntitiesPrivateState3Table
    add  hl, de
    ld   [hl], $10 ; Set the default item amount

    jp   UnloadEntity
}
