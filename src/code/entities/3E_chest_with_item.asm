; Extended version of ChestWithItemEntityHandler
; We moved the giving of actual items from EntityInitChestWithItem to here (else we are constrained to bank3 size)
; This gives more options in chests, and overrides the heart container/heart piece graphics on opening the chest to allow any icon to show.
ChestWithItemEntityHandlerExtended::
    ld   a, $02
    ldh  [hLinkInteractiveMotionBlocked], a
    
    xor  a
    ld   [wSwordAnimationState], a ; wSwordAnimationState = SWORD_ANIMATION_STATE_NONE
    ld   [wC16A], a
    ldh  a, [hActiveEntitySpriteVariant]
    cp   CHEST_ZOL
    jp   z, .zolChest

    ldh  a, [hActiveEntityState]
    JP_TABLE
    dw .stateLoadGFX_giveItem
    dw .stateActive
.stateLoadGFX_giveItem:
    call giveChestItem
    ldh  a, [hActiveEntitySpriteVariant]
    ld   d, b
    ld   e, a
    ld   hl, ChestItemGfxTable
    add  hl, de
    add  hl, de
    add  hl, de
    ld   a, [hl+]
    ld   e, a
    ld   a, [hl+]
    ld   d, a
    ld   a, [hl+]
    ld   hl, $8AA0 ; Load the graphics tiles over the heart container/heart piece tiles
    push bc
    ld   bc, $0040 ; Always load 4 tiles
    call copyDataVRAM
    pop  bc
    jp   IncrementEntityState

.stateActive:
    ldh  a, [hActiveEntitySpriteVariant]
    cp   CHEST_POWER_BRACELET
    jr   nz, .maybeRenderL2Shield
    ld   a, [wPowerBraceletLevel]
    cp   2
    jr   c, .normalRender
    ld   de, ChestItemSpriteTableAltExtended
    jr   .doRender

.maybeRenderL2Shield:
    cp   CHEST_SHIELD
    jr   nz, .normalRender
    ld   a, [wShieldLevel]
    cp   2
    jr   c, .normalRender
    ld   de, ChestItemSpriteTableAltExtended
    jr   .doRender

.normalRender:
    ld   de, ChestItemSpriteTableExtended
.doRender:
    call RenderActiveEntitySprite

    ld   a, [wDialogState]
    and  a
    ret  nz

    call UpdateEntityPosWithSpeed_3E
    ld   hl, wEntitiesInertiaTable
    add  hl, bc
    ld   a, [hl]
    inc  a
    ld   [hl], a
    cp   $10
    jr   nz, .jr_7C76
    call GetEntitySpeedYAddress_3E
    ld   [hl], $00
.jr_7C76
    cp   $08
    jr   nz, .jr_007_7C93

    ldh  a, [hActiveEntitySpriteVariant]
    ld   e, a
    ld   d, b
    ld   hl, ChestItemSoundEffectTable
    add  hl, de
    ld   a, [hl]
    and  a
    jr   z, .jr_007_7C93

    cp   $01
    jr   nz, .jr_7C90

    ld   a, JINGLE_TREASURE_FOUND
    ldh  [hJingle], a
    jr   .jr_007_7C93

.jr_7C90
    ld   [wMusicTrackToPlay], a

.jr_007_7C93:
    ld   hl, wEntitiesInertiaTable
    add  hl, bc
    ld   a, [hl]
    cp   $26
    jr   nz, .jr_007_7CEA

    ; Start of opening the dialog
    ldh  a, [hActiveEntitySpriteVariant]
    ld   e, a
    ld   d, b

;     ld   a, e
;     cp   CHEST_SHIELD
;     jr   nz, .jr_7CC1

;     ld   a, [wShieldLevel]
;     cp   $02
;     jr   c, .jr_7CC1

;     ld_dialog_low a, Dialog0ED ; "Got the Mirror Shield!"
;     jr   .jr_007_7CE6

; .jr_7CC1
;     ld   a, e
;     cp   CHEST_SWORD
;     jr   nz, .jr_7CD1

;     ld   a, [wSwordLevel]                ; @TODO ??? Is this used by the Seashell Mansion??
;     cp   $02
;     jr   nz, .jr_7CD1

;     ld_dialog_low a, Dialog09F ; "Got a new sword!"
;     jr   .jr_007_7CE6

; .jr_7CD1
;     ld   a, e
;     cp   CHEST_POWER_BRACELET
;     jr   nz, .jr_7CE1

;     ld   a, [wPowerBraceletLevel]
;     cp   $02
;     jr   nz, .jr_7CE1

;     ld_dialog_low a, Dialog0EE ; "Got a more powerful Bracelet!"
;     jr   .jr_007_7CE6

.jr_7CE1
    ld   hl, GotItemDialogExtended
    add  hl, de
    add  hl, de
    ld   a, [hl+]
    call OpenDialogInTable0
    ld   a, [hl]
    ld   [wDialogIndexHi], a

    xor  a
.jr_007_7CEA:
    cp   $28
    ret  nz
    jp   ClearEntityStatus_3E

.zolChest:
    ld   a, ENTITY_ZOL
    call SpawnNewEntity_trampoline
    jp   c, ClearEntityStatus_3E

    ldh  a, [hMultiPurpose0]
    ld   hl, wEntitiesPosXTable
    add  hl, de
    ld   [hl], a
    ldh  a, [hMultiPurpose1]
    ld   hl, wEntitiesPosYTable
    add  hl, de
    ld   [hl], a
    ld   hl, wEntitiesSpeedZTable
    add  hl, de
    ld   [hl], $18
    ld   hl, wEntitiesPosZTable
    add  hl, de
    ld   [hl], $06
    ld   hl, wEntitiesPrivateCountdown1Table
    add  hl, de
    ld   [hl], $50
    ld   hl, wEntitiesSpeedXTable
    add  hl, de
    ld   [hl], $08
    ld   hl, wEntitiesStateTable
    add  hl, de
    ld   [hl], $03
    ld   a, JINGLE_WRONG_ANSWER
    ldh  [hJingle], a
    jp   ClearEntityStatus_3E

MACRO chestItemGfxTableEntry
    dw \1 + \2
    db BANK(\1)
ENDM

ChestItemGfxTable:
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0020 ; CHEST_POWER_BRACELET
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0060 ; CHEST_SHIELD
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0080 ; CHEST_BOW
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $00A0 ; CHEST_HOOKSHOT
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $00C0 ; CHEST_MAGIC_ROD
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0180 ; CHEST_PEGASUS_BOOTS
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0100 ; CHEST_OCARINA
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0120 ; CHEST_FEATHER
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0160 ; CHEST_SHOVEL
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $00E0 ; CHEST_MAGIC_POWDER_BAG
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0000 ; CHEST_BOMB
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0040 ; CHEST_SWORD
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0140 ; CHEST_FLIPPERS
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0000 ; CHEST_MAGNIFYING_LENS ;?
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0240 ; ECHEST_BOOMERANG
    chestItemGfxTableEntry SlimeKeyTiles, $0000                ; ECHEST_SLIME_KEY
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0200 ; CHEST_MEDICINE
    chestItemGfxTableEntry InventoryOverworldItemsTiles, $0000 ; CHEST_TAIL_KEY
    chestItemGfxTableEntry InventoryOverworldItemsTiles, $0020 ; CHEST_ANGLER_KEY
    chestItemGfxTableEntry InventoryOverworldItemsTiles, $0040 ; CHEST_FACE_KEY
    chestItemGfxTableEntry InventoryOverworldItemsTiles, $0060 ; CHEST_BIRD_KEY
    chestItemGfxTableEntry InventoryOverworldItemsTiles, $00A0 ; CHEST_GOLD_LEAF
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; CHEST_MAP
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; CHEST_COMPASS
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; CHEST_STONE_BEAK
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; CHEST_NIGHTMARE_KEY
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; CHEST_SMALL_KEY
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0260 ; CHEST_RUPEES_50
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0260 ; CHEST_RUPEES_20
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0260 ; CHEST_RUPEES_100
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0260 ; CHEST_RUPEES_200
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0260 ; CHEST_RUPEES_500
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $01E0 ; CHEST_SEASHELL
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; CHEST_MESSAGE
    chestItemGfxTableEntry InventoryEquipmentItemsTiles, $0000 ; CHEST_ZOL
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY1
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY2
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY3
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY4
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY5
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY6
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY7
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY8
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $00A0 ; ECHEST_KEY0
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP1
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP2
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP3
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP4
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP5
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP6
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP7
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP8
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0000 ; ECHEST_MAP0
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS1
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS2
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS3
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS4
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS5
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS6
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS7
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS8
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0020 ; ECHEST_COMPASS0
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK1
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK2
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK3
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK4
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK5
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK6
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK7
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK8
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0040 ; ECHEST_STONE_BEAK0
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY1
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY2
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY3
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY4
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY5
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY6
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY7
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY8
    chestItemGfxTableEntry InventoryIndoorItemsTiles,    $0060 ; ECHEST_NIGHTMARE_KEY0


ChestItemSpriteTableAltExtended::
    db $AA, $17        ; CHEST_POWER_BRACELET (in face shrine)
    db $AA, $14        ; CHEST_SHIELD (in eagles tower)

ChestItemSpriteTableExtended::
    db $AA, $15        ; CHEST_POWER_BRACELET
    db $AA, $15        ; CHEST_SHIELD
    db $AA, $10        ; CHEST_BOW
    db $AA, $10        ; CHEST_HOOKSHOT
    db $AA, $14        ; CHEST_MAGIC_ROD
    db $AA, $16        ; CHEST_PEGASUS_BOOTS
    db $AA, $17        ; CHEST_OCARINA
    db $AA, $16        ; CHEST_FEATHER
    db $AA, $10        ; CHEST_SHOVEL
    db $AA, $10        ; CHEST_MAGIC_POWDER_BAG
    db $AA, $15        ; CHEST_BOMB
    db $AA, $10        ; CHEST_SWORD
    db $AA, $15        ; CHEST_FLIPPERS
    db $AA, $10        ; CHEST_MAGNIFYING_LENS?
    db $AA, $10        ; ECHEST_BOOMERANG
    db $AA, $10        ; ECHEST_SLIME_KEY
    db $AA, $14        ; CHEST_MEDICINE
    db $AA, $14        ; CHEST_TAIL_KEY
    db $AA, $14        ; CHEST_ANGLER_KEY
    db $AA, $14        ; CHEST_FACE_KEY
    db $AA, $14        ; CHEST_BIRD_KEY
    db $AA, $14        ; CHEST_GOLD_LEAF
    db $AA, $14        ; CHEST_MAP
    db $AA, $15        ; CHEST_COMPASS
    db $AA, $14        ; CHEST_STONE_BEAK
    db $AA, $14        ; CHEST_NIGHTMARE_KEY
    db $AA, $17        ; CHEST_SMALL_KEY
    db $AA, $15        ; CHEST_RUPEES_50
    db $AA, $15        ; CHEST_RUPEES_20
    db $AA, $15        ; CHEST_RUPEES_100
    db $AA, $15        ; CHEST_RUPEES_200
    db $AA, $15        ; CHEST_RUPEES_500
    db $AA, $14        ; CHEST_SEASHELL
    db $AA, $16        ; CHEST_MESSAGE
    db $00, $00        ; CHEST_ZOL
    db $AA, $17        ; ECHEST_KEY1
    db $AA, $17        ; ECHEST_KEY2
    db $AA, $17        ; ECHEST_KEY3
    db $AA, $17        ; ECHEST_KEY4
    db $AA, $17        ; ECHEST_KEY5
    db $AA, $17        ; ECHEST_KEY6
    db $AA, $17        ; ECHEST_KEY7
    db $AA, $17        ; ECHEST_KEY8
    db $AA, $17        ; ECHEST_KEY0
    db $AA, $14        ; ECHEST_MAP1
    db $AA, $14        ; ECHEST_MAP2
    db $AA, $14        ; ECHEST_MAP3
    db $AA, $14        ; ECHEST_MAP4
    db $AA, $14        ; ECHEST_MAP5
    db $AA, $14        ; ECHEST_MAP6
    db $AA, $14        ; ECHEST_MAP7
    db $AA, $14        ; ECHEST_MAP8
    db $AA, $14        ; ECHEST_MAP0
    db $AA, $15        ; ECHEST_COMPASS1
    db $AA, $15        ; ECHEST_COMPASS2
    db $AA, $15        ; ECHEST_COMPASS3
    db $AA, $15        ; ECHEST_COMPASS4
    db $AA, $15        ; ECHEST_COMPASS5
    db $AA, $15        ; ECHEST_COMPASS6
    db $AA, $15        ; ECHEST_COMPASS7
    db $AA, $15        ; ECHEST_COMPASS8
    db $AA, $15        ; ECHEST_COMPASS0
    db $AA, $14        ; ECHEST_STONE_BEAK1
    db $AA, $14        ; ECHEST_STONE_BEAK2
    db $AA, $14        ; ECHEST_STONE_BEAK3
    db $AA, $14        ; ECHEST_STONE_BEAK4
    db $AA, $14        ; ECHEST_STONE_BEAK5
    db $AA, $14        ; ECHEST_STONE_BEAK6
    db $AA, $14        ; ECHEST_STONE_BEAK7
    db $AA, $14        ; ECHEST_STONE_BEAK8
    db $AA, $14        ; ECHEST_STONE_BEAK0
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY1
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY2
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY3
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY4
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY5
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY6
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY7
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY8
    db $AA, $14        ; ECHEST_NIGHTMARE_KEY0

MACRO dw_dialog
    dw ((\1_IdxOffset - DialogPointerTable) / 2)
ENDM

GotItemDialogExtended::
    dw_dialog Dialog090 ; Power Bracelet
    dw_dialog Dialog091 ; Shield back
    dw_dialog ChestDialog2D ; Bow
    dw_dialog Dialog093 ; Hook Shot
    dw_dialog Dialog094 ; Magic Rod
    dw_dialog Dialog095 ; Pegasus Boots
    dw_dialog Dialog096 ; Ocarina
    dw_dialog Dialog097 ; Roc's Feather
    dw_dialog Dialog098 ; Shovel
    dw_dialog Dialog099 ; Magic Powder
    dw_dialog Dialog09A ; Bomb
    dw_dialog Dialog09B ; Found your sword
    dw_dialog Dialog09C ; Flippers
    dw_dialog Dialog09D ; Magnifying Lens
    dw_dialog ChestDialog2E ; Boomerang
    dw_dialog Dialog0A2 ; Slime key
    dw_dialog Dialog0A0 ; Secret medicine
    dw_dialog Dialog0A1 ; Tail Key
    dw_dialog Dialog0A2 ; Slime Key
    dw_dialog Dialog0A3 ; Angler Key
    dw_dialog Dialog0A4 ; Face Key
    dw_dialog Dialog0A5 ; Bird Key
    dw_dialog Dialog0A6 ; Map
    dw_dialog Dialog0A7 ; Compass
    dw_dialog Dialog0A8 ; Stone beak
    dw_dialog Dialog0A9 ; Nightmare's Key
    dw_dialog Dialog0AA ; Small Key
    dw_dialog Dialog0AC ; 50 Rupees
    dw_dialog Dialog0AB ; 20 Rupees
    dw_dialog Dialog0AD ; 100 Rupees
    dw_dialog Dialog0AE ; 200 Rupees
    dw_dialog Dialog0AE ; 200 Rupees
    dw_dialog Dialog0EF ; Secret Seashell
    dw_dialog Dialog111 ; CHEST_MESSAGE
    dw_dialog Dialog000 ; CHEST_ZOL
    dw_dialog ChestDialog00 ; ECHEST_KEY1
    dw_dialog ChestDialog01 ; ECHEST_KEY2
    dw_dialog ChestDialog02 ; ECHEST_KEY3
    dw_dialog ChestDialog03 ; ECHEST_KEY4
    dw_dialog ChestDialog04 ; ECHEST_KEY5
    dw_dialog ChestDialog05 ; ECHEST_KEY6
    dw_dialog ChestDialog06 ; ECHEST_KEY7
    dw_dialog ChestDialog07 ; ECHEST_KEY8
    dw_dialog ChestDialog08 ; ECHEST_KEY0
    dw_dialog ChestDialog09 ; ECHEST_MAP1
    dw_dialog ChestDialog0A ; ECHEST_MAP2
    dw_dialog ChestDialog0B ; ECHEST_MAP3
    dw_dialog ChestDialog0C ; ECHEST_MAP4
    dw_dialog ChestDialog0D ; ECHEST_MAP5
    dw_dialog ChestDialog0E ; ECHEST_MAP6
    dw_dialog ChestDialog0F ; ECHEST_MAP7
    dw_dialog ChestDialog10 ; ECHEST_MAP8
    dw_dialog ChestDialog11 ; ECHEST_MAP0
    dw_dialog ChestDialog12 ; ECHEST_COMPASS1
    dw_dialog ChestDialog13 ; ECHEST_COMPASS2
    dw_dialog ChestDialog14 ; ECHEST_COMPASS3
    dw_dialog ChestDialog15 ; ECHEST_COMPASS4
    dw_dialog ChestDialog16 ; ECHEST_COMPASS5
    dw_dialog ChestDialog17 ; ECHEST_COMPASS6
    dw_dialog ChestDialog18 ; ECHEST_COMPASS7
    dw_dialog ChestDialog19 ; ECHEST_COMPASS8
    dw_dialog ChestDialog1A ; ECHEST_COMPASS0
    dw_dialog ChestDialog1B ; ECHEST_STONE_BEAK1
    dw_dialog ChestDialog1C ; ECHEST_STONE_BEAK2
    dw_dialog ChestDialog1D ; ECHEST_STONE_BEAK3
    dw_dialog ChestDialog1E ; ECHEST_STONE_BEAK4
    dw_dialog ChestDialog1F ; ECHEST_STONE_BEAK5
    dw_dialog ChestDialog20 ; ECHEST_STONE_BEAK6
    dw_dialog ChestDialog21 ; ECHEST_STONE_BEAK7
    dw_dialog ChestDialog22 ; ECHEST_STONE_BEAK8
    dw_dialog ChestDialog23 ; ECHEST_STONE_BEAK0
    dw_dialog ChestDialog24 ; ECHEST_NIGHTMARE_KEY1
    dw_dialog ChestDialog25 ; ECHEST_NIGHTMARE_KEY2
    dw_dialog ChestDialog26 ; ECHEST_NIGHTMARE_KEY3
    dw_dialog ChestDialog27 ; ECHEST_NIGHTMARE_KEY4
    dw_dialog ChestDialog28 ; ECHEST_NIGHTMARE_KEY5
    dw_dialog ChestDialog29 ; ECHEST_NIGHTMARE_KEY6
    dw_dialog ChestDialog2A ; ECHEST_NIGHTMARE_KEY7
    dw_dialog ChestDialog2B ; ECHEST_NIGHTMARE_KEY8
    dw_dialog ChestDialog2C ; ECHEST_NIGHTMARE_KEY0

; Each entry in the table is $00 for nothing, $01 for basic sfx, $10 for music based sfx
ChestItemSoundEffectTable::
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $01, $01, $10, $10, $10, $10, $10 ;0X
    db $01, $10, $10, $10, $10, $10, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ;1X
    db $01, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ;2X
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ;3X
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01 ;4X
    db $01, $10, $01

; Give the chest item in register a to the player
giveChestItem::
    ldh  a, [hActiveEntitySpriteVariant] ; Load active sprite variant
    JP_TABLE
    dw ChestPowerBracelet; CHEST_POWER_BRACELET
    dw ChestShield       ; CHEST_SHIELD
    dw ChestBow          ; CHEST_BOW
    dw ChestWithItem     ; CHEST_HOOKSHOT
    dw ChestWithItem     ; CHEST_MAGIC_ROD
    dw ChestWithItem     ; CHEST_PEGASUS_BOOTS
    dw ChestWithItem     ; CHEST_OCARINA
    dw ChestWithItem     ; CHEST_FEATHER
    dw ChestWithItem     ; CHEST_SHOVEL
    dw ChestMagicPowder  ; CHEST_MAGIC_POWDER_BAG
    dw ChestBomb         ; CHEST_BOMB
    dw ChestSword        ; CHEST_SWORD
    dw Flippers          ; CHEST_FLIPPERS
    dw NoItem            ; CHEST_MAGNIFYING_LENS
    dw ChestWithItem    ; ECHEST_BOOMERANG
    dw SlimeKey         ; ECHEST_SLIME_KEY
    dw Medicine         ; CHEST_MEDICINE
    dw TailKey          ; CHEST_TAIL_KEY
    dw AnglerKey        ; CHEST_ANGLER_KEY
    dw FaceKey          ; CHEST_FACE_KEY
    dw BirdKey          ; CHEST_BIRD_KEY
    dw GoldenLeaf       ; CHEST_GOLD_LEAF
    dw ChestWithCurrentDungeonItem ; CHEST_MAP
    dw ChestWithCurrentDungeonItem ; CHEST_COMPASS
    dw ChestWithCurrentDungeonItem ; CHEST_STONE_BEAK
    dw ChestWithCurrentDungeonItem ; CHEST_NIGHTMARE_KEY
    dw ChestWithCurrentDungeonItem ; CHEST_SMALL_KEY
    dw AddRupees50      ; CHEST_RUPEES_50
    dw AddRupees20      ; CHEST_RUPEES_20
    dw AddRupees100     ; CHEST_RUPEES_100
    dw AddRupees200     ; CHEST_RUPEES_200
    dw AddRupees500     ; CHEST_RUPEES_500
    dw AddSeashell      ; CHEST_SEASHELL
    dw NoItem           ; CHEST_MESSAGE
    dw NoItem           ; CHEST_GEL
    dw AddKey ; KEY1
    dw AddKey ; KEY2
    dw AddKey ; KEY3
    dw AddKey ; KEY4
    dw AddKey ; KEY5
    dw AddKey ; KEY6
    dw AddKey ; KEY7
    dw AddKey ; KEY8
    dw AddKey ; KEY0
    dw AddMap ; MAP1
    dw AddMap ; MAP2
    dw AddMap ; MAP3
    dw AddMap ; MAP4
    dw AddMap ; MAP5
    dw AddMap ; MAP6
    dw AddMap ; MAP7
    dw AddMap ; MAP8
    dw AddMap ; MAP0
    dw AddCompass ; COMPASS1
    dw AddCompass ; COMPASS2
    dw AddCompass ; COMPASS3
    dw AddCompass ; COMPASS4
    dw AddCompass ; COMPASS5
    dw AddCompass ; COMPASS6
    dw AddCompass ; COMPASS7
    dw AddCompass ; COMPASS8
    dw AddCompass ; COMPASS0
    dw AddStoneBeak ; STONE_BEAK1
    dw AddStoneBeak ; STONE_BEAK2
    dw AddStoneBeak ; STONE_BEAK3
    dw AddStoneBeak ; STONE_BEAK4
    dw AddStoneBeak ; STONE_BEAK5
    dw AddStoneBeak ; STONE_BEAK6
    dw AddStoneBeak ; STONE_BEAK7
    dw AddStoneBeak ; STONE_BEAK8
    dw AddStoneBeak ; STONE_BEAK0
    dw AddNightmareKey ; NIGHTMARE_KEY1
    dw AddNightmareKey ; NIGHTMARE_KEY2
    dw AddNightmareKey ; NIGHTMARE_KEY3
    dw AddNightmareKey ; NIGHTMARE_KEY4
    dw AddNightmareKey ; NIGHTMARE_KEY5
    dw AddNightmareKey ; NIGHTMARE_KEY6
    dw AddNightmareKey ; NIGHTMARE_KEY7
    dw AddNightmareKey ; NIGHTMARE_KEY8
    dw AddNightmareKey ; NIGHTMARE_KEY0

NoItem:
    ret

ChestPowerBracelet:
    ld   hl, $DB43 ; power bracelet level
    jr   ChestIncreaseItemLevel

ChestShield:
    ld   hl, $DB44 ; shield level
    jr   ChestIncreaseItemLevel

ChestSword:
    ld   hl, $DB4E ; sword level
    jr   ChestIncreaseItemLevel

ChestIncreaseItemLevel:
    ld   a, [hl]
    cp   $02
    jr   z, DoNotIncreaseItemLevel
    inc  [hl]
DoNotIncreaseItemLevel:
    jp   ChestWithItem

ChestBomb:
    ld   a, [wBombCount] ; bomb count
    add  a, $10
    daa
    ld   hl, wMaxBombs ; max bombs
    cp   [hl]
    jr   c, .bombsNotFull
    ld   a, [hl]
.bombsNotFull:
    ld   [wBombCount], a
    jp   ChestWithItem

ChestBow:
    ld   a, [wArrowCount]
    cp   $20
    jp   nc, ChestWithItem
    ld   a, $20
    ld   [wArrowCount], a
    jp   ChestWithItem

ChestMagicPowder:
    ; Reset the toadstool state
    ld   a, REPLACE_TILES_MAGIC_POWDER
    ldh  [hReplaceTiles], a
    xor  a
    ld   [wHasToadstool], a ; has toadstool

    ld   a, [wMagicPowderCount] ; powder count
    add  a, $10
    daa
    ld   hl, $DB76 ; max powder
    cp   [hl]
    jr   c, .magicPowderNotFull
    ld   a, [hl]
.magicPowderNotFull:
    ld   [wMagicPowderCount], a
    jp   ChestWithItem


ChestInventoryTable:
    db   $03 ; CHEST_POWER_BRACELET
    db   $04 ; CHEST_SHIELD
    db   $05 ; CHEST_BOW
    db   $06 ; CHEST_HOOKSHOT
    db   $07 ; CHEST_MAGIC_ROD
    db   $08 ; CHEST_PEGASUS_BOOTS
    db   $09 ; CHEST_OCARINA
    db   $0A ; CHEST_FEATHER
    db   $0B ; CHEST_SHOVEL
    db   $0C ; CHEST_MAGIC_POWDER_BAG
    db   $02 ; CHEST_BOMB
    db   $01 ; CHEST_SWORD
    db   $00 ; - (flippers slot)
    db   $00 ; - (magnifier lens slot)
    db   $0D ; ECHEST_BOOMERANG

ChestWithItem:
    ldh  a, [hActiveEntitySpriteVariant] ; Load active sprite variant
    ld   d, $00
    ld   e, a
    ld   hl, ChestInventoryTable
    add  hl, de
    ld   d, [hl]
    call GiveInventoryItem_trampoline
    ret

ChestWithCurrentDungeonItem:
    ld   e, a
    ld   d, $00
    ld   hl, wHasDungeonMap - CHEST_MAP
    add  hl, de
    inc  [hl]
    call SynchronizeDungeonsItemFlags_trampoline
    ret

Flippers:
    ld   a, $01
    ld   [wHasFlippers], a
    ret

Medicine:
    ld   a, $01
    ld   [wHasMedicine], a
    ret

TailKey:
    ld   a, $01
    ld   [wHasTailKey], a
    ret

AnglerKey:
    ld   a, $01
    ld   [wHasAnglerKey], a
    ret

FaceKey:
    ld   a, $01
    ld   [wHasFaceKey], a
    ret

BirdKey:
    ld   a, $01
    ld   [wHasBirdKey], a
    ret

SlimeKey:
    ld   a, $06
    ld   [wGoldenLeavesCount], a
    ret

GoldenLeaf:
    ld   hl, wGoldenLeavesCount
    inc  [hl]
    ret

AddSeashell:
    ld   a, [wSeashellsCount]
    inc  a
    daa
    ld   [wSeashellsCount], a
    ret

AddRupees20:
    xor  a
    ld   h, $14
    jr   AddRupees

AddRupees50:
    xor  a
    ld   h, $32
    jr   AddRupees

AddRupees100:
    xor  a
    ld   h, $64
    jr   AddRupees

AddRupees200:
    xor  a
    ld   h, $C8
    jr   AddRupees

AddRupees500:
    ld   a, $01
    ld   h, $F4
    jr   AddRupees

AddRupees:
    ld   [wAddRupeeBufferHigh], a
    ld   a, h
    ld   [wAddRupeeBufferLow], a
    ld   a, $18
    ld   [wC3CE], a
    ret

AddKey:
    sub  ECHEST_KEY1 ; Make 'A' target dungeon index
    ld   de, $0004
    jr   AddDungeonItem

AddMap:
    sub  ECHEST_MAP1 ; Make 'A' target dungeon index
    ld   de, $0000
    jr   AddDungeonItem

AddCompass:
    sub  ECHEST_COMPASS1 ; Make 'A' target dungeon index
    ld   de, $0001
    jr   AddDungeonItem

AddStoneBeak:
    sub  ECHEST_STONE_BEAK1 ; Make 'A' target dungeon index
    ld   de, $0002
    jr   AddDungeonItem

AddNightmareKey:
    sub  ECHEST_NIGHTMARE_KEY1 ; Make 'A' target dungeon index
    ld   de, $0003
    jr   AddDungeonItem

AddDungeonItem:
    cp   $08
    jr   z, .colorDungeon
    ; hl = dungeonitems + type_type + dungeon * 8
    ld   hl, wDungeonItemFlags
    add  hl, de
    push de
    ld   e, a
    add  hl, de
    add  hl, de
    add  hl, de
    add  hl, de
    add  hl, de
    pop  de
    inc  [hl]
    ; Check if we are in this specific dungeon, and then increase the copied counters as well.
    ld   hl, hMapId   ; is current map == target map
    cp   [hl]
    ret  nz
    ld   a, [wIsIndoor] ; is indoor
    and  a
    ret  z

    ld   hl, wCurrentDungeonItemFlags
    add  hl, de
    inc  [hl]
    ret
.colorDungeon:
    ; Special case for the color dungeon, which is in a different location in memory.
    ld   hl, wColorDungeonItemFlags
    add  hl, de
    inc  [hl]
    ldh  a, [hMapId]   ; is current map == color dungeon
    cp   $ff
    ret  nz
    ld   hl, wCurrentDungeonItemFlags
    add  hl, de
    inc  [hl]
    ret


ChestDialog00: dialog_text "Got a small key for Tail Cave"
ChestDialog01: dialog_text "Got a small key for Bottle Grotto"
ChestDialog02: dialog_text "Got a small key for Key Cavern"
ChestDialog03: dialog_text "Got a small key for Angler's Tunnel"
ChestDialog04: dialog_text "Got a small key for Catfish's Maw"
ChestDialog05: dialog_text "Got a small key for Face Shrine"
ChestDialog06: dialog_text "Got a small key for Eagle's Tower"
ChestDialog07: dialog_text "Got a small key for Turtle Rock"
ChestDialog08: dialog_text "Got a small key for Color Dungeon"
ChestDialog09: dialog_text "Got the map for Tail Cave"
ChestDialog0A: dialog_text "Got the map for Bottle Grotto"
ChestDialog0B: dialog_text "Got the map for Key Cavern"
ChestDialog0C: dialog_text "Got the map for Angler's Tunnel"
ChestDialog0D: dialog_text "Got the map for Catfish's Maw"
ChestDialog0E: dialog_text "Got the map for Face Shrine"
ChestDialog0F: dialog_text "Got the map for Eagle's Tower"
ChestDialog10: dialog_text "Got the map for Turtle Rock"
ChestDialog11: dialog_text "Got the map for Color Dungeon"
ChestDialog12: dialog_text "Got the compass for Tail Cave"
ChestDialog13: dialog_text "Got the compass for Bottle Grotto"
ChestDialog14: dialog_text "Got the compass for Key Cavern"
ChestDialog15: dialog_text "Got the compass for Angler's Tunnel"
ChestDialog16: dialog_text "Got the compass for Catfish's Maw"
ChestDialog17: dialog_text "Got the compass for Face Shrine"
ChestDialog18: dialog_text "Got the compass for Eagle's Tower"
ChestDialog19: dialog_text "Got the compass for Turtle Rock"
ChestDialog1A: dialog_text "Got the compass for Color Dungeon"
ChestDialog1B: dialog_text "Got the stone beak for Tail Cave"
ChestDialog1C: dialog_text "Got the stone beak for Bottle Grotto"
ChestDialog1D: dialog_text "Got the stone beak for Key Cavern"
ChestDialog1E: dialog_text "Got the stone beak for Angler's Tunnel"
ChestDialog1F: dialog_text "Got the stone beak for Catfish's Maw"
ChestDialog20: dialog_text "Got the stone beak for Face Shrine"
ChestDialog21: dialog_text "Got the stone beak for Eagle's Tower"
ChestDialog22: dialog_text "Got the stone beak for Turtle Rock"
ChestDialog23: dialog_text "Got the stone beak for Color Dungeon"
ChestDialog24: dialog_text "Got the nightmare key for Tail Cave"
ChestDialog25: dialog_text "Got the nightmare key for Bottle Grotto"
ChestDialog26: dialog_text "Got the nightmare key for Key Cavern"
ChestDialog27: dialog_text "Got the nightmare key for Angler's Tunnel"
ChestDialog28: dialog_text "Got the nightmare key for Catfish's Maw"
ChestDialog29: dialog_text "Got the nightmare key for Face Shrine"
ChestDialog2A: dialog_text "Got the nightmare key for Eagle's Tower"
ChestDialog2B: dialog_text "Got the nightmare key for Turtle Rock"
ChestDialog2C: dialog_text "Got the nightmare key for Color Dungeon"
ChestDialog2D: dialog_text "Found the bow&arrows!"
ChestDialog2E: dialog_text "Found the boomerang!"