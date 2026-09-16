section "HomeHackAdditions", rom0
copyDataVRAM::
    ldh  [hMultiPurpose0], a
    ld   a, [wCurrentBank]
    ldh  [hMultiPurpose1], a
    ldh  a, [hMultiPurpose0]
    call SwitchAdjustedBank

:   ld   a, [rSTAT]
    and  STATF_LCD
    jr   nz, :-
    ld   a, [de]
    ld   [hl+], a
    inc  de
    dec  bc
    ld   a, b
    or   c
    jr   nz, :-

    ldh  a, [hMultiPurpose1]
    call SwitchBank
    ret
