# Links Awakening DX: LSD edition

## Usage

Building the LSD version of LADX is not an easy task, it depends on whole set of extra tools compared to the base disassembly project.

1. Install Python 3
2. Install [rgbds](https://github.com/gbdev/rgbds#1-installing-rgbds) (version >= 1.0.0 required)
3. Install sdcc or gbdk-2020 (sdcc 4.5 or newer required, this bundles with gbdk-2020)
4. Get [GB.HLA](https://github.com/daid/GB.HLA/)
5. Get [BadBoy](https://github.com/daid/BadBoy/)
2. `make`.

This will build both the game and their debug symbols. Once built, use [BGB](https://github.com/zladx/LADX-Disassembly/wiki/Tooling-for-reverse-engineering#bgb) to load the debug symbols into the debugger.
