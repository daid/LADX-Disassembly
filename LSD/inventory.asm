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
    ld   de, EntityInventoryDropSprite
    call RenderActiveEntitySprite
    ldh  a, [hActiveEntityState]
    rst  0
    dw   StateNewPickup
    dw   StateWaitForLinkDistance
    dw   StateOldPickup
    dw   StateDoingPickup

StateWaitForLinkDistance:
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

StateNewPickup:
StateOldPickup:
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
    ld   a, $01 ; JINGLE_TREASURE_FOUND
    ldh  [hJingle], a

    ld   hl, wEntitiesPrivateState1Table
    add  hl, bc
    ld   d, [hl]
    call GiveInventoryItem_trampoline

    call IncrementEntityState
    ld   [hl], $03
    call GetEntityTransitionCountdown
    ld   [hl], $30
    ret

StateDoingPickup:
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

    call GetEntityTransitionCountdown
    ret  nz
    jp   UnloadEntity
}