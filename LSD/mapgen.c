#include "asm.h"
#pragma bank 0x0A

#define DIR_RIGHT 0
#define DIR_LEFT 1
#define DIR_DOWN 2
#define DIR_UP 3

extern uint8_t randomMapData[0x40];
extern uint8_t sDungeonMinimap[0x40];
extern __sfr hMapRoom;
extern uint8_t rRAMB;
extern uint8_t b_sDungeonMinimap;

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
    if ((start_room & 0x38) == 38) goto retry; // Final room cannot be a the bottom row.
    //Mark the final room, and make a door downwards
    randomMapData[start_room] |= 0x80 | (1 << DIR_DOWN);
    uint8_t current_room = start_room + 8;
    randomMapData[current_room] |= (1 << DIR_UP);
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
    //Mark start room
    hMapRoom = current_room;
    randomMapData[current_room] |= 0x40;

    //Build side paths
    safety = 0;
    for(uint8_t count=0; count<6; ) {
        if (++safety == 0) goto retry;
        current_room = rand8() & 0x3F;
        if (!randomMapData[current_room]) continue;
        if (randomMapData[current_room] & 0x80) continue; // no side paths from final room.
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
        if (randomMapData[current_room] & 0x80) continue; // no cycles from final room.
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (!randomMapData[target_room]) continue;
        if (randomMapData[target_room] & 0x80) continue; // no cycles from final room.
        randomMapData[current_room] |= 1 << move_dir;
        randomMapData[target_room] |= 1 << (move_dir ^ 1);
        count++;
    }

    // Update the minimap
    for(uint8_t n=0; n<64; n++) {
        if (randomMapData[n])
            sDungeonMinimap[n] = 0xEF;
        else
            sDungeonMinimap[n] = 0x7D;
    }
}


uint8_t generateRandomMove(uint8_t from)
{
    uint8_t move_dir = rand8() & 3;
    switch(move_dir) {
    case DIR_RIGHT:
        if ((from & 0x07) == 0x07) return 0xFF;
        return move_dir;
    case DIR_LEFT:
        if ((from & 0x07) == 0) return 0xFF;
        return move_dir;
    case DIR_DOWN:
        if ((from & 0x38) == 0x38) return 0xFF;
        return move_dir;
    case DIR_UP:
        if ((from & 0x38) == 0) return 0xFF;
        return move_dir;
    }
}

uint8_t doMove(uint8_t from, uint8_t dir)
{
    switch(dir) {
    case DIR_RIGHT: return from + 1;
    case DIR_LEFT: return from - 1;
    case DIR_DOWN: return from + 8;
    case DIR_UP: return from - 8;
    }
    return from;
}
