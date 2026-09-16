ClearEntityStatus_3E::
    ld   hl, wEntitiesStatusTable
    add  hl, bc
    ld   [hl], b
    ret

GetEntitySpeedYAddress_3E::
    ld   hl, wEntitiesSpeedYTable
    add  hl, bc
    ret

UpdateEntityPosWithSpeed_3E::
    call AddEntitySpeedToPos_3E
    push bc
    ld   a, c
    add  $10
    ld   c, a
    call AddEntitySpeedToPos_3E
    pop  bc
    ret

; Update the entity's position using its speed.
;
; The values in the entity speed tables are the number of pixels to
; move within 16 frames. For example, if it's 8, the entity will move
; 1 pixel every other frame (8/16). If it's -16, the entity will move
; -1 pixel every frame (-16/16).
;
; Inputs:
;   bc  entity index
AddEntitySpeedToPos_3E::
    ld   hl, wEntitiesSpeedXTable
    add  hl, bc
    ld   a, [hl]
    and  a
    ; No need to update the position if it's not moving
    jr   z, .return

    push af
    swap a
    and  $F0
    ld   hl, wEntitiesSpeedXAccTable
    add  hl, bc
    add  [hl]
    ld   [hl], a
    ; Save carry in bit 0 of d
    rl   d
    ld   hl, wEntitiesPosXTable

.updatePosition
    add  hl, bc
    pop  af
    ; Sign extension for high nibble
    ld   e, $00
    bit  7, a
    jr   z, .positive

    ld   e, $F0

.positive
    swap a
    and  $0F
    or   e
    ; Get carry back from d
    rr   d
    adc  [hl]
    ld   [hl], a

.return
    ret
