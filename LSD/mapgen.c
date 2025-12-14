#include "asm.h"
#pragma bank 0x0A

#define DIR_RIGHT 0
#define DIR_LEFT 1
#define DIR_DOWN 2
#define DIR_UP 3

#define ROOM_START     0x80
#define ROOM_FINAL     0x40
#define ROOM_SIDE_PATH 0x20
#define ROOM_TREASURE  0x10

uint8_t generateRandomMove(uint8_t from);
uint8_t doMove(uint8_t from, uint8_t dir);
uint8_t flipDir(uint8_t dir);

const uint8_t random_treasure_list[16] = {
    0x1B, 0x1C, 0x1D, 0x82,
    0x1B, 0x1C, 0x1D, 0x85,
    0x1B, 0x1C, 0x90, 0x8E,
    0x1B, 0x1C, 0x91, 0x8F,
};

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
    randomMapData[start_room] |= ROOM_FINAL | (1 << DIR_DOWN);
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
    randomMapData[current_room] |= ROOM_START;

    //Build side paths
    safety = 0;
    for(uint8_t count=0; count<6; ) {
        if (++safety == 0) goto retry;
        current_room = rand8() & 0x3F;
        if (!randomMapData[current_room]) continue;
        if (randomMapData[current_room] & ROOM_FINAL) continue; // no side paths from final room.
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (randomMapData[target_room]) continue;
        randomMapData[current_room] |= 1 << move_dir;
        randomMapData[target_room] |= 1 << (move_dir ^ 1);
        randomMapData[target_room] |= ROOM_SIDE_PATH;
        count++;
    }

    //Build cycles paths
    safety = 0;
    for(uint8_t count=0; count<5; ) {
        if (++safety == 0) goto retry;
        current_room = rand8() & 0x3F;
        if (!randomMapData[current_room]) continue;
        if (randomMapData[current_room] & ROOM_FINAL) continue; // no cycles from final room.
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (!randomMapData[target_room]) continue;
        if (randomMapData[target_room] & ROOM_FINAL) continue; // no cycles from final room.
        randomMapData[current_room] |= 1 << move_dir;
        randomMapData[target_room] |= 1 << (move_dir ^ 1);
        count++;
    }

    for(uint8_t n=0; n<64; n++) {
        if (randomMapData[n] & (ROOM_START | ROOM_FINAL)) continue;
        if (rand8() < 64) {
            randomMapData[n] |= ROOM_TREASURE;
        }
        if ((randomMapData[n] & ROOM_SIDE_PATH) && (rand8() < 128)) {
            randomMapData[n] |= ROOM_TREASURE;
        }
    }

    SET_SRAM_BANK_CONTAINING(sDungeonMinimap);
    // Update the minimap
    for(uint8_t n=0; n<64; n++) {
        if (randomMapData[n])
            sDungeonMinimap[n] = 0xEF;
        else
            sDungeonMinimap[n] = 0x7D;
        sDungenChestContents[n] = random_treasure_list[rand8() & 0x0F];
    }

    for(uint8_t n=0; n<64; n++) {
getDifferentRoomData:
        const uint8_t* static_room_data_ptr = RandomRoomDataTable[rand8range(RandomRoomDataTableSize)];
        uint8_t mask_data = randomMapData[n] & (*static_room_data_ptr++);
        if (mask_data != *static_room_data_ptr++)
            goto getDifferentRoomData;
        SET_SRAM_BANK_CONTAINING(sDynamicRoomData);
        uint8_t* dynamic_room_data_ptr = &sDynamicRoomData[((uint16_t)n) * 0x80];
        uint8_t copy_size = *static_room_data_ptr++;
        do {
            *dynamic_room_data_ptr++ = *static_room_data_ptr++;
        } while(--copy_size);

        if (randomMapData[n] & (1 << DIR_RIGHT)) {
            *dynamic_room_data_ptr++ = 0x39;
            *dynamic_room_data_ptr++ = 0xF7;
        }
        if (randomMapData[n] & (1 << DIR_LEFT)) {
            *dynamic_room_data_ptr++ = 0x30;
            *dynamic_room_data_ptr++ = 0xF6;
        }
        if (randomMapData[n] & (1 << DIR_DOWN)) {
            *dynamic_room_data_ptr++ = 0x74;
            *dynamic_room_data_ptr++ = 0xF5;
        }
        if (randomMapData[n] & (1 << DIR_UP)) {
            *dynamic_room_data_ptr++ = 0x04;
            *dynamic_room_data_ptr++ = 0xF4;
        }
        uint8_t variation_count = *static_room_data_ptr++;
        while(variation_count) {
            if (rand8() <= *static_room_data_ptr++) {
                const uint8_t* variation_ptr = *(const uint8_t**)static_room_data_ptr;
                copy_size = *variation_ptr++;
                do {
                    *dynamic_room_data_ptr++ = *variation_ptr++;
                } while(--copy_size);
            }
            static_room_data_ptr += 2;
            variation_count -= 1;
        }
        *dynamic_room_data_ptr = 0xFE;

        SET_SRAM_BANK_CONTAINING(sDynamicEntityData);
        uint8_t* dynamic_entity_data_ptr = &sDynamicEntityData[((uint16_t)n) * 0x80];
        uint8_t entity_set_count = *static_room_data_ptr++;
        uint8_t entity_set_nr = rand8range(entity_set_count);
        const uint8_t* entity_data_ptr = *(const uint8_t**)&static_room_data_ptr[entity_set_nr * 4 + 2];
        copy_size = *entity_data_ptr++;
        while(copy_size--) {
            *dynamic_entity_data_ptr++ = *entity_data_ptr++;
        }
        *dynamic_entity_data_ptr++ = 0xFF;
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
