; replaces richard code
#SECTION "seed_gfx", ROMX[$5200], BANK[$35] {
    #INCGFX "LSD/gfx/seed.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}

#SECTION "LSD_SeedEntityHandler", ROMX, BANK[$06] {
SeedEntitySprites:
    db   $40, $00, $42, $00
    db   $40, $02, $42, $02
SeedMessage:
    db   "Seed: ........", $ff
.end:
SeedLockedMessage:
    db   "Seed: ........  Locked", $ff
.end:

LSD_SeedEntityHandler:
    call EnableSRAM
    ld   a, [sRandStateLocked]
    ldh  [hActiveEntitySpriteVariant], a
    ldh  a, [hActiveEntityVisualPosY]
    sub  a, 4
    ldh  [hActiveEntityVisualPosY], a
    ld   de, SeedEntitySprites
    call RenderActiveEntitySpritesPair
    call PushLinkOutOfEntity_06
    ldh  a, [hActiveEntityState]
    rst  0
    dw   .stateWaitForInteraction
    dw   .stateInDialog

.stateWaitForInteraction:
    call CheckLinkInteractionWithEntity_06
    ret  nc
    ; Open dialog with seed nr
    ld   a, $00
    call OpenDialogInTable0
    ld   a, [sRandStateLocked]
    and  a, a
    ld   hl, SeedMessage
    ld   bc, SeedMessage.end - SeedMessage
    if   nz {
        ld   hl, SeedLockedMessage
        ld   bc, SeedLockedMessage.end - SeedLockedMessage
    }
    ld   de, wMessageBuffer
    call CopyData
    
    ld   hl, wMessageBuffer + 6
    ld   de, wRandState
    call setupHexDigits
    call setupHexDigits
    call setupHexDigits
    call setupHexDigits

    jp   IncrementEntityState

.stateInDialog:
    ; Block normal dialog interaction
    ld   a, $01
    ld   [wC1AB], a
    ld   a, [wDialogState]
    and  $0F
    cp   $0C
    ret  nz ; Not in "wait for close" state

    ld   a, $68
    ld   [wOAMBuffer+$18], a
    ld   a, [wDialogAskSelectionIndex]
    add  a, a
    add  a, a
    add  a, a
    add  a, $48
    ld   [wOAMBuffer+$19], a
    ld   a, $A2
    ld   [wOAMBuffer+$1A], a
    ld   a, $02
    ld   [wOAMBuffer+$1B], a

    ldh  a, [hJoypadState]
    bit  0, a
    jr   nz, .right
    bit  1, a
    jr   nz, .left
    bit  2, a
    jr   nz, .up
    bit  3, a
    jr   nz, .down
    bit  6, a
    jr   nz, .select
    and  a, $B0 ; A/B/Start
    jr   nz, .start

    ret

.right:
    ld   a, [wDialogAskSelectionIndex]
    cp   7
    ret  nc
    inc  a
    ld   [wDialogAskSelectionIndex], a
    ret

.left:
    ld   a, [wDialogAskSelectionIndex]
    and  a, a
    ret  z
    dec  a
    ld   [wDialogAskSelectionIndex], a
    ret

.up:
    ld   a, [wDialogAskSelectionIndex]
    srl  a
    pushpop af {
        ld  d, b
        ld  e, a
        ld  hl, wRandState
        add hl, de
    }
    ld   a, [hl]
    ld   d, a
    if nc { ; upper nibble
        add  a, $10
        and  a, $F0
        ld   e, a
        ld   a, d
        and  a, $0F
        or   e
    } else {
        inc  a
        and  a, $0F
        ld   e, a
        ld   a, d
        and  a, $F0
        or   e
    }
    ld   [hl], a
    jp .drawCurrentSeedDigit

.down:
    ld   a, [wDialogAskSelectionIndex]
    srl  a
    pushpop af {
        ld  d, b
        ld  e, a
        ld  hl, wRandState
        add hl, de
    }
    ld   a, [hl]
    ld   d, a
    if nc { ; upper nibble
        sub  a, $10
        and  a, $F0
        ld   e, a
        ld   a, d
        and  a, $0F
        or   e
    } else {
        dec  a
        and  a, $0F
        ld   e, a
        ld   a, d
        and  a, $F0
        or   e
    }
    ld   [hl], a
    jp .drawCurrentSeedDigit

.select:
    call EnableSRAM
    ld   hl, sRandStateLocked
    ld   a, [hl]
    xor  1
    ld   [hl], a
    ; Fall through to close to get the new dialog setup.
.start:
    xor  a
    ld   [wDialogOpenCloseAnimationFrame], a
    ld   a, [wDialogState]
    and  $F0
    or   $0E
    ld   [wDialogState], a
    call IncrementEntityState
    ld   [hl], b
    call LSD_CopyRandStateToSRAM
    ret

.drawCurrentSeedDigit:
    ; Draw the letter targeted by wDialogAskSelectionIndex, current value from wRandState is still in a when entering
    ld   hl, wDialogAskSelectionIndex
    bit  0, [hl]
    if nz { ; lower nibble
        swap a
    }
    and  $F0

    ld  d, 0
    ld  e, a
    cp  $A0
    if nc {
        ld  hl, FontTiles - $0A0
    } else {
        ld  hl, FontTiles + $700
    }
    add hl, de
    ld16 de, hl

    ld  hl, wDrawCommand
    ld  [hl], $8D
    inc hl
    ld  a, [wDialogAskSelectionIndex]
    swap a
    add a, $60
    ld  [hl+], a
    ld  [hl], $0F
    inc hl
    ld  a, BANK(FontTiles)
    pushpop bc {
        ld  c, $10
        call LSD_CopyDataFromBank
    }
    ld  [hl], $00
    ld  a, $13
    ld  [wDrawCommandsSize], a
    ret

setupHexDigits:
    ld   a, [de]
    swap a
    and  $0F
    add  a, $30
    cp   $3A
    if nc {
        add a, 7
    }
    ld   [hl+], a

    ld   a, [de]
    and  $0F
    add  a, $30
    cp   $3A
    if nc {
        add a, 7
    }
    ld   [hl+], a
    inc  de
    ret
}

#SECTION "LSD_CopyDataFromBank", ROM0 {
; Copy C bytes from DE in bank A to HL
LSD_CopyDataFromBank:
    ld  [$2100], a
    loop c {
        ld  a, [de]
        ld  [hl+], a
        inc de
    }
    jp  RestoreBankAndReturn
}