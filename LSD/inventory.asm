#SECTION "GlobalInventoryTable", WRAMX[$D000], BANK[6] {
wGlobalInventoryTable:
    ; Store TypeID/Map/X/Y/Amount of item dropped on the floor
    ds 5 * $100
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
    ldh  [hLSDTemporary1], a
    pushpop hl, bc {
        ld   a, $13 ; ENTITY_INVENTORY_DROP
        call SpawnNewEntity_trampoline
        jr   c, .exit
        ldh  a, [hLinkPositionX]
        ld   h, a
        call GetRandomByte
        and  7
        sub  3
        add  h
        ld   hl, wEntitiesPosXTable
        add  hl, de
        ld   [hl], a
        ldh  a, [hLinkPositionY]
        ld   h, a
        call GetRandomByte
        and  7
        sub  3
        add  h
        ld   hl, wEntitiesPosYTable
        add  hl, de
        ld   [hl], a
        ld   hl, wEntitiesStateTable
        add  hl, de
        ld   [hl], $01 ; set state to StateWaitForLinkDistance
        ld   hl, wEntitiesSpriteVariantTable
        add  hl, de
        ldh  a, [hLSDTemporary1]
        ld   [hl], a
        ; store the amount, and remove the amount we have.
        pushpop de {
            call getAmountPtrForInventory
        }
        ld   a, [hl]
        ld   [hl], 0
        ld   hl, wEntitiesPrivateState3Table
        add  hl, de
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

#SECTION "LoadGlobalFloorItems", ROMX, BANK[$3E] {
LSD_GetGlobalInventoryTable:
    ld   a, BANK(wGlobalInventoryTable)
    ldh  [rSVBK], a
    ld   a, [hl+]
    ldh  [hLSDTemporary0], a
    xor  a
    ldh  [rSVBK], a
    ldh  a, [hLSDTemporary0]
    ret

LSD_LoadGlobalFloorItems:
    ld   hl, wGlobalInventoryTable
    ld   c, 1
.loop:
    call LSD_GetGlobalInventoryTable
    and  a, a
    if   z {
        ld  de, 4
        add hl, de
    } else {
        ld  b, a ; store item type
        call LSD_GetGlobalInventoryTable
        ld  d, a
        ldh a, [hMapRoom]
        cp  d
        if  z { ; our current room, so create this floor inventory item
            pushpop hl, bc {
                ld   a, $13 ; ENTITY_INVENTORY_DROP
                call SpawnNewEntity_trampoline
                if c {
                    db $dd ; TODO: Handle spawn failure
                }
            }
            call LSD_GetGlobalInventoryTable ; X
            pushpop hl {
                ld   hl, wEntitiesPosXTable
                add  hl, de
                ld   [hl], a
            }
            call LSD_GetGlobalInventoryTable ; Y
            pushpop hl {
                ld   hl, wEntitiesPosYTable
                add  hl, de
                ld   [hl], a
                ld   hl, wEntitiesStateTable
                add  hl, de
                ld   [hl], $02 ; set state to StateOldPickup
                ld   hl, wEntitiesSpriteVariantTable
                add  hl, de
                ld   [hl], b  ; store item type
                ld   hl, wEntitiesPrivateState2Table
                add  hl, de
                ld   [hl], c  ; store global inventory index
            }
            call LSD_GetGlobalInventoryTable ; amount
            pushpop hl {
                ld   hl, wEntitiesPrivateState3Table
                add  hl, de
                ld   [hl], a
                ld   hl, wEntitiesPosXSignTable
                add  hl, de
                ld   [hl], d
                ld   hl, wEntitiesPosYSignTable
                add  hl, de
                ld   [hl], d
                call PrepareEntityPositionForRoomTransition_trampoline
            }
        } else {
            inc hl
            inc hl
            inc hl
        }
    }
    inc c
    jr  nz, .loop
    xor  a
    ldh  [rSVBK], a    
    ret
}

#SECTION "getAmountPtrForInventory", ROM0 {
; Get the pointers to item quantities for specific inventory items.
; In: A = Item type
; Out: hl = pointer to amount
;      de = pointer to max amount
getAmountPtrForInventory:
    ld   hl, wBombCount
    ld   de, wMaxBombs
    cp   $02 ; INVENTORY_BOMBS
    ret  z
    ld   hl, wArrowCount
    ld   de, wMaxArrows
    cp   $05 ; INVENTORY_BOW
    ret  z
    ld   hl, wColorDungeonItemFlags ; per default use some dummy location
    ld   de, wColorDungeonItemFlags
    ret
}

#SECTION "PrepareEntityPositionForRoomTransition_trampoline", ROM0 {
; We need a trampoline for the function that can setup entities proper for scrolling in view.
PrepareEntityPositionForRoomTransition_trampoline:
    ld   a, BANK(PrepareEntityPositionForRoomTransition)
    ld   [$2100], a
    call PrepareEntityPositionForRoomTransition
    jp   ReloadSavedBank
}

#SECTION "InventoryDropItem", ROMX, BANK[$3E] {
EntityInventoryDropSprite:
    db  $84, $05 ; INVENTORY_SWORD
    db  $80, $05 ; INVENTORY_BOMBS
    db  $82, $04 ; INVENTORY_POWER_BRACELET
    db  $86, $04 ; INVENTORY_SHIELD
    db  $88, $04 ; INVENTORY_BOW
    db  $8A, $04 ; INVENTORY_HOOKSHOT
    db  $8C, $04 ; INVENTORY_MAGIC_ROD
    db  $98, $04 ; INVENTORY_PEGASUS_BOOTS
    db  $90, $05 ; INVENTORY_OCARINA
    db  $92, $04 ; INVENTORY_ROCS_FEATHER
    db  $96, $04 ; INVENTORY_SHOVEL
    db  $8E, $04 ; INVENTORY_MAGIC_POWDER
    db  $A4, $04 ; INVENTORY_BOOMERANG
    db  $00, $00 ; INVENTORY_PIECE_OF_POWER
    db  $A0, $04 ; INVENTORY_POTION
    db  $A0, $05 ; INVENTORY_POTION2
    db  $C0, $04 ; INVENTORY_MAP

EntityInventoryDropSprite2:
    db  $80, $0C, $80, $2C

EntityInventoryDropHandler:
    ld   hl, wEntitiesPrivateState2Table
    add  hl, bc
    ld   a, [hl]
    and  a
    call z, InventoryAddToGlobalInventoryTable

    ldh  a, [hActiveEntitySpriteVariant]
    cp   $0E ; INVENTORY_PIECE_OF_POWER
    if z {
        ld   de, EntityInventoryDropSprite2 - $0E * 4
        call RenderActiveEntitySpritesPair
    } else {
        ld   de, EntityInventoryDropSprite - 2
        call RenderActiveEntitySprite
    }
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

    ldh  a, [hActiveEntitySpriteVariant]
    call getAmountPtrForInventory
    if   z { ; this item has an amount, so try to stack it.
        ld   hl, wInventoryItems
        loop e, $0C {
            cp  [hl]
            inc hl
            jr  z, .usableSlotFound
        }
    }

    ld   hl, wInventoryItems
    loop e, $0C {
        ld  a, [hl+]
        and a, a
        jr  z, .usableSlotFound
    }
    ret
.usableSlotFound:
    ; Store the inventory type in our inventory
    ldh  a, [hActiveEntitySpriteVariant]
    dec  hl
    ld   [hl], a

    ; Get the amount, and store it.
    ld   hl, wEntitiesPrivateState3Table
    add  hl, bc
    ld   a, [hl]
    pushpop af {
        ldh  a, [hActiveEntitySpriteVariant]
        call getAmountPtrForInventory
        ld   a, [de] ; get max
        ld   e, a
    }
    add  [hl]
    cp   e
    if   nc { ; clamp to max
        ld a, e
    }
    ld   [hl], a

    ld   a, $01 ; JINGLE_TREASURE_FOUND
    ldh  [hJingle], a

    call IncrementEntityState
    ld   [hl], $03
    call GetEntityTransitionCountdown
    ld   [hl], $20

    ld   a, $02
    ldh  [hLinkInteractiveMotionBlocked], a

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
    }
    ldh  a, [hActiveEntitySpriteVariant]
    ld   [hl+], a
    ldh  a, [hMapRoom]
    ld   [hl+], a
    ldh  a, [hActiveEntityPosX]
    ld   [hl+], a
    ldh  a, [hActiveEntityPosY]
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

#SECTION "UsePieceOfPower", ROMX, BANK[2] {
UsePieceOfPower:
    ld   a, $0E ; INVENTORY_PIECE_OF_POWER
    ld   hl, wInventoryItems.BButtonSlot
    cp   [hl]
    jr   z, .itemFound
    ld   hl, wInventoryItems.AButtonSlot
    cp   [hl]
    jr   z, .itemFound
    ret
.itemFound:
    ld   [hl], 0
    ld   a, $01
    ld   [wActivePowerUp], a

    xor  a
    ld   [wPowerUpHits], a
    ld   a, $27 ; MUSIC_OBTAIN_POWERUP
    ld   [wMusicTrackToPlay], a
    ld   a, $49 ; MUSIC_ACTIVE_POWER_UP
    ldh  [hDefaultMusicTrackAlt], a
    ldh  [hNextDefaultMusicTrack], a

    ret
}