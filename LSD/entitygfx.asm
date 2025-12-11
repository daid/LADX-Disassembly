; This code deals with setting up the right sprite graphics for entities.

#SECTION "EntitySpritesheetSetup", ROMX, BANK[$20] {
LSD_ResetEntity:
    ; First, reset our offset.
    ld   hl, wEntitiesSpriteOffsetTable
    add  hl, bc
    ld   [hl], b

    ; Get the entity type to lookup our required graphics
    ld   hl, wEntitiesTypeTable
    add  hl, bc
    ld   d, b
    ld   e, [hl]

    ld   hl, EntitySpriteRequirementsTable
    add  hl, de
    ld   a, [hl]
    cp   $FF
    ret  z
    ld   b, a

    ; Check if the sheet is already loaded
    ld   hl, wLoadedEntitySpritesheets
    ld   e, $00
    loop d, 4 {
        ld   a, b
        cp   [hl]
        if z {
            pushpop de {
                ld   de, wLoadedEntitySpritesheetsAge - wLoadedEntitySpritesheets
                add  hl, de
                ld   [hl], 0
            }
            ld  b, 0
            ld   hl, wEntitiesSpriteOffsetTable
            add  hl, bc
            ld   [hl], e
            ret
        }
        ld   a, e
        add  a, $10
        ld   e, a
        inc  hl
    }

    ; Sheet not found, search the oldest wLoadedEntitySpritesheets and replace that.
    ld   hl, wLoadedEntitySpritesheetsAge
    ld   a, 0
    loop d, 4 { ; loop over all ages, find the highest and increase all with 1.
        inc [hl]
        cp  [hl]
        if  c {
            ld  a, [hl]
        }
        inc hl
    }
    ld   hl, wLoadedEntitySpritesheetsAge + 3
    loop d, 4 {
        cp  [hl] ; if highest age, replace it.
        if z {
            ld  [hl], 0
            pushpop de {
                ld   de, $10000 + wLoadedEntitySpritesheets - wLoadedEntitySpritesheetsAge
                add  hl, de
                ld   [hl], b ; store required sheet
            }
            ld   b, 0

            ld   a, d
            dec  a
            swap a
            ld   hl, wEntitiesSpriteOffsetTable
            add  hl, bc
            ld   [hl], a

            ldh  a, [hNeedsUpdatingEntityTilesA]
            and  a, a
            ld   a, d
            if   z {
                ldh  [hNeedsUpdatingEntityTilesA], a
                dec  a
                ld   [wEntityTilesSpriteslotIndexA], a
            } else {
                ld   [wNeedsUpdatingEntityTilesB], a
                dec  a
                ld   [wEntityTilesSpriteslotIndexB], a
            }
            ret
        }
        dec hl
    }
    db $dd ; should never be reached

EntitySpriteRequirementsTable:
    db $FF ; 00 ARROW
    db $FF ; 01 BOOMERANG
    db $FF ; 02 BOMB
    db $FF ; 03 HOOKSHOT_CHAIN
    db $FF ; 04 HOOKSHOT_HIT
    db $FF ; 05 LIFTABLE_ROCK
    db $FF ; 06 PUSHED_BLOCK
    db $FF ; 07 CHEST_WITH_ITEM
    db $FF ; 08 MAGIC_POWDER_SPRINKLE
    db $FF ; 09 OCTOROCK
    db $FF ; 0a OCTOROCK_ROCK
    db $FF ; 0b MOBLIN
    db $FF ; 0c MOBLIN_ARROW
    db $87 ; 0d TEKTITE
    db $FF ; 0e LEEVER
    db $FF ; 0f ARMOS_STATUE
    db $FF ; 10 HIDING_GHINI
    db $8A ; 11 GIANT_GHINI
    db $FF ; 12 GHINI
    db $FF ; 13 BROKEN_HEART_CONTAINER
    db $FF ; 14 MOBLIN_SWORD
    db $FF ; 15 ANTI_FAIRY
    db $FF ; 16 SPARK_COUNTER_CLOCKWISE
    db $FF ; 17 SPARK_CLOCKWISE
    db $FF ; 18 POLS_VOICE
    db $FF ; 19 KEESE
    db $77 ; 1a STALFOS_AGGRESSIVE
    db $91 ; 1b GEL
    db $91 ; 1c MINI_GEL
    db $FF ; 1d DISABLED
    db $77 ; 1e STALFOS_EVASIVE
    db $77 ; 1f GIBDO
    db $FF ; 20 HARDHAT_BEETLE
    db $95 ; 21 WIZROBE
    db $95 ; 22 WIZROBE_PROJECTILE
    db $93 ; 23 LIKE_LIKE
    db $FF ; 24 IRON_MASK
    db $FF ; 25 SMALL_EXPLOSION_ENEMY
    db $FF ; 26 SMALL_EXPLOSION_ENEMY_2
    db $FF ; 27 SPIKE_TRAP
    db $FF ; 28 MIMIC
    db $FF ; 29 MINI_MOLDORM
    db $FF ; 2a LASER
    db $FF ; 2b LASER_BEAM
    db $FF ; 2c SPIKED_BEETLE
    db $FF ; 2d DROPPABLE_HEART
    db $FF ; 2e DROPPABLE_RUPEE
    db $FF ; 2f DROPPABLE_FAIRY
    db $FF ; 30 KEY_DROP_POINT
    db $FF ; 31 SWORD
    db $FF ; 32 32
    db $FF ; 33 PIECE_OF_POWER
    db $FF ; 34 GUARDIAN_ACORN
    db $FF ; 35 HEART_PIECE
    db $FF ; 36 HEART_CONTAINER
    db $FF ; 37 DROPPABLE_ARROWS
    db $FF ; 38 DROPPABLE_BOMBS
    db $FF ; 39 INSTRUMENT_OF_THE_SIRENS
    db $FF ; 3a SLEEPY_TOADSTOOL
    db $FF ; 3b DROPPABLE_MAGIC_POWDER
    db $FF ; 3c HIDING_SLIME_KEY
    db $FF ; 3d DROPPABLE_SECRET_SEASHELL
    db $FF ; 3e MARIN
    db $FF ; 3f RACOON
    db $FF ; 40 WITCH
    db $FF ; 41 OWL_EVENT
    db $FF ; 42 OWL_STATUE
    db $FF ; 43 SEASHELL_MANSION_TREES
    db $FF ; 44 YARNA_TALKING_BONES
    db $FF ; 45 BOULDERS
    db $FF ; 46 MOVING_BLOCK_LEFT_TOP
    db $FF ; 47 MOVING_BLOCK_LEFT_BOTTOM
    db $FF ; 48 MOVING_BLOCK_BOTTOM_LEFT
    db $FF ; 49 MOVING_BLOCK_BOTTOM_RIGHT
    db $FF ; 4a COLOR_DUNGEON_BOOK
    db $FF ; 4b POT
    db $FF ; 4c DISABLED
    db $FF ; 4d SHOP_OWNER
    db $FF ; 4e 4D
    db $FF ; 4f TRENDY_GAME_OWNER
    db $FF ; 50 BOO_BUDDY
    db $FF ; 51 KNIGHT
    db $FF ; 52 TRACTOR_DEVICE
    db $FF ; 53 TRACTOR_DEVICE_REVERSE
    db $FF ; 54 FISHERMAN_FISHING_GAME
    db $FF ; 55 BOUNCING_BOMBITE
    db $FF ; 56 TIMER_BOMBITE
    db $FF ; 57 PAIRODD
    db $FF ; 58 PAIRODD_PROJECTILE
    db $FF ; 59 MOLDORM
    db $FF ; 5a FACADE
    db $FF ; 5b SLIME_EYE
    db $FF ; 5c GENIE
    db $FF ; 5d SLIME_EEL
    db $FF ; 5e GHOMA
    db $FF ; 5f MASTER_STALFOS
    db $FF ; 60 DODONGO_SNAKE
    db $FF ; 61 WARP
    db $FF ; 62 HOT_HEAD
    db $FF ; 63 EVIL_EAGLE
    db $FF ; 64 SOUTH_FACE_SHRINE_DOOR
    db $FF ; 65 ANGLER_FISH
    db $FF ; 66 CRYSTAL_SWITCH
    db $FF ; 67 67
    db $FF ; 68 68
    db $FF ; 69 MOVING_BLOCK_MOVER
    db $FF ; 6a RAFT_RAFT_OWNER
    db $FF ; 6b TEXT_DEBUGGER
    db $FF ; 6c CUCCO
    db $FF ; 6d BOW_WOW
    db $FF ; 6e BUTTERFLY
    db $FF ; 6f DOG
    db $FF ; 70 KID_70
    db $FF ; 71 KID_71
    db $FF ; 72 KID_72
    db $FF ; 73 KID_73
    db $FF ; 74 PAPAHLS_WIFE
    db $FF ; 75 GRANDMA_ULRIRA
    db $FF ; 76 MR_WRITE
    db $FF ; 77 GRANDPA_ULRIRA
    db $FF ; 78 YIP_YIP
    db $FF ; 79 MADAM_MEOWMEOW
    db $FF ; 7a CROW
    db $FF ; 7b CRAZY_TRACY
    db $FF ; 7c GIANT_GOPONGA_FLOWER
    db $FF ; 7d GOPONGA_FLOWER_PROJECTILE
    db $FF ; 7e GOPONGA_FLOWER
    db $FF ; 7f TURTLE_ROCK_HEAD
    db $FF ; 80 TELEPHONE
    db $FF ; 81 ROLLING_BONES
    db $FF ; 82 ROLLING_BONES_BAR
    db $FF ; 83 DREAM_SHRINE_BED
    db $FF ; 84 BIG_FAIRY
    db $FF ; 85 MR_WRITES_BIRD
    db $FF ; 86 FLOATING_ITEM
    db $FF ; 87 DESERT_LANMOLA
    db $FF ; 88 ARMOS_KNIGHT
    db $FF ; 89 HINOX
    db $FF ; 8a TILE_GLINT_SHOWN
    db $FF ; 8b TILE_GLINT_HIDDEN
    db $FF ; 8c 8C
    db $FF ; 8d 8D
    db $FF ; 8e CUE_BALL
    db $FF ; 8f MASKED_MIMIC_GORIYA
    db $FF ; 90 THREE_OF_A_KIND
    db $FF ; 91 ANTI_KIRBY
    db $FF ; 92 SMASHER
    db $FF ; 93 MAD_BOMBER
    db $FF ; 94 KANALET_BOMBABLE_WALL
    db $FF ; 95 RICHARD
    db $FF ; 96 RICHARD_FROG
    db $FF ; 97 DIVE_SPOT
    db $FF ; 98 HORSE_PIECE
    db $FF ; 99 WATER_TEKTITE
    db $FF ; 9a FLYING_TILES
    db $91 ; 9b HIDING_GEL
    db $FF ; 9c STAR
    db $FF ; 9d LIFTABLE_STATUE
    db $FF ; 9e FIREBALL_SHOOTER
    db $FF ; 9f GOOMBA
    db $FF ; a0 PEAHAT
    db $FF ; a1 SNAKE
    db $FF ; a2 PIRANHA_PLANT
    db $FF ; a3 SIDE_VIEW_PLATFORM_HORIZONTAL
    db $FF ; a4 SIDE_VIEW_PLATFORM_VERTICAL
    db $FF ; a5 SIDE_VIEW_PLATFORM
    db $FF ; a6 SIDE_VIEW_WEIGHTS
    db $FF ; a7 SMASHABLE_PILLAR
    db $FF ; a8 WRECKING_BALL
    db $FF ; a9 BLOOPER
    db $FF ; aa CHEEP_CHEEP_HORIZONTAL
    db $FF ; ab CHEEP_CHEEP_VERTICAL
    db $FF ; ac CHEEP_CHEEP_JUMPING
    db $FF ; ad KIKI_THE_MONKEY
    db $FF ; ae WINGED_OCTOROK
    db $FF ; af TRADING_ITEM
    db $FF ; b0 PINCER
    db $FF ; b1 HOLE_FILLER
    db $FF ; b2 BEETLE_SPAWNER
    db $FF ; b3 HONEYCOMB
    db $FF ; b4 TARIN
    db $FF ; b5 BEAR
    db $FF ; b6 PAPAHL
    db $FF ; b7 MERMAID
    db $FF ; b8 FISHERMAN_UNDER_BRIDGE
    db $FF ; b9 BUZZ_BLOB
    db $FF ; ba BOMBER
    db $FF ; bb BUSH_CRAWLER
    db $FF ; bc GRIM_CREEPER
    db $FF ; bd VIRE
    db $FF ; be BLAINO
    db $FF ; bf ZOMBIE
    db $FF ; c0 MAZE_SIGNPOST
    db $FF ; c1 MARIN_AT_THE_SHORE
    db $FF ; c2 MARIN_AT_TAL_TAL_HEIGHTS
    db $FF ; c3 MAMU_AND_FROGS
    db $FF ; c4 WALRUS
    db $FF ; c5 URCHIN
    db $FF ; c6 SAND_CRAB
    db $FF ; c7 MANBO_AND_FISHES
    db $FF ; c8 BUNNY_CALLING_MARIN
    db $FF ; c9 MUSICAL_NOTE
    db $FF ; ca MAD_BATTER
    db $FF ; cb ZORA
    db $FF ; cc FISH
    db $FF ; cd BANANAS_SCHULE_SALE
    db $FF ; ce MERMAID_STATUE
    db $FF ; cf SEASHELL_MANSION
    db $FF ; d0 ANIMAL_D0
    db $FF ; d1 ANIMAL_D1
    db $FF ; d2 ANIMAL_D2
    db $FF ; d3 BUNNY_D3
    db $FF ; d4 GHOST
    db $FF ; d5 ROOSTER
    db $FF ; d6 SIDE_VIEW_POT
    db $FF ; d7 THWIMP
    db $FF ; d8 THWOMP
    db $FF ; d9 THWOMP_RAMMABLE
    db $FF ; da PODOBOO
    db $FF ; db GIANT_BUBBLE
    db $FF ; dc FLYING_ROOSTER_EVENTS
    db $FF ; dd BOOK
    db $FF ; de EGG_SONG_EVENT
    db $FF ; df SWORD_BEAM
    db $FF ; e0 MONKEY
    db $FF ; e1 WITCH_RAT
    db $FF ; e2 FLAME_SHOOTER
    db $FF ; e3 POKEY
    db $FF ; e4 MOBLIN_KING
    db $FF ; e5 FLOATING_ITEM_2
    db $FF ; e6 FINAL_NIGHTMARE
    db $FF ; e7 KANALET_CASTLE_GATE_SWITCH
    db $FF ; e8 ENDING_OWL_STAIR_CLIMBING
    db $FF ; e9 COLOR_SHELL_RED
    db $FF ; ea COLOR_SHELL_GREEN
    db $FF ; eb COLOR_SHELL_BLUE
    db $FF ; ec COLOR_GHOUL_RED
    db $FF ; ed COLOR_GHOUL_GREEN
    db $FF ; ee COLOR_GHOUL_BLUE
    db $FF ; ef ROTOSWITCH_RED
    db $FF ; f0 ROTOSWITCH_YELLOW
    db $FF ; f1 ROTOSWITCH_BLUE
    db $FF ; f2 FLYING_HOPPER_BOMBS
    db $FF ; f3 HOPPER
    db $FF ; f4 AVALAUNCH
    db $FF ; f5 BOUNCING_BOULDER
    db $FF ; f6 COLOR_GUARDIAN_BLUE
    db $FF ; f7 COLOR_GUARDIAN_RED
    db $FF ; f8 GIANT_BUZZ_BLOB
    db $FF ; f9 HARDHIT_BEETLE
    db $FF ; fa PHOTOGRAPHER
}

; wLoadedEntitySpritesheets
; wEntityTilesSpriteslotIndexA
; hNeedsUpdatingEntityTilesA
; wEntityTilesSpriteslotIndexB
; wNeedsUpdatingEntityTilesB
; wEntityTilesLoadingStageA (unused)
; wEntityTilesLoadingStageB (unused)
