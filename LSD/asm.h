#pragma once

#include <stdint.h>

uint8_t rand8(void) __preserves_regs(d, e, h, l);
uint16_t rand16(void) __preserves_regs(d, e, h, l);
