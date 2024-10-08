INCLUDE "src/lib/hardware.inc"

IF !DEF(DEF_GFX_CONSTANTS)
DEF DEF_GFX_CONSTANTS EQU 1

;; memory locations

; vram locations
DEF TILEMAP_BACKGROUND EQU _SCRN0
DEF TILEMAP_WINDOW EQU _SCRN1

DEF VRAM_OBJ_BLOCK EQU _VRAM8000
DEF VRAM_BOTH_BLOCK EQU _VRAM8800
DEF VRAM_BG_BLOCK EQU _VRAM9000

;; sizes

; screen defs
DEF SCREEN_WIDTH EQU 20  ; tiles
DEF SCREEN_HEIGHT EQU 18 ; tiles
DEF SCREEN_SIZE EQU SCREEN_WIDTH * SCREEN_HEIGHT ; bytes

; tilemap defs
DEF TILEMAP_WIDTH EQU 32  ; bytes / tile ids / tiles
DEF TILEMAP_HEIGHT EQU 32 ; bytes / tile ids / tiles

DEF VISIBLE_TILEMAP_SIZE EQU TILEMAP_WIDTH * SCREEN_HEIGHT ; 576 bytes
DEF TILEMAP_SIZE EQU TILEMAP_WIDTH * TILEMAP_HEIGHT ; bytes

; tile defs
DEF TILE_WIDTH EQU 8 ; pixels
DEF TILE_HEIGHT EQU 8 ; pixels
DEF TILE_SIZE EQU TILE_WIDTH * TILE_HEIGHT * 2 / 8 ; bytes (16)
DEF tiles EQUS "TILE_SIZE *"

; oam coordinate padding
DEF OAM_PADDING_Y EQU 16
DEF OAM_PADDING_X EQU 8

; tilemap offsets
DEF BG_ROW_SIZE EQU $20
DEF rows EQUS "BG_ROW_SIZE *"
DEF BG_COL_SIZE EQU $1
DEF cols EQUS "BG_COL_SIZE *"

DEF OFFSCREEN_X EQU $A8 ; 168, 160 + 8
DEF OFFSCREEN_Y EQU $A0 ; 160, 144 + 16

; npc graphics
DEF NPC_SPRITE_TILE_WIDTH EQU 3
DEF NPC_SPRITE_TILE_HEIGHT EQU 5

DEF NPC_SPRITE_TILES EQU NPC_SPRITE_TILE_WIDTH * NPC_SPRITE_TILE_HEIGHT
DEF NPC_SPRITE_TILES_SIZE EQU tiles NPC_SPRITE_TILES ; bytes

; encounter environments
DEF ENC_ENV_BLOCK_TILE_WIDTH EQU 5
DEF ENC_ENV_BLOCK_TILE_HEIGHT EQU 5
DEF ENC_ENV_BLOCK_TILE_SIZE EQU ENC_ENV_BLOCK_TILE_WIDTH * ENC_ENV_BLOCK_TILE_HEIGHT

; pause graphics
DEF EQUIPMENT_ICON_HEIGHT EQU 2 ; tiles
DEF EQUIPMENT_ICON_WIDTH EQU 2 ; tiles
DEF EQUIPMENT_ICON_TILES EQU EQUIPMENT_ICON_HEIGHT * EQUIPMENT_ICON_WIDTH ; tiles
DEF EQUIPMENT_ICON_SIZE EQU EQUIPMENT_ICON_TILES * TILE_SIZE

DEF PAPER_DOLL_HEAD_TOP EQU 0
DEF PAPER_DOLL_HEAD_LEFT EQU 4
DEF PAPER_DOLL_HEAD_HEIGHT EQU 3
DEF PAPER_DOLL_HEAD_WIDTH EQU 4
DEF PAPER_DOLL_HEAD_TILES EQU PAPER_DOLL_HEAD_HEIGHT * PAPER_DOLL_HEAD_WIDTH

DEF PAPER_DOLL_BODY_TOP EQU 2
DEF PAPER_DOLL_BODY_LEFT EQU 3
DEF PAPER_DOLL_BODY_HEIGHT EQU 6
DEF PAPER_DOLL_BODY_WIDTH EQU 6
DEF PAPER_DOLL_BODY_TILES EQU PAPER_DOLL_BODY_HEIGHT * PAPER_DOLL_BODY_WIDTH

DEF PAPER_DOLL_LEGS_TOP EQU 8
DEF PAPER_DOLL_LEGS_LEFT EQU 3
DEF PAPER_DOLL_LEGS_HEIGHT EQU 4
DEF PAPER_DOLL_LEGS_WIDTH EQU 6
DEF PAPER_DOLL_LEGS_TILES EQU PAPER_DOLL_LEGS_HEIGHT * PAPER_DOLL_LEGS_WIDTH

DEF PAPER_DOLL_WEAPON_TOP EQU 0
DEF PAPER_DOLL_WEAPON_LEFT EQU 9
DEF PAPER_DOLL_WEAPON_HEIGHT EQU 12
DEF PAPER_DOLL_WEAPON_WIDTH EQU 3
DEF PAPER_DOLL_WEAPON_TILES EQU PAPER_DOLL_WEAPON_HEIGHT * PAPER_DOLL_WEAPON_WIDTH

; wall graphics, per special wall type
DEF WALL_TILES EQU 32 ; arbitrary atm
DEF WALL_TILES_SIZE EQU WALL_TILES * TILE_SIZE

DEF TOP_SEGMENTS_HEIGHT    EQU 13 ; tiles
DEF MIDDLE_ROW_SEGMENT_HEIGHT EQU 3 ; tiles
DEF BOTTOM_ROW_SEGMENT_HEIGHT EQU 2 ; tiles

DEF TOP_SEGMENTS_TOP EQU 0
DEF MIDDLE_SEGMENTS_TOP EQU TOP_SEGMENTS_TOP + TOP_SEGMENTS_HEIGHT
DEF BOTTOM_SEGMENTS_TOP EQU MIDDLE_SEGMENTS_TOP + MIDDLE_ROW_SEGMENT_HEIGHT
DEF SCREEN_BOTTOM EQU BOTTOM_SEGMENTS_TOP + BOTTOM_ROW_SEGMENT_HEIGHT

DEF SEGMENT_A_LEFT EQU 0
DEF SEGMENT_B_LEFT EQU 3
DEF SEGMENT_C_LEFT EQU 6
DEF SEGMENT_D_LEFT EQU 14
DEF SEGMENT_E_LEFT EQU 17
DEF SEGMENT_K_LEFT EQU 0
DEF SEGMENT_L_LEFT EQU 3
DEF SEGMENT_M_LEFT EQU 6
DEF SEGMENT_N_LEFT EQU 15
DEF SEGMENT_O_LEFT EQU 17
DEF SEGMENT_P_LEFT EQU 0
DEF SEGMENT_Q_LEFT EQU 3
DEF SEGMENT_R_LEFT EQU 18

DEF SEGMENT_A_WIDTH EQU 3
DEF SEGMENT_B_WIDTH EQU 3
DEF SEGMENT_C_WIDTH EQU 8
DEF SEGMENT_D_WIDTH EQU 3
DEF SEGMENT_E_WIDTH EQU 3

DEF SEGMENT_K_WIDTH EQU 3
DEF SEGMENT_O_WIDTH EQU 3

ENDC
