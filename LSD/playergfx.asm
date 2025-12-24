
#SECTION "PlayerGfxLinkMatty", ROMX[$4000], BANK[$0C] {
LSD_PlayerLink:
    #INCGFX "LSD/gfx/player/Link.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerMatty:
    #INCGFX "LSD/gfx/player/Matty.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxAgesGirlBowwow", ROMX[$4000], BANK[$28] {
LSD_PlayerAgesGirl:
    #INCGFX "LSD/gfx/player/AgesGirl.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerBowwow:
    #INCGFX "LSD/gfx/player/Bowwow.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxBunnyGrandmaUlrira", ROMX[$4000], BANK[$29] {
LSD_PlayerBunny:
    #INCGFX "LSD/gfx/player/Bunny.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerGrandmaUlrira:
    #INCGFX "LSD/gfx/player/GrandmaUlrira.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxKirbyLuigi", ROMX[$4000], BANK[$2A] {
LSD_PlayerKirby:
    #INCGFX "LSD/gfx/player/Kirby.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerLuigi:
    #INCGFX "LSD/gfx/player/Luigi.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxMarinMarinAlpha", ROMX[$4000], BANK[$2B] {
LSD_PlayerMarin:
    #INCGFX "LSD/gfx/player/Marin.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerMarinAlpha:
    #INCGFX "LSD/gfx/player/MarinAlpha.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxMarioMartha", ROMX[$4000], BANK[$37] {
LSD_PlayerMario:
    #INCGFX "LSD/gfx/player/Mario.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerMartha:
    #INCGFX "LSD/gfx/player/Martha.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxMemeMMLink", ROMX[$4000], BANK[$39] {
LSD_PlayerMeme:
    #INCGFX "LSD/gfx/player/Meme.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerMMLink:
    #INCGFX "LSD/gfx/player/MMLink.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxNESLinkNinten", ROMX[$4000], BANK[$3A] {
LSD_PlayerNESLink:
    #INCGFX "LSD/gfx/player/NESLink.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerNinten:
    #INCGFX "LSD/gfx/player/Ninten.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxRichardRicky", ROMX[$4000], BANK[$3B] {
LSD_PlayerRichard:
    #INCGFX "LSD/gfx/player/Richard.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerRicky:
    #INCGFX "LSD/gfx/player/Ricky.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxRoosterRosa", ROMX[$4000], BANK[$3D] {
LSD_PlayerRooster:
    #INCGFX "LSD/gfx/player/Rooster.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerRosa:
    #INCGFX "LSD/gfx/player/Rosa.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxSariaSig", ROMX[$4000], BANK[$0E] {
LSD_PlayerSaria:
    #INCGFX "LSD/gfx/player/Saria.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerSig:
    #INCGFX "LSD/gfx/player/Sig.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxSubrosianTarin", ROMX[$4000], BANK[$11] {
LSD_PlayerSubrosian:
    #INCGFX "LSD/gfx/player/Subrosian.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
LSD_PlayerTarin:
    #INCGFX "LSD/gfx/player/Tarin.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}
#SECTION "PlayerGfxX", ROMX[$6000], BANK[$3F] {
LSD_PlayerX:
    #INCGFX "LSD/gfx/player/X.png", TILEHEIGHT[16], COLORMAP[$800080, $000000, $808080, $FFFFFF]
}

#SECTION "LSD_GFXSelect", ROMX, BANK[$01] {
LSD_PlayerGfxTable:
    db   BANK(LSD_PlayerLink), HIGH(LSD_PlayerLink)
    db   BANK(LSD_PlayerMatty), HIGH(LSD_PlayerMatty)
    db   BANK(LSD_PlayerAgesGirl), HIGH(LSD_PlayerAgesGirl)
    db   BANK(LSD_PlayerBowwow), HIGH(LSD_PlayerBowwow)
    db   BANK(LSD_PlayerBunny), HIGH(LSD_PlayerBunny)
    db   BANK(LSD_PlayerGrandmaUlrira), HIGH(LSD_PlayerGrandmaUlrira)
    db   BANK(LSD_PlayerKirby), HIGH(LSD_PlayerKirby)
    db   BANK(LSD_PlayerLuigi), HIGH(LSD_PlayerLuigi)
    db   BANK(LSD_PlayerMarin), HIGH(LSD_PlayerMarin)
    db   BANK(LSD_PlayerMarinAlpha), HIGH(LSD_PlayerMarinAlpha)
    db   BANK(LSD_PlayerMario), HIGH(LSD_PlayerMario)
    db   BANK(LSD_PlayerMartha), HIGH(LSD_PlayerMartha)
    db   BANK(LSD_PlayerMeme), HIGH(LSD_PlayerMeme)
    db   BANK(LSD_PlayerMMLink), HIGH(LSD_PlayerMMLink)
    db   BANK(LSD_PlayerNESLink), HIGH(LSD_PlayerNESLink)
    db   BANK(LSD_PlayerNinten), HIGH(LSD_PlayerNinten)
    db   BANK(LSD_PlayerRichard), HIGH(LSD_PlayerRichard)
    db   BANK(LSD_PlayerRicky), HIGH(LSD_PlayerRicky)
    db   BANK(LSD_PlayerRooster), HIGH(LSD_PlayerRooster)
    db   BANK(LSD_PlayerRosa), HIGH(LSD_PlayerRosa)
    db   BANK(LSD_PlayerSaria), HIGH(LSD_PlayerSaria)
    db   BANK(LSD_PlayerSig), HIGH(LSD_PlayerSig)
    db   BANK(LSD_PlayerSubrosian), HIGH(LSD_PlayerSubrosian)
    db   BANK(LSD_PlayerTarin), HIGH(LSD_PlayerTarin)
    db   BANK(LSD_PlayerX), HIGH(LSD_PlayerX)
.end:

LSD_FileCreationPrepareGfxSelect1:
    ; TODO: Clear letters
    ld   a, 0
    ld   [wNameEntryCurrentChar], a

    ld   a, BANK(LSD_PlayerLink)
    ld   [wPhotos1], a
    ld   a, HIGH(LSD_PlayerLink)
    ld   [wPhotos2], a

    ld   a, $7D
    ld   hl, $98C2
    ld   de, $0020 - 16
    loop b, 8 {
        call LSD_FileCreationClearLetterLine
        add  hl, de
    }

    jp   IncrementGameplaySubtype

LSD_FileCreationClearLetterLine:
    loop c, 16 {
    .retry:
        ld   [hl], a
        cp   [hl]
        jr   nz, .retry
        inc  hl
    }
    ret

LSD_FileCreationPrepareGfxSelect2:
    ld   a, [wDrawCommand]
    and  a, a
    ret  nz

    ; Get entry from LSD_PlayerGfxTable in HL
    ld   a, [wNameEntryCurrentChar]
    add  a, a
    ld   hl, LSD_PlayerGfxTable
    ld   d, 0
    ld   e, a
    add  hl, de

    ; Build the draw command for the VRAM tiles
    push hl

    ld   hl, wDrawCommand
    ld   [hl], $80
    inc  hl
    ld   [hl], $00
    inc  hl
    ld   [hl], $20 - 1
    inc  hl
    pop  de
    ld   a, [de]
    ld   b, a ; bank nr
    inc  de
    ld   a, [de]
    ld   d, a
    ld   e, 0
    ld   a, b
    ld   c, $20
    call LSD_CopyDataFromBank
    ld   [hl], $80
    inc  hl
    ld   [hl], $20
    inc  hl
    ld   [hl], $20 - 1
    inc  hl
    ld   a, b
    ld   c, $20
    call LSD_CopyDataFromBank

    ld   [hl], 0
    ld   a, $20 + 3 + $20 + 3
    ld   [wDrawCommandsSize], a

    jp   IncrementGameplaySubtype

LSD_FileCreationGfxSelectOAMBuffer:
    db   $50, $40, $00, $00, $50, $48, $02, $00
    db   $50, $40, $02, $20, $50, $48, $00, $20

LSD_FileCreationInteractiveGfxSelect:
    ld   hl, LSD_FileCreationGfxSelectOAMBuffer
    ldh  a, [hFrameCounter]
    and  a, $08
    if   z {
        ld   hl, LSD_FileCreationGfxSelectOAMBuffer + 8
    }
    ld   de, wOAMBuffer
    ld   bc, 8
    call CopyData

    ldh  a, [hJoypadState]
    bit  2, a ; J_UP
    jr   nz, .up
    bit  3, a ; J_DOWN
    jr   nz, .down
    bit  7, a ; J_START
    jr   nz, .done
    ret
.up:
    ld   a, [wNameEntryCurrentChar]
    inc  a
    cp   (LSD_PlayerGfxTable.end - LSD_PlayerGfxTable) / 2
    if z {
        xor a
    }
    ld   [wNameEntryCurrentChar], a
    ld   hl, wGameplaySubtype
    ld   [hl], $04
    ret
.down:
    ld   a, [wNameEntryCurrentChar]
    dec  a
    cp   $FF
    if z {
        ld a, (LSD_PlayerGfxTable.end - LSD_PlayerGfxTable) / 2 - 1
    }
    ld   [wNameEntryCurrentChar], a
    ld   hl, wGameplaySubtype
    ld   [hl], $04
    ret

.done:
    ld   a, [wNameEntryCurrentChar]
    add  a, a
    ld   hl, LSD_PlayerGfxTable
    ld   d, 0
    ld   e, a
    add  hl, de
    push hl

    ; Store GFX bank/offset in SRAM in wPhotos1/2
    ld   hl, SaveGameTable
    ld   d, 0
    ld   a, [wSaveSlot]
    add  a, a
    ld   e, a
    add  hl, de
    ld   a, [hl+]
    ld   h, [hl]
    ld   l, a
    ld   de, SaveGame1.dx3 - SaveGame1.main + 1
    add  hl, de
    pop  de
    ld   a, [de]
    inc  de
    ld   [hl+], a
    ld   a, [de]
    ld   [hl+], a

    jp   label_001_4555
}
