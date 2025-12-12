#include "asm.h"
#pragma bank 0x0A

#define DIR_RIGHT 0
#define DIR_LEFT 1
#define DIR_UP 2
#define DIR_DOWN 3

extern uint8_t randomMapData[0x40];
extern __sfr hMapRoom;

uint8_t generateRandomMove(uint8_t from);
uint8_t doMove(uint8_t from, uint8_t dir);
uint8_t flipDir(uint8_t dir);

void generateRandomMap(void)
{
retry:
    for(uint8_t n=0; n<0x40; n++)
        randomMapData[n] = 0;

    //Build the main path
    uint8_t safety = 0;
    uint8_t start_room = rand8() & 0x3F;
    hMapRoom = start_room;
    uint8_t current_room = start_room;
    for(uint8_t count=0; count<10;) {
        if (++safety == 0) goto retry;
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (randomMapData[target_room]) continue;
        randomMapData[current_room] |= 1 << move_dir;
        randomMapData[target_room] |= 1 << (move_dir ^ 1);
        current_room = target_room;
        count++;
    }
    //Mark final room
    randomMapData[current_room] |= 0x80;

    //Build side paths
    safety = 0;
    for(uint8_t count=0; count<6; ) {
        if (++safety == 0) goto retry;
        current_room = rand8() & 0x3F;
        if (!randomMapData[current_room]) continue;
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (randomMapData[target_room]) continue;
        randomMapData[current_room] |= 1 << move_dir;
        randomMapData[target_room] |= 1 << (move_dir ^ 1);
        count++;
    }

    //Build cycles paths
    safety = 0;
    for(uint8_t count=0; count<5; ) {
        if (++safety == 0) goto retry;
        current_room = rand8() & 0x3F;
        if (!randomMapData[current_room]) continue;
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (!randomMapData[target_room]) continue;
        randomMapData[current_room] |= 1 << move_dir;
        randomMapData[target_room] |= 1 << (move_dir ^ 1);
        count++;
    }
}


uint8_t generateRandomMove(uint8_t from)
{
    uint8_t move_dir = rand8() & 3;
    switch(move_dir) {
    case DIR_RIGHT: //right
        if ((from & 0x07) == 0x07) return 0xFF;
        return move_dir;
    case DIR_LEFT: //left
        if ((from & 0x07) == 0) return 0xFF;
        return move_dir;
    case DIR_UP: //up
        if ((from & 0x38) == 0) return 0xFF;
        return move_dir;
    case DIR_DOWN: //down
        if ((from & 0x38) == 0x38) return 0xFF;
        return move_dir;
    }
}

uint8_t doMove(uint8_t from, uint8_t dir)
{
    switch(dir) {
    case DIR_RIGHT: return from + 1;
    case DIR_LEFT: return from - 1;
    case DIR_UP: return from - 8;
    case DIR_DOWN: return from + 8;
    }
    return from;
}

/*
; e = source room
; d = target room
; b = direction
setRoomEdgeOpen:
    ld   h, HIGH(wRandomMapData)
    ld   a, b
    and  a
    jr   z, .right
    dec  a
    jr   z, .left
    dec  a
    jr   z, .up
.down:
    ld   l, e
    set  7, [hl]
    set  2, [hl]
    ld   l, d
    set  7, [hl]
    set  3, [hl]
    ret
.up:
    ld   l, e
    set  7, [hl]
    set  3, [hl]
    ld   l, d
    set  7, [hl]
    set  2, [hl]
    ret
.left:
    ld   l, e
    set  7, [hl]
    set  1, [hl]
    ld   l, d
    set  7, [hl]
    set  0, [hl]
    ret
.right:
    ld   l, e
    set  7, [hl]
    set  0, [hl]
    ld   l, d
    set  7, [hl]
    set  1, [hl]
    ret
*/