#SECTION "LSD_ExitRoomEntityHandler", ROMX, BANK[$3E] {
LSD_ExitRoomEntityHandler:
    ldh a, [hActiveEntityState]
    rst 0
    dw  WaitForEnemyDeath
    dw  WaitForLinkToClearHole

WaitForEnemyDeath:
    ld   e, $0F
    ld   d, $00
.loopOverEntities:
    ld   hl, wEntitiesStatusTable
    add  hl, de
    ld   a, [hl]
    ; If the entity is none or disabled, continue with the next entity
    and  a
    if   nz {
        ; If the entity is active, and not excluded from the "Kill all" trigger,
        ; then the trigger is not resolved: return immediately.
        ld   hl, wEntitiesOptions1Table
        add  hl, de
        ld   a, [hl]
        and  $02 ; ENTITY_OPT1_EXCLUDED_FROM_KILL_ALL
        ret  z
    }
    dec  e
    ld   a, e
    cp   -1
    jr   nz, .loopOverEntities
    ; All entites dead
    jp   IncrementEntityState

WaitForLinkToClearHole:
    ldh  a, [hLinkPositionX]
    sub  a, $38
    cp   a, $30
    jr   nc, .safe
    ldh  a, [hLinkPositionY]
    sub  a, $30
    cp   a, $30
    ret  c
.safe:

    ld   a, [wRoomTransitionState]
    and  a, a
    ret  nz ; We entered the room while it is solved, the normal scrolling will draw the tiles so we do not have to.

    ld   a, $02 ; JINGLE_PUZZLE_SOLVED
    ldh  [hJingle], a

    ld   hl, wRoomObjects + $34
    ld   [hl], 30
    inc  hl
    ld   [hl], 30
    ld   hl, wRoomObjects + $44
    ld   [hl], 31
    inc  hl
    ld   [hl], 31

    ld   a, $30
    ldh  [hIntersectedObjectTop], a
    ld   a, $40
    ldh  [hIntersectedObjectLeft], a
    call label_2887

    ld   hl, wDrawCommand
    ld   a, [wDrawCommandsSize]
    ld   e, a
    add  $1C
    ld   [wDrawCommandsSize], a
    ld   d, $00
    add  hl, de

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   [hl+], a
    ldh  a, [hIntersectedObjectBGAddressLow]
    ld   [hl+], a
    ld   a, $83
    ld   [hl+], a
    ld   a, $76
    ld   [hl+], a
    ld   a, $48
    ld   [hl+], a
    ld   [hl+], a
    inc  a
    ld   [hl+], a

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   [hl+], a
    ldh  a, [hIntersectedObjectBGAddressLow]
    inc  a
    ld   [hl+], a
    ld   a, $83
    ld   [hl+], a
    ld   a, $76
    ld   [hl+], a
    ld   a, $48
    ld   [hl+], a
    ld   [hl+], a
    inc  a
    ld   [hl+], a

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   [hl+], a
    ldh  a, [hIntersectedObjectBGAddressLow]
    add  a, 2
    ld   [hl+], a
    ld   a, $83
    ld   [hl+], a
    ld   a, $76
    ld   [hl+], a
    ld   a, $48
    ld   [hl+], a
    ld   [hl+], a
    inc  a
    ld   [hl+], a

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   [hl+], a
    ldh  a, [hIntersectedObjectBGAddressLow]
    add  a, 3
    ld   [hl+], a
    ld   a, $83
    ld   [hl+], a
    ld   a, $76
    ld   [hl+], a
    ld   a, $48
    ld   [hl+], a
    ld   [hl+], a
    inc  a
    ld   [hl+], a

    ld   a, $00
    ld   [hl+], a

    ld   hl, wDrawCommandVRAM1
    ld   a, [wDrawCommandsVRAM1Size]
    ld   e, a
    add  $1C
    ld   [wDrawCommandsVRAM1Size], a
    ld   d, $00
    add  hl, de

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   [hl+], a
    ldh  a, [hIntersectedObjectBGAddressLow]
    ld   [hl+], a
    ld   a, $83
    ld   [hl+], a
    ld   a, $07
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   [hl+], a
    ldh  a, [hIntersectedObjectBGAddressLow]
    inc  a
    ld   [hl+], a
    ld   a, $83
    ld   [hl+], a
    ld   a, $07
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   [hl+], a
    ldh  a, [hIntersectedObjectBGAddressLow]
    add  a, 2
    ld   [hl+], a
    ld   a, $83
    ld   [hl+], a
    ld   a, $07 ; this palette selection should depend on the map
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a

    ldh  a, [hIntersectedObjectBGAddressHigh]
    ld   [hl+], a
    ldh  a, [hIntersectedObjectBGAddressLow]
    add  a, 3
    ld   [hl+], a
    ld   a, $83
    ld   [hl+], a
    ld   a, $07 ; this palette selection should depend on the map
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a
    ld   [hl+], a

    ld   a, $00
    ld   [hl+], a

    call UnloadEntity
    ret
}
