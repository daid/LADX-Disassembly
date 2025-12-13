#SECTION "VRAMInitGFX", ROMX[$4000], BANK[$3F] {
VRAM1InitGfx:
    #INCGFX "LSD/gfx/vram1.png", TILEHEIGHT[16], COLORMAP[$FFFFFF, $AAAAAA, $555555, $000000]
}

#SECTION "VRAMInit", ROMX, BANK[$3F] {
LSD_VRAM1_init:
    ld   a, 1
    ldh  [rVBK], a
    xor  a
    ld   [rLCDC], a

    ld  hl, rHDMA1
    ld  [hl], HIGH(VRAM1InitGfx)
    inc hl
    ld  [hl], LOW(VRAM1InitGfx)
    inc hl
    ld  [hl], HIGH($8000)
    inc hl
    ld  [hl], LOW($8800)
    inc hl
    ld  [hl], $80 - 1
    ld  [hl], $80 - 1

    xor  a
    ldh  [rVBK], a
    ret
}