#include "asm.h"
#include "treasure.h"
#pragma bank 0x0A

#define DIR_RIGHT 0
#define DIR_LEFT 1
#define DIR_DOWN 2
#define DIR_UP 3

#define ROOM_DOOR_RIGHT (1 << DIR_RIGHT)
#define ROOM_DOOR_LEFT (1 << DIR_LEFT)
#define ROOM_DOOR_DOWN (1 << DIR_DOWN)
#define ROOM_DOOR_UP (1 << DIR_UP)

#define ROOM_LOCK_RIGHT (0x10 << DIR_RIGHT)
#define ROOM_LOCK_LEFT (0x10 << DIR_LEFT)
#define ROOM_LOCK_DOWN (0x10 << DIR_DOWN)
#define ROOM_LOCK_UP (0x10 << DIR_UP)

#define ROOM_TYPE_NORMAL   0x00
#define ROOM_TYPE_ENTRANCE 0x01
#define ROOM_TYPE_EXIT     0x02
#define ROOM_TYPE_TREASURE 0x03
#define ROOM_TYPE_SPECIAL  0x04
#define ROOM_TYPE_FINAL    0x05

#define ROOM_SECOND_HALF   0x01
#define ROOM_MAIN_PATH     0x02
#define ROOM_SIDE_PATH     0x04

uint8_t generateRandomMove(uint8_t from);
uint8_t doMove(uint8_t from, uint8_t dir);
uint8_t flipDir(uint8_t dir);

const uint8_t random_treasure_list[] = {
    TREASURE_RUPEES_50, TREASURE_RUPEES_20, TREASURE_RUPEES_100, TREASURE_BOMBS,
    TREASURE_RUPEES_50, TREASURE_RUPEES_20, TREASURE_RUPEES_100, TREASURE_BOW,
    TREASURE_RUPEES_50, TREASURE_COMPASS, TREASURE_POTION_2, TREASURE_PIECE_OF_POWER,
    TREASURE_RUPEES_50, TREASURE_POWDER, TREASURE_MAP, TREASURE_POTION_1,
    TREASURE_PIECE_OF_HEART, TREASURE_PIECE_OF_HEART, TREASURE_PIECE_OF_HEART, TREASURE_PIECE_OF_HEART,
    TREASURE_RUPEES_50, TREASURE_RUPEES_20, TREASURE_RUPEES_100, TREASURE_SHIELD,
    TREASURE_PIECE_OF_POWER, TREASURE_POTION_1, TREASURE_POWDER, TREASURE_BOMBS,
    TREASURE_RUPEES_100, TREASURE_RUPEES_100, TREASURE_RUPEES_200, TREASURE_RUPEES_200,
    TREASURE_FAIRY_BOTTLE,
};

void generateRandomMap(void)
{
    uint8_t main_path_length = 7 + dungeonDepth;
    uint8_t main_path_split = (main_path_length >> 1) - 3 + (rand8() & 3);
    uint8_t side_path_count = 3 + (dungeonDepth << 1);

    hMapId = rand8() & 7;

retry:
    for(uint8_t n=0; n<0x40; n++) {
        randomMapDataFlags[n] = 0;
        randomMapDataID[n] = 0;
        randomMapDataTmp[n] = 0;
    }

    if (dungeonDepth > 5) {
        //Time to fight the final nightmare
        hMapRoom = 0;
        randomMapDataID[0] = ROOM_TYPE_FINAL;
        hMapId = 8;
        return;
    }

    //Build the main path
    uint8_t safety = 0;
    uint8_t start_room = rand8() & 0x3F;
    if ((start_room & 0x38) == 38) goto retry; // Final room cannot be a the bottom row.
    //Mark the final room, and make a door downwards
    randomMapDataFlags[start_room] = ROOM_DOOR_DOWN;
    randomMapDataID[start_room] = ROOM_TYPE_EXIT;
    randomMapDataTmp[start_room] = ROOM_MAIN_PATH | ROOM_SECOND_HALF;
    //Move one room down.
    uint8_t current_room = start_room + 8;
    randomMapDataFlags[current_room] = ROOM_DOOR_UP;
    randomMapDataTmp[current_room] = ROOM_MAIN_PATH | ROOM_SECOND_HALF;
    for(uint8_t count=0; count<main_path_length;) {
        if (++safety == 0) goto retry;
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (randomMapDataFlags[target_room]) continue;
        randomMapDataFlags[current_room] |= 1 << move_dir;
        randomMapDataFlags[target_room] |= 1 << (move_dir ^ 1);
        if (count < main_path_split)
            randomMapDataTmp[target_room] = ROOM_MAIN_PATH | ROOM_SECOND_HALF;
        else
            randomMapDataTmp[target_room] = ROOM_MAIN_PATH;
        current_room = target_room;
        count++;
    }
    //Mark start room
    hMapRoom = current_room;
    randomMapDataID[current_room] = ROOM_TYPE_ENTRANCE;

    //Build side paths
    safety = 0;
    for(uint8_t count=0; count<side_path_count; ) {
        if (++safety == 0) goto retry;
        current_room = rand8() & 0x3F;
        if (!randomMapDataFlags[current_room]) continue;
        if (randomMapDataID[current_room] == ROOM_TYPE_EXIT) continue; // no side paths from final room.
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (randomMapDataFlags[target_room]) continue;
        randomMapDataFlags[current_room] |= 1 << move_dir;
        randomMapDataFlags[target_room] |= 1 << (move_dir ^ 1);
        // Set sidepaths to 5 or 6 depending on where they connect
        randomMapDataTmp[target_room] = (randomMapDataTmp[current_room] & ~ROOM_MAIN_PATH) | ROOM_SIDE_PATH;
        count++;
    }

    //Build cycles paths
    safety = 0;
    for(uint8_t count=0; count<4; ) {
        if (++safety == 0) goto retry;
        current_room = rand8() & 0x3F;
        if (!randomMapDataFlags[current_room]) continue;
        if (randomMapDataID[current_room] == ROOM_TYPE_EXIT) continue; // no cycles from final room.
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if (!randomMapDataFlags[target_room]) continue;
        if (randomMapDataID[target_room] == ROOM_TYPE_EXIT) continue; // no cycles from final room.
        if ((randomMapDataTmp[current_room] & ROOM_SECOND_HALF) != (randomMapDataTmp[target_room] & ROOM_SECOND_HALF)) continue; // No cycles from first to second half
        randomMapDataFlags[current_room] |= 1 << move_dir;
        randomMapDataFlags[target_room] |= 1 << (move_dir ^ 1);
        count++;
    }

    //Search for a connection from tmp == 1 tot tmp == 2 (first half to second half) and add a key door
    while(1) {
        current_room = rand8() & 0x3F;
        if (!(randomMapDataTmp[current_room] & ROOM_MAIN_PATH)) continue;
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if ((randomMapDataTmp[current_room] ^ ROOM_SECOND_HALF) != randomMapDataTmp[target_room]) continue;
        if (!(randomMapDataFlags[current_room] & (1 << move_dir))) continue;
        randomMapDataFlags[current_room] |= 0x10 << move_dir;
        randomMapDataFlags[target_room] |= 0x10 << (move_dir ^ 1);
        break;
    }
    //Search for a connection from main path to side path and add a key door
    while(1) {
        current_room = rand8() & 0x3F;
        if (!(randomMapDataTmp[current_room] & ROOM_MAIN_PATH)) continue;
        uint8_t move_dir = generateRandomMove(current_room);
        if (move_dir == 0xFF) continue;
        uint8_t target_room = doMove(current_room, move_dir);
        if ((randomMapDataTmp[target_room] & ROOM_MAIN_PATH)) continue;
        if (!(randomMapDataFlags[current_room] & (1 << move_dir))) continue;
        randomMapDataFlags[current_room] |= 0x10 << move_dir;
        randomMapDataFlags[target_room] |= 0x10 << (move_dir ^ 1);
        break;
    }

    // Find a spot in first half main path to put a key
    while(1) {
        current_room = rand8() & 0x3F;
        if (!(randomMapDataTmp[current_room] & ROOM_MAIN_PATH)) continue;
        if ((randomMapDataTmp[current_room] & ROOM_SECOND_HALF)) continue;
        if (randomMapDataID[current_room] != ROOM_TYPE_NORMAL) continue;
        randomMapDataID[current_room] = ROOM_TYPE_TREASURE;
        sDungenChestContents[current_room] = TREASURE_SMALL_KEY; // Small key
        break;
    }
    // And another key in the first half anywhere
    while(1) {
        current_room = rand8() & 0x3F;
        if ((randomMapDataTmp[current_room] & ROOM_SECOND_HALF)) continue;
        if (!randomMapDataFlags[current_room]) continue;
        if (randomMapDataID[current_room] != ROOM_TYPE_NORMAL) continue;
        randomMapDataID[current_room] = ROOM_TYPE_TREASURE;
        sDungenChestContents[current_room] = TREASURE_SMALL_KEY; // Small key
        break;
    }

    if (dungeonDepth == 5) {
        //Quick hack to "guarantee" boots on depth 5
        while(1) {
            current_room = rand8() & 0x3F;
            if (!randomMapDataFlags[current_room]) continue;
            if (randomMapDataID[current_room] != ROOM_TYPE_NORMAL) continue;
            randomMapDataID[current_room] = ROOM_TYPE_SPECIAL;
            sDungenChestContents[current_room] = 4;
            break;
        }
    }

    // Check for rooms with a single entrance that are a sidepath
    // And potentially turn those into bombable walls
    for(uint8_t n=0; n<64; n++) {
        if (!(randomMapDataTmp[n] & ROOM_SIDE_PATH)) continue;
        uint8_t flags = randomMapDataFlags[n];
        if (flags == ROOM_DOOR_RIGHT || flags == ROOM_DOOR_LEFT || flags == ROOM_DOOR_DOWN || flags == ROOM_DOOR_UP) {
            if (rand8() < 64) {
                randomMapDataFlags[n] = flags << 4;
                if (flags == ROOM_DOOR_RIGHT) {
                    randomMapDataFlags[n + 1] &=~ROOM_DOOR_LEFT;
                    randomMapDataFlags[n + 1] |= ROOM_LOCK_LEFT;
                }
                if (flags == ROOM_DOOR_LEFT) {
                    randomMapDataFlags[n - 1] &=~ROOM_DOOR_RIGHT;
                    randomMapDataFlags[n - 1] |= ROOM_LOCK_RIGHT;
                }
                if (flags == ROOM_DOOR_DOWN) {
                    randomMapDataFlags[n + 8] &=~ROOM_DOOR_UP;
                    randomMapDataFlags[n + 8] |= ROOM_LOCK_UP;
                }
                if (flags == ROOM_DOOR_UP) {
                    randomMapDataFlags[n - 8] &=~ROOM_DOOR_DOWN;
                    randomMapDataFlags[n - 8] |= ROOM_LOCK_DOWN;
                }
            }
        }
    }

    // Add random treasures
    for(uint8_t n=0; n<64; n++) {
        if (!randomMapDataFlags[n]) continue;
        if (randomMapDataID[n]) continue;
        if (rand8() < 64) {
            randomMapDataID[n] = ROOM_TYPE_TREASURE;
            sDungenChestContents[n] = random_treasure_list[rand8range(sizeof(random_treasure_list))];
        }
        if ((randomMapDataTmp[n] & 4) && (rand8() < 128)) {
            randomMapDataID[n] = ROOM_TYPE_TREASURE;
            sDungenChestContents[n] = random_treasure_list[rand8range(sizeof(random_treasure_list))];
        }
        if (randomMapDataID[n]) continue;
        if (rand8() < 128) {
            // Mark room as a special room.
            randomMapDataID[n] = ROOM_TYPE_SPECIAL;
            sDungenChestContents[n] = rand8();
        }
    }

    SET_SRAM_BANK_CONTAINING(sDungeonMinimap);
    // Update the minimap
    for(uint8_t n=0; n<64; n++) {
        if (randomMapDataID[n] == ROOM_TYPE_TREASURE) 
            sDungeonMinimap[n] = 0xED;
        else if (randomMapDataID[n] == ROOM_TYPE_EXIT)
            sDungeonMinimap[n] = 0xEE;
        else if (randomMapDataFlags[n])
            sDungeonMinimap[n] = 0xEF;
        else
            sDungeonMinimap[n] = 0x7D;
    }
}

void buildRandomRoomData(void)
{
    for(uint8_t n=0; n<64; n++) {
getDifferentRoomData:
        const const RandomRoomDataTable_T* table = &RandomRoomDataTable[randomMapDataID[n]];
        const uint8_t* static_room_data_ptr = table->table_data[rand8range(table->table_size)];
        uint8_t mask_input = randomMapDataFlags[n] | (randomMapDataFlags[n] >> 4); 
        uint8_t mask_data = mask_input & (*static_room_data_ptr++);
        if (mask_data != *static_room_data_ptr++)
            goto getDifferentRoomData;
        SET_SRAM_BANK_CONTAINING(sDungeonEventTable);
        sDungeonEventTable[n] = *static_room_data_ptr++;
        SET_SRAM_BANK_CONTAINING(sDynamicRoomData);
        uint8_t* dynamic_room_data_ptr = &sDynamicRoomData[((uint16_t)n) * 0x80];
        uint8_t copy_size = *static_room_data_ptr++;
        do {
            *dynamic_room_data_ptr++ = *static_room_data_ptr++;
        } while(--copy_size);

        if (randomMapDataFlags[n] & ROOM_DOOR_RIGHT) {
            *dynamic_room_data_ptr++ = 0x39;
            if (randomMapDataFlags[n] & ROOM_LOCK_RIGHT) {
                *dynamic_room_data_ptr++ = 0xEF;
            } else {
                *dynamic_room_data_ptr++ = 0xF3;
            }
        } else if (randomMapDataFlags[n] & ROOM_LOCK_RIGHT) {
            *dynamic_room_data_ptr++ = 0x39;
            *dynamic_room_data_ptr++ = 0x42;
        }
        if (randomMapDataFlags[n] & ROOM_DOOR_LEFT) {
            *dynamic_room_data_ptr++ = 0x30;
            if (randomMapDataFlags[n] & ROOM_LOCK_LEFT) {
                *dynamic_room_data_ptr++ = 0xEE;
            } else {
                *dynamic_room_data_ptr++ = 0xF2;
            }
        } else if (randomMapDataFlags[n] & ROOM_LOCK_LEFT) {
            *dynamic_room_data_ptr++ = 0x30;
            *dynamic_room_data_ptr++ = 0x41;
        }
        if (randomMapDataFlags[n] & ROOM_DOOR_DOWN) {
            *dynamic_room_data_ptr++ = 0x74;
            if (randomMapDataFlags[n] & ROOM_LOCK_DOWN) {
                *dynamic_room_data_ptr++ = 0xED;
            } else {
                *dynamic_room_data_ptr++ = 0xF1;
            }
        } else if (randomMapDataFlags[n] & ROOM_LOCK_DOWN) {
            *dynamic_room_data_ptr++ = 0x74;
            *dynamic_room_data_ptr++ = 0x40;
        }
        if (randomMapDataFlags[n] & ROOM_DOOR_UP) {
            *dynamic_room_data_ptr++ = 0x04;
            if (randomMapDataFlags[n] & ROOM_LOCK_UP) {
                *dynamic_room_data_ptr++ = 0xEC;
            } else {
                *dynamic_room_data_ptr++ = 0xF0;
            }
        } else if (randomMapDataFlags[n] & ROOM_LOCK_UP) {
            *dynamic_room_data_ptr++ = 0x04;
            *dynamic_room_data_ptr++ = 0x3F;
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
retry_entities:
        uint8_t entity_set_nr = rand8range(entity_set_count);
        if (dungeonDepth < static_room_data_ptr[entity_set_nr * 4 + 0]) goto retry_entities;
        if (dungeonDepth > static_room_data_ptr[entity_set_nr * 4 + 1]) goto retry_entities;
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
