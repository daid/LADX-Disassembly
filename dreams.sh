#!/bin/sh

set -eu

rgbasm --export-all  -Weverything  -Wtruncation=1 -DLANG=EN -DVERSION=0 -I src/ -o src/main.azle.o src/main.asm
python3 ../GB.HLA/main.py dreams.asm --output dreams.gbc --symbols dreams.sym
