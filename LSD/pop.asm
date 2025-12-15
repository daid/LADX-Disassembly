#SECTION "LSD_UpdatePowerupTime", ROMX, BANK[2] {
LSD_UpdatePowerupTime:
    ld   a, [wActivePowerUp]
    dec  a
    ret  nz
    ldh  a, [hFrameCounter]
    and  a, a ; increase wPowerUpHits every 256 frames ~ 4.2 seconds
    ret  nz

    ld   hl, wPowerUpHits
    inc  [hl]
    ld   a, [hl]
    cp   $03
    ret  c

    ; After 3 times getting hit, or 12.6 seconds, end piece of power
    xor  a
    ld   [wActivePowerUp], a
    ld   a, [wInBossBattle]
    and  a
    ret  nz

    ldh  a, [hDefaultMusicTrack]
    cp   $22 ; MUSIC_OWL
    jr   z, .skip
    ld   [wMusicTrackToPlay], a
.skip:
    ldh  [hNextDefaultMusicTrack], a
    ret
}