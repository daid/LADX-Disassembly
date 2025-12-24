#MACRO ShopEntry _value0, _item0, _value1, _item1 {
    db _item0, _value0 / $10, _item1, _value1 / $10
}

#SECTION "Shop", ROMX, BANK[$3E] {
ShopOwnerSprites:
    db   $40, $03, $42, $03
    db   $42, $23, $40, $23

ShopContentsTable:
    ShopEntry $100, INVENTORY_BOMBS, $300, INVENTORY_BOW
    ShopEntry $200, INVENTORY_MAP, $200, INVENTORY_COMPASS
    ShopEntry $120, INVENTORY_POTION, $250, INVENTORY_POTION2
    ShopEntry $120, INVENTORY_POTION, $100, INVENTORY_BOMBS

    ShopEntry $250, INVENTORY_POTION2, $500, INVENTORY_PEGASUS_BOOTS
    ShopEntry $120, INVENTORY_POTION, $500, INVENTORY_ROCS_FEATHER
    ShopEntry $150, INVENTORY_BOMBS, $100, INVENTORY_PIECE_OF_POWER
    ShopEntry $150, INVENTORY_BOMBS, $350, INVENTORY_MAGIC_ROD

    ShopEntry $100, INVENTORY_RUPEE_200, $100, INVENTORY_RUPEE_20
    ShopEntry $100, INVENTORY_RUPEE_20, $100, INVENTORY_RUPEE_200
    ShopEntry $50, INVENTORY_SMALL_KEY, $150, INVENTORY_PIECE_OF_HEART
    ShopEntry $150, INVENTORY_PIECE_OF_HEART, $600, INVENTORY_HEART_CONTAINER

    ShopEntry $900, INVENTORY_BOOMERANG, $300, INVENTORY_MAGIC_ROD
    ShopEntry $50, INVENTORY_MAGIC_POWDER, $160, INVENTORY_FAIRY_BOTTLE
    ShopEntry $50, INVENTORY_PIECE_OF_POWER, $150, INVENTORY_PIECE_OF_HEART
    ShopEntry $150, INVENTORY_PIECE_OF_HEART, $900, INVENTORY_SPIN_POWERUP
.end:

LSD_ShopOwnerEntityHandler:
    ldh  a, [hActiveEntityState]
    rst  0
    dw   InitShopState
    dw   ShopOwnerState
    dw   ShopItemState

InitShopState:
    call IncrementEntityState

    ld   hl, wEntitiesLoadOrderTable
    add  hl, bc
    ld   a, [hl]
    ldh  [hLSDTemporary2], a
    and  a, 1 ; clear Z flag for 2nd shop owner in same room

    ld   a, BANK(sDungenChestContents)
    ld   [$4000], a
    ldh  a, [hMapRoom]
    ld   d, 0
    ld   e, a
    ld   hl, sDungenChestContents
    add  hl, de
    ld   a, [hl]
    jr   nz, .noSwap ; This depends on the lowest bit of wEntitiesLoadOrderTable entry
    swap a
.noSwap:
    and  a, ((ShopContentsTable.end - ShopContentsTable) / 4) - 1
    ld   e, a
    ld   hl, ShopContentsTable
    add  hl, de
    add  hl, de
    add  hl, de
    add  hl, de
    push hl

    ; Spawn shop floor items
    ; left
    ld   a, $4D
    call SpawnNewEntity_trampoline
    ; TODO Spawn failure
    ld   hl, wEntitiesStateTable
    add  hl, de
    ld   [hl], 2 ; ShopItemState
    ld   hl, wEntitiesSpriteOffsetTable
    add  hl, de
    ld   [hl], b
    ld   hl, wEntitiesPrivateState2Table
    add  hl, de
    ld   [hl], $10 ; roomstatus mask
    ld   hl, wEntitiesLoadOrderTable
    add  hl, de
    ldh  a, [hLSDTemporary2]
    ld   [hl], a

    pop  hl
    ld   a, [hl+] ; Get shop item type
    push hl
    ld   hl, wEntitiesSpriteVariantTable
    add  hl, de
    ld   [hl], a

    pop  hl
    ld   a, [hl+] ; Get shop item value
    push hl
    ld   hl, wEntitiesPrivateState1Table
    add  hl, de
    ld   [hl], a

    ld   hl, wEntitiesPosXTable
    add  hl, de
    ldh  a, [hActiveEntityPosX]
    sub  20
    ld   [hl], a

    ld   hl, wEntitiesPosYTable
    add  hl, de
    ldh  a, [hActiveEntityPosY]
    add  24
    ld   [hl], a

    ; Right
    ld   a, $4D
    call SpawnNewEntity_trampoline
    ; TODO: spawn failure
    ld   hl, wEntitiesStateTable
    add  hl, de
    ld   [hl], 2 ; ShopItemState
    ld   hl, wEntitiesSpriteOffsetTable
    add  hl, de
    ld   [hl], b
    ld   hl, wEntitiesPrivateState2Table
    add  hl, de
    ld   [hl], $20 ; roomstatus mask
    ld   hl, wEntitiesLoadOrderTable
    add  hl, de
    ldh  a, [hLSDTemporary2]
    ld   [hl], a

    pop  hl
    ld   a, [hl+] ; Get shop item type
    push hl
    ld   hl, wEntitiesSpriteVariantTable
    add  hl, de
    ld   [hl], a

    pop  hl
    ld   a, [hl+] ; Get shop item value
    ld   hl, wEntitiesPrivateState1Table
    add  hl, de
    ld   [hl], a

    ld   hl, wEntitiesPosXTable
    add  hl, de
    ldh  a, [hActiveEntityPosX]
    add  a, 20
    ld   [hl], a

    ld   hl, wEntitiesPosYTable
    add  hl, de
    ldh  a, [hActiveEntityPosY]
    add  a, 24
    ld   [hl], a

    ret

ShopOwnerState:
    ldh  a, [hFrameCounter]
    swap a
    and  a, 1
    call SetEntitySpriteVariant
    ld   de, ShopOwnerSprites
    call RenderActiveEntitySpritesPair
    ret

ShopItemState:
    call ShopItemGetRoomStatusAddr
    ld   a, [hl]
    ld   hl, wEntitiesPrivateState2Table
    add  hl, bc
    and  [hl]
    jp   nz, UnloadEntity

    call DrawInventoryDropSprite

    ; Do not draw cost until the room is fully there, to prevent drawing in the previous room
    ld   a, [wRoomTransitionState]
    and  a, a
    ret  nz

    ldh  a, [hActiveEntityPosX]
    sub  a, 8
    ldh  [hIntersectedObjectLeft], a
    ldh  a, [hActiveEntityPosY]
    sub  a, 24
    ldh  [hIntersectedObjectTop], a
    call label_2887

    ld   hl, wEntitiesPrivateState1Table
    add  hl, bc
    ld   a, [hl]
    and  $0F
    ld   e, a
    ld   a, [hl]
    swap a
    and  $0F
    ld   d, a

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   h, a
    ldh  a, [hIntersectedObjectBGAddressLow]
    ld   l, a
    ld   a, d
    add  $B0
    ld   [hl], a
    call bgmapPtrToRight
    ld   a, e
    add  $B0
    ld   [hl], a
    call bgmapPtrToRight
    ld   [hl], $B0

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

    ; Check if we have enough money
    ld   hl, wEntitiesPrivateState1Table
    add  hl, bc
    ld   a, [hl] ; * $10 = cost in BCD
    swap a
    and  $0F ; X00 cost
    ld   e, a
    ld   a, [wRupeeCountHigh]
    cp   e
    ret  c
    jr   nz, .hasEnoughRupees
    ld   a, [hl]
    swap a
    and  $F0 ; 0X0 cost
    ld   e, a
    ld   a, [wRupeeCountLow]
    cp   e
    ret  c
.hasEnoughRupees:
    
    ; Setup subtraction of rupees
    ld   hl, wEntitiesPrivateState1Table
    add  hl, bc
    ld   a, [hl] ; * $10 = cost in BCD

    ld   hl, 0
    ld   de, 10
.loop_bcd_to_dec:
    add  hl, de
    dec  a
    daa
    jr   nz, .loop_bcd_to_dec
    ; hl now contains amount of rupees in decimal
    ld   a, [wSubstractRupeeBufferLow]
    add  a, l
    ld   [wSubstractRupeeBufferLow], a
    ld   a, [wSubstractRupeeBufferHigh]
    add  a, h
    ld   [wSubstractRupeeBufferHigh], a

    ; Mark the item as sold
    call ShopItemGetRoomStatusAddr
    push hl
    pop  de
    ld   hl, wEntitiesPrivateState2Table
    add  hl, bc
    ld   a, [de]
    or   [hl]
    ld   [de], a

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

ShopItemGetRoomStatusAddr:
    ld   hl, wEntitiesLoadOrderTable
    add  hl, bc
    ld   a, [hl]
    and  a, a
    ld   a, [wIndoorRoom]
    ld   d, $00
    if   nz {
        or a, $40
    }
    ld   e, a
    jp   GetRoomStatusAddressForMapPosition_trampoline


bgmapPtrToRight:
    pushpop de {
        ld   a, l
        and  $E0
        ld   e, a
        ld   a, l
        inc  a
        and  $1F
        or   e
        ld   l, a
    }
    ret
}
