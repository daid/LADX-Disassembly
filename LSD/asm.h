#pragma once

#include <stdint.h>

uint8_t rand8(void) __preserves_regs(d, e, h, l);
uint8_t rand8range(uint8_t) __preserves_regs(d, e, h, l);
uint16_t rand16(void) __preserves_regs(d, e, h, l);


extern uint8_t randomMapData[0x40];
extern uint8_t sDungeonMinimap[0x40];
extern uint8_t sDungenChestContents[0x40];
extern __sfr hMapRoom;
extern uint8_t sDynamicRoomData[0x2000];
extern uint8_t sDynamicEntityData[0x2000];
extern const uint8_t* RandomRoomDataTable[];

#define SET_SRAM_BANK(n) *((uint8_t*)0x4000) = (n)
#define SET_SRAM_BANK_CONTAINING(n) extern void __bank_ ## n; SET_SRAM_BANK((uint8_t)&__bank_ ## n)