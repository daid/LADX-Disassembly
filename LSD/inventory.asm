#SECTION "GlobalInventoryTable", WRAMX[$D000], BANK[6] {
wGlobalInventoryTable:
    ; Store TypeID/X/Y/Map/Amount of item dropped on the floor
    ds $1000
}

#SECTION "Inventory", ROMX, BANK[$20] {
LSD_DropItemFromInventoryScreen:
    ld   hl, wInventoryItems.subscreen
    ld   a, [wInventorySelection]
    ld   c, a
    ld   b, $00
    add  hl, bc
    ld   a, [hl]
    and  a, a
    ret  z ; no item
    ldh  [hMultiPurposeE], a
    pushpop hl, bc {
        ld   a, $13 ; ENTITY_INVENTORY_DROP
        call SpawnNewEntity_trampoline
        jr   c, .exit
        ldh  a, [hLinkPositionX]
        ld   hl, wEntitiesPosXTable
        add  hl, de
        ld   [hl], a
        ldh  a, [hLinkPositionY]
        ld   hl, wEntitiesPosYTable
        add  hl, de
        ld   [hl], a
        ld   hl, wEntitiesStateTable
        add  hl, de
        ld   [hl], $01 ; set state to StateWaitForLinkDistance
        ld   hl, wEntitiesPrivateState1Table
        add  hl, de
        ldh  a, [hMultiPurposeE]
        ld   [hl], a
    }
    ld   a, $13 ; JINGLE_VALIDATE
    ldh  [hJingle], a
    ld   [hl], 0
    inc  c
    ld   e, c
    inc  c
    jp   DrawInventorySlots
.exit:
    pop  bc
    pop  hl
    ret
}

#SECTION "InventoryDropItem", ROMX, BANK[$3E] {
EntityInventoryDropSprite:
    db  $04, $00

EntityInventoryDropHandler:
    ld   hl, wEntitiesPrivateState2Table
    add  hl, bc
    ld   a, [hl]
    and  a
    call z, InventoryAddToGlobalInventoryTable

    ld   de, EntityInventoryDropSprite
    call RenderActiveEntitySprite
    ldh  a, [hActiveEntityState]
    rst  0
    dw   .StateNewPickup
    dw   .StateWaitForLinkDistance
    dw   .StateOldPickup
    dw   .StateDoingPickup

.StateWaitForLinkDistance:
    ldh  a, [hLinkPositionX]
    ld   hl, wEntitiesPosXTable
    add  hl, bc
    sub  [hl]
    add  $10
    cp   $20
    jp   nc, IncrementEntityState
    ldh  a, [hLinkPositionY]
    ld   hl, wEntitiesPosYTable
    add  hl, bc
    sub  [hl]
    add  $10
    cp   $20
    ret  c
    jp   IncrementEntityState

.StateNewPickup:
.StateOldPickup:
    ; If we cannot act, ignore picking up the item.
    ldh  a, [hLinkInteractiveMotionBlocked]
    and  a, a
    ret  nz

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
    ldh  a, [hActiveEntityState]
    and  a
    if   nz {
        ; If it isn't a new item, we need a A/B press to pick it up.
        ldh  a, [hJoypadState]
        and  $30 ; A/B
        ret  z
    }

    ld   hl, wEntitiesPrivateState1Table
    add  hl, bc
    ld   d, [hl]
    ; TODO: Handle full inventory
    call GiveInventoryItem_trampoline

    ld   a, $01 ; JINGLE_TREASURE_FOUND
    ldh  [hJingle], a

    call IncrementEntityState
    ld   [hl], $03
    call GetEntityTransitionCountdown
    ld   [hl], $20

    ; Remove ourselfs from the wGlobalInventoryTable
    ld   hl, wEntitiesPrivateState2Table
    add  hl, bc
    ld   e, [hl]
    dec  e
    ld   d, b
    ld   hl, wGlobalInventoryTable
    add  hl, de
    add  hl, de
    add  hl, de
    add  hl, de
    add  hl, de
    ld   a, BANK(wGlobalInventoryTable)
    ldh  [rSVBK], a
    xor  a
    ld   [hl], a
    ldh  [rSVBK], a

    ret

.StateDoingPickup:
    ldh  a, [hLinkPositionX]
    ld   hl, wEntitiesPosXTable
    add  hl, bc
    ld   [hl], a
    ldh  a, [hLinkPositionY]
    ld   hl, wEntitiesPosYTable
    add  hl, bc
    ld   [hl], a
    ldh  a, [hLinkPositionZ]
    add  a, 14
    ld   hl, wEntitiesPosZTable
    add  hl, bc
    ld   [hl], a

    ld   a, $6C ; LINK_ANIMATION_STATE_GOT_ITEM
    ldh  [hLinkAnimationState], a

    ld   a, $02
    ldh  [hLinkInteractiveMotionBlocked], a

    call GetEntityTransitionCountdown
    ret  nz
    jp   UnloadEntity

; Search a free spot in wGlobalInventoryTable and add this item.
; And store the index+1 in wEntitiesPrivateState2Table
InventoryAddToGlobalInventoryTable:
    ld   a, BANK(wGlobalInventoryTable)
    ldh  [rSVBK], a
    ld   hl, wGlobalInventoryTable
    ld   e, 1
    
.searchEmptyGlobalTableEntryLoop:
    ld   a, [hl]
    and  a, a
    jr   z, .EmptySpotFound
    inc  e
    inc  hl
    inc  hl
    inc  hl
    inc  hl
    inc  hl
    jr   .searchEmptyGlobalTableEntryLoop
.EmptySpotFound:
    pushpop hl {
        ld   hl, wEntitiesPrivateState2Table
        add  hl, bc
        ld   [hl], e
        ld   hl, wEntitiesPrivateState1Table
        add  hl, bc
        ld   a, [hl]
    }
    ld   [hl+], a
    ldh  a, [hActiveEntityPosX]
    ld   [hl+], a
    ldh  a, [hActiveEntityPosY]
    ld   [hl+], a
    ldh  a, [hMapRoom]
    ld   [hl+], a
    pushpop hl {
        ld   hl, wEntitiesPrivateState3Table
        add  hl, bc
        ld   a, [hl]
    }
    ld   [hl+], a
    xor  a
    ldh  [rSVBK], a
    ret
}