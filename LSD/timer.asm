
#SECTION "LSD_updateIngameTimer", ROM0 {
LSD_updateIngameTimer:
    ld   a, [wGameplayType] ;Get the gameplay type
    dec  a          ; and if it was 1
    ret  z          ; we are at the credits and the counter should stop.

    ; Check if the timer expired
    ld   hl, $FF0F
    bit  2, [hl]
    ret  z
    res  2, [hl]

    ; Increase the "subsecond" counter, and continue if it "overflows"
    call EnableSRAM ; Enable SRAM
    ld   hl, sLSDIngameTimer
    ld   a, [hl]
    inc  a
    cp   $20
    ld   [hl], a
    ret  nz
    xor  a
    ld   [hl+], a

    ; Increase the seconds counter/minutes/hours counter
increaseSecMinHours:
    ld   a, [hl]
    inc  a
    daa
    ld   [hl], a
    cp   $60
    ret  nz
    xor  a
    ld   [hl+], a
    jr   increaseSecMinHours
}
