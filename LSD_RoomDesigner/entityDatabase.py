entities_list = [
    {'id': 0x09, 'tiles': [0, 0], 'attr': [2, 34]},  # OCTOROCK
    {'id': 0x0B, 'tiles': [0, 1], 'attr': [1, 1]},  # MOBLIN
    {'id': 0x0D, 'tiles': [4, 4], 'attr': [2, 34]},  # TEKTITE
    {'id': 0x0E, 'tiles': [0, 0], 'attr': [1, 33]},  # LEEVER
    {'id': 0x0F, 'tiles': [0, 1], 'attr': [4, 4]},  # ARMOS_STATUE
    {'id': 0x10, 'tiles': [6, 7], 'attr': [3, 3]},  # HIDING_GHINI
    {'id': 0x11, 'tiles': [3, 4], 'attr': [2, 2]},  # GIANT_GHINI
    {'id': 0x12, 'tiles': [6, 7], 'attr': [2, 2]},  # GHINI
    {'id': 0x14, 'tiles': [0, 1, -1, (0x2C, 0x040)], 'attr': [1, 1, 0, 256]},  # MOBLIN_SWORD
    {'id': 0x15, 'tiles': [5, 5], 'attr': [3, 35]},  # ANTI_FAIRY
    {'id': 0x16, 'tiles': [6, 6], 'attr': [0, 32]},  # SPARK_COUNTER_CLOCKWISE
    {'id': 0x17, 'tiles': [6, 6], 'attr': [4, 36]},  # SPARK_CLOCKWISE
    {'id': 0x18, 'tiles': [0, 0], 'attr': [1, 33]},  # POLS_VOICE
    {'id': 0x19, 'tiles': [0, 0], 'attr': [1, 33]},  # KEESE
    {'id': 0x1A, 'tiles': [5, 6], 'attr': [0, 0]},  # STALFOS_AGGRESSIVE
    {'id': 0x1B, 'tiles': [1, 1], 'attr': [0, 32]},  # GEL
    {'id': 0x1C, 'tiles': [3], 'attr': [0, 0]},  # MINI_GEL
    {'id': 0x1E, 'tiles': [5, 6], 'attr': [1, 1]},  # STALFOS_EVASIVE
    {'id': 0x1F, 'tiles': [10, 11], 'attr': [1, 1]},  # GIBDO
    {'id': 0x20, 'tiles': [2, 2], 'attr': [3, 35]},  # HARDHAT_BEETLE
    {'id': 0x21, 'tiles': [0, 0], 'attr': [0, 32]},  # WIZROBE
    {'id': 0x23, 'tiles': [6, 6], 'attr': [1, 33]},  # LIKE_LIKE
    {'id': 0x24, 'tiles': [0, 1], 'attr': [2, 2]},  # IRON_MASK
    {'id': 0x27, 'tiles': [0, 0], 'attr': [3, 35]},  # SPIKE_TRAP
    {'id': 0x28, 'tiles': [0, 1], 'attr': [1, 1]},  # MIMIC
    {'id': 0x29, 'tiles': [3, 4], 'attr': [0, 0]},  # MINI_MOLDORM
    {'id': 0x2A, 'tiles': [0, 0], 'attr': [0, 32]},  # LASER
    {'id': 0x2C, 'tiles': [0, 0], 'attr': [0, 32]},  # SPIKED_BEETLE
    # {'id': 0x2D, 'tiles': [(0x2C, 0xA80)], 'attr': [4, 0]},  # DROPPABLE_HEART
    # {'id': 0x2E, 'tiles': [(0x2C, 0xA60)], 'attr': [5, 0]},  # DROPPABLE_RUPEE
    # {'id': 0x2F, 'tiles': [(0x2C, 0x200)], 'attr': [0, 0]},  # DROPPABLE_FAIRY
    # {'id': 0x30, 'tiles': [(0x32, 0x3DA0)], 'attr': [6, 0]},  # KEY_DROP_POINT
    # {'id': 0x31, 'tiles': [(0x2C, 0x040)], 'attr': [64, 0]},  # SWORD
    # {'id': 0x35, 'tiles': [(0x2C, 0xAC0), (0x2C, 0xAC0)], 'attr': [2, 34]},  # HEART_PIECE
    # {'id': 0x37, 'tiles': [(0x2C, 0x2A0), (0x2C, 0x2A0)], 'attr': [0, 32]},  # DROPPABLE_ARROWS
    # {'id': 0x38, 'tiles': [(0x2C, 0x800)], 'attr': [5, 0]},  # DROPPABLE_BOMBS
    # {'id': 0x39, 'tiles': [(0x31, 0x1000), (0x31, 0x1020)], 'attr': [0, 0]},  # INSTRUMENT_OF_THE_SIRENS
    # {'id': 0x3A, 'tiles': [7, 7], 'attr': [2, 34]},  # SLEEPY_TOADSTOOL
    # {'id': 0x3B, 'tiles': [(0x2C, 0x8E0)], 'attr': [4, 0]},  # DROPPABLE_MAGIC_POWDER
    # {'id': 0x3C, 'tiles': [(0x2C, 0xCA0), (0x2C, 0x28E0)], 'attr': [4, 4]},  # HIDING_SLIME_KEY
    # {'id': 0x3D, 'tiles': [(0x2C, 0x9E0)], 'attr': [4, 0]},  # DROPPABLE_SECRET_SEASHELL
    # {'id': 0x3E, 'tiles': [4, 5], 'attr': [1, 1]},  # MARIN
    # {'id': 0x3F, 'tiles': [4, 5], 'attr': [2, 2]},  # RACOON
    # {'id': 0x40, 'tiles': [4, 5], 'attr': [2, 2]},  # WITCH
    # {'id': 0x41},  # OWL_EVENT
    # {'id': 0x42, 'tiles': [7, 7], 'attr': [1, 33]},  # OWL_STATUE
    # {'id': 0x43},  # SEASHELL_MANSION_TREES
    # {'id': 0x44},  # YARNA_TALKING_BONES
    # {'id': 0x45, 'tiles': [6, 7], 'attr': [1, 1]},  # BOULDERS
    # {'id': 0x46},  # MOVING_BLOCK_LEFT_TOP
    # {'id': 0x47},  # MOVING_BLOCK_LEFT_BOTTOM
    # {'id': 0x48},  # MOVING_BLOCK_BOTTOM_LEFT
    # {'id': 0x49},  # MOVING_BLOCK_BOTTOM_RIGHT
    # {'id': 0x4A, 'tiles': [4], 'attr': [0, 0]},  # COLOR_DUNGEON_BOOK
    {'id': 0x4D, 'tiles': [0, 1], 'attr': [3, 3]},  # SHOP_OWNER
    # {'id': 0x4F, 'tiles': [0, 1], 'attr': [3, 3]},  # TRENDY_GAME_OWNER
    # {'id': 0x50, 'tiles': [0, 1], 'attr': [3, 3]},  # BOO_BUDDY
    {'id': 0x51, 'tiles': [0, 1], 'attr': [2, 2]},  # KNIGHT
    {'id': 0x52, 'tiles': [6, 6], 'attr': [3, 35]},  # TRACTOR_DEVICE
    {'id': 0x53, 'tiles': [6, 6], 'attr': [0, 32]},  # TRACTOR_DEVICE_REVERSE
    # {'id': 0x54, 'tiles': [0, 1], 'attr': [3, 3]},  # FISHERMAN_FISHING_GAME
    {'id': 0x55, 'tiles': [7, 7], 'attr': [0, 32]},  # BOUNCING_BOMBITE
    {'id': 0x56, 'tiles': [0, 1], 'attr': [0, 0]},  # TIMER_BOMBITE
    {'id': 0x57, 'tiles': [0, 1], 'attr': [0, 0]},  # PAIRODD
    {'id': 0x59, 'tiles': [6, 7], 'attr': [3, 3]},  # MOLDORM
    {'id': 0x5A, 'tiles': [20, 21], 'attr': [3, 3]},  # FACADE
    {'id': 0x5B, 'tiles': [2, 3], 'attr': [3, 3]},  # SLIME_EYE
    {'id': 0x5C, 'tiles': [4, 5], 'attr': [2, 2]},  # GENIE
    {'id': 0x5D, 'tiles': [6, 7], 'attr': [3, 3]},  # SLIME_EEL
    {'id': 0x5E, 'tiles': [0, 0], 'attr': [0, 32]},  # GHOMA
    {'id': 0x5F, 'tiles': [1, 2], 'attr': [3, 3]},  # MASTER_STALFOS
    {'id': 0x60, 'tiles': [0, 0], 'attr': [0, 32]},  # DODONGO_SNAKE
    # {'id': 0x61},  # WARP
    {'id': 0x62, 'tiles': [4, 5], 'attr': [2, 2]},  # HOT_HEAD
    {'id': 0x63, 'tiles': [3, 4], 'attr': [2, 2]},  # EVIL_EAGLE
    {'id': 0x65, 'tiles': [6, 7], 'attr': [3, 3]},  # ANGLER_FISH
    # {'id': 0x66, 'tiles': [4, 4], 'attr': [1, 33]},  # CRYSTAL_SWITCH
    # {'id': 0x69},  # MOVING_BLOCK_MOVER
    # {'id': 0x6A, 'tiles': [6, 6], 'attr': [1, 33]},  # RAFT_RAFT_OWNER
    # {'id': 0x6C, 'tiles': [(0x32, 0x2500), (0x32, 0x2520)], 'attr': [1, 1]},  # CUCCO
    # {'id': 0x6D, 'tiles': [(0x32, 0x2440), (0x32, 0x2460)], 'attr': [3, 3]},  # BOW_WOW
    # {'id': 0x6E, 'tiles': [7], 'attr': [3, 3]},  # BUTTERFLY
    # {'id': 0x6F, 'tiles': [4, 5], 'attr': [1, 1]},  # DOG
    # {'id': 0x70},  # KID_70
    # {'id': 0x71},  # KID_71
    # {'id': 0x72},  # KID_72
    # {'id': 0x73},  # KID_73
    # {'id': 0x74, 'tiles': [1, 2], 'attr': [0, 0]},  # PAPAHLS_WIFE
    # {'id': 0x75, 'tiles': [0, 1], 'attr': [1, 1]},  # GRANDMA_ULRIRA
    # {'id': 0x76, 'tiles': [0, 1], 'attr': [2, 2]},  # MR_WRITE
    # {'id': 0x77, 'tiles': [2, 3], 'attr': [1, 2]},  # GRANDPA_ULRIRA
    # {'id': 0x78, 'tiles': [0, 1], 'attr': [2, 2]},  # YIP_YIP
    # {'id': 0x79, 'tiles': [0, 1], 'attr': [2, 2]},  # MADAM_MEOWMEOW
    {'id': 0x7A, 'tiles': [0, 1], 'attr': [3, 3]},  # CROW
    # {'id': 0x7B, 'tiles': [0, 1], 'attr': [2, 2]},  # CRAZY_TRACY
    {'id': 0x7C, 'tiles': [1, 1], 'attr': [2, 34]},  # GIANT_GOPONGA_FLOWER
    {'id': 0x7E, 'tiles': [1, 1], 'attr': [2, 34]},  # GOPONGA_FLOWER
    {'id': 0x7F, 'tiles': [1, 1], 'attr': [2, 34]},  # TURTLE_ROCK_HEAD
    # {'id': 0x80, 'tiles': [0, 1], 'attr': [2, 2]},  # TELEPHONE
    {'id': 0x81, 'tiles': [3, 4], 'attr': [2, 2]},  # ROLLING_BONES
    {'id': 0x82, 'tiles': [6, 6], 'attr': [1, 33]},  # ROLLING_BONES_BAR
    # {'id': 0x83},  # DREAM_SHRINE_BED
    {'id': 0x84},  # BIG_FAIRY
    # {'id': 0x85},  # MR_WRITES_BIRD
    # {'id': 0x86},  # FLOATING_ITEM
    {'id': 0x87},  # DESERT_LANMOLA
    {'id': 0x88, 'tiles': [0, 1], 'attr': [2, 2]},  # ARMOS_KNIGHT
    {'id': 0x89, 'tiles': [1, 2], 'attr': [2, 2]},  # HINOX
    # {'id': 0x8A},  # TILE_GLINT_SHOWN
    # {'id': 0x8B},  # TILE_GLINT_HIDDEN
    {'id': 0x8E, 'tiles': [0, 1], 'attr': [2, 2]},  # CUE_BALL
    {'id': 0x8F, 'tiles': [0, 1], 'attr': [1, 1]},  # MASKED_MIMIC_GORIYA
    {'id': 0x90, 'tiles': [0, 1], 'attr': [1, 1]},  # THREE_OF_A_KIND
    {'id': 0x91, 'tiles': [0, 1], 'attr': [1, 1]},  # ANTI_KIRBY
    {'id': 0x92, 'tiles': [0, 1], 'attr': [3, 3]},  # SMASHER
    {'id': 0x93},  # MAD_BOMBER
    # {'id': 0x94},  # KANALET_BOMBABLE_WALL
    # {'id': 0x95},  # RICHARD
    # {'id': 0x96},  # RICHARD_FROG
    # {'id': 0x97},  # DIVE_SPOT
    # {'id': 0x98},  # HORSE_PIECE
    {'id': 0x99, 'tiles': [0, 0], 'attr': [0, 32]},  # WATER_TEKTITE
    # {'id': 0x9A},  # FLYING_TILES
    {'id': 0x9B, 'tiles': [1, 1], 'attr': [2, 34]},  # HIDING_GEL
    {'id': 0x9C, 'tiles': [3, 4], 'attr': [0, 0]},  # STAR
    {'id': 0x9D},  # LIFTABLE_STATUE
    {'id': 0x9E},  # FIREBALL_SHOOTER
    {'id': 0x9F, 'tiles': [5, 6], 'attr': [2, 2]},  # GOOMBA
    {'id': 0xA0, 'tiles': [0, 0], 'attr': [2, 34]},  # PEAHAT
    {'id': 0xA1, 'tiles': [2, 3], 'attr': [0, 0]},  # SNAKE
    {'id': 0xA2},  # PIRANHA_PLANT
    # {'id': 0xA3},  # SIDE_VIEW_PLATFORM_HORIZONTAL
    # {'id': 0xA4},  # SIDE_VIEW_PLATFORM_VERTICAL
    # {'id': 0xA5},  # SIDE_VIEW_PLATFORM
    # {'id': 0xA6},  # SIDE_VIEW_WEIGHTS
    # {'id': 0xA7},  # SMASHABLE_PILLAR
    {'id': 0xA9, 'tiles': [4, 4], 'attr': [0, 32]},  # BLOOPER
    {'id': 0xAA},  # CHEEP_CHEEP_HORIZONTAL
    {'id': 0xAB},  # CHEEP_CHEEP_VERTICAL
    {'id': 0xAC},  # CHEEP_CHEEP_JUMPING
    # {'id': 0xAD},  # KIKI_THE_MONKEY
    {'id': 0xAE, 'tiles': [0, 0, (0x2C, 0x220), (0x2C, 0x220)], 'attr': [2, 34, 0, 32]},  # WINGED_OCTOROK
    {'id': 0xAF},  # TRADING_ITEM
    {'id': 0xB0, 'tiles': [0, 0], 'attr': [2, 34]},  # PINCER
    # {'id': 0xB1, 'tiles': [0, 0], 'attr': [2, 34]},  # HOLE_FILLER
    {'id': 0xB2, 'tiles': [0, 1], 'attr': [1, 1]},  # BEETLE_SPAWNER
    # {'id': 0xB3, 'tiles': [0, 0], 'attr': [1, 33]},  # HONEYCOMB
    # {'id': 0xB4, 'tiles': [0, 1], 'attr': [2, 2]},  # TARIN
    # {'id': 0xB5, 'tiles': [1, 2], 'attr': [2, 2]},  # BEAR
    # {'id': 0xB6, 'tiles': [0, 1], 'attr': [2, 2]},  # PAPAHL
    # {'id': 0xB7, 'tiles': [0, 1], 'attr': [2, 2]},  # MERMAID
    # {'id': 0xB8, 'tiles': [16, 17], 'attr': [2, 2]},  # FISHERMAN_UNDER_BRIDGE
    {'id': 0xB9, 'tiles': [0, 0], 'attr': [0, 32]},  # BUZZ_BLOB
    {'id': 0xBA, 'tiles': [2, 1], 'attr': [2, 2]},  # BOMBER
    {'id': 0xBB, 'tiles': [6, 7], 'attr': [2, 2]},  # BUSH_CRAWLER
    {'id': 0xBC, 'tiles': [1, 2], 'attr': [3, 3]},  # GRIM_CREEPER
    {'id': 0xBD, 'tiles': [0, 1], 'attr': [2, 2]},  # VIRE
    {'id': 0xBE, 'tiles': [4, 5], 'attr': [1, 1]},  # BLAINO
    {'id': 0xBF, 'tiles': [4, 5], 'attr': [2, 2]},  # ZOMBIE
    # {'id': 0xC0},  # MAZE_SIGNPOST
    # {'id': 0xC1},  # MARIN_AT_THE_SHORE
    # {'id': 0xC2},  # MARIN_AT_TAL_TAL_HEIGHTS
    # {'id': 0xC3, 'tiles': [9, 10], 'attr': [0, 0]},  # MAMU_AND_FROGS
    # {'id': 0xC4, 'tiles': [9, 10], 'attr': [1, 1]},  # WALRUS
    {'id': 0xC5, 'tiles': [6, 7], 'attr': [3, 3]},  # URCHIN
    {'id': 0xC6, 'tiles': [4, 4], 'attr': [2, 34]},  # SAND_CRAB
    # {'id': 0xC7, 'tiles': [8, 9], 'attr': [3, 3]},  # MANBO_AND_FISHES
    # {'id': 0xCA, 'tiles': [0, 1], 'attr': [2, 2]},  # MAD_BATTER
    {'id': 0xCB, 'tiles': [3, 3], 'attr': [1, 33]},  # ZORA
    {'id': 0xCC, 'tiles': [2, 3], 'attr': [3, 3]},  # FISH
    # {'id': 0xCD},  # BANANAS_SCHULE_SALE
    # {'id': 0xCE},  # MERMAID_STATUE
    # {'id': 0xCF},  # SEASHELL_MANSION
    # {'id': 0xD0},  # ANIMAL_D0
    # {'id': 0xD1},  # ANIMAL_D1
    # {'id': 0xD2},  # ANIMAL_D2
    # {'id': 0xD3},  # BUNNY_D3
    # {'id': 0xD6},  # SIDE_VIEW_POT
    {'id': 0xD7, 'tiles': [5, 5], 'attr': [3, 35]},  # THWIMP
    {'id': 0xD8, 'tiles': [8, 9], 'attr': [5, 5]},  # THWOMP
    {'id': 0xD9, 'tiles': [0, 1], 'attr': [2, 2]},  # THWOMP_RAMMABLE
    {'id': 0xDA},  # PODOBOO
    {'id': 0xDB},  # GIANT_BUBBLE
    # {'id': 0xDC},  # FLYING_ROOSTER_EVENTS
    # {'id': 0xDD},  # BOOK
    # {'id': 0xDE},  # EGG_SONG_EVENT
    {'id': 0xE0},  # MONKEY
    # {'id': 0xE1},  # WITCH_RAT
    {'id': 0xE2},  # FLAME_SHOOTER
    {'id': 0xE3, 'tiles': [2, 2], 'attr': [0, 32]},  # POKEY
    {'id': 0xE4, 'tiles': [13, 14], 'attr': [2, 2]},  # MOBLIN_KING
    # {'id': 0xE5},  # FLOATING_ITEM_2
    {'id': 0xE6},  # FINAL_NIGHTMARE
    # {'id': 0xE7},  # KANALET_CASTLE_GATE_SWITCH
    {'id': 0xEC, 'tiles': [0, 0], 'attr': [2, 34]},  # COLOR_GHOUL_RED
    {'id': 0xED, 'tiles': [0, 0], 'attr': [0, 32]},  # COLOR_GHOUL_GREEN
    {'id': 0xEE, 'tiles': [0, 0], 'attr': [3, 35]},  # COLOR_GHOUL_BLUE
    {'id': 0xF4, 'tiles': [1, 2], 'attr': [1, 1]},  # AVALAUNCH
    {'id': 0xF8, 'tiles': [0, 1], 'attr': [0, 0]},  # GIANT_BUZZ_BLOB
    {'id': 0xEF, 'tiles': [0, 0], 'attr': [2, 34]},  # ENTITY_ROTOSWITCH_RED
    {'id': 0xF0, 'tiles': [1, 2], 'attr': [1, 1]},  # ENTITY_ROTOSWITCH_YELLOW
    {'id': 0xF1, 'tiles': [0, 0], 'attr': [3, 35]},  # ENTITY_ROTOSWITCH_BLUE
    # {'id': 0xFA},  # PHOTOGRAPHER
]
entities_dict = {e['id']: e for e in entities_list}