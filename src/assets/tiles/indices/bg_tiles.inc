INCLUDE "src/constants/gfx_constants.inc"

;;
; overworld tileset
; this is a representation of the overworld tileset in vram in bank 0

; room type tiles / pausemap gfx tiles
; deprecated for use as collision map
; these tiles are both graphical tiles and the source of truth for the room map itself
; todo decouple these? nah the pausemap is a debug feature not a feature feature

; todo this should really just become a single file.
; nothing i'm doing is dynamic enough to require the complexity.
; this would also standardize which colors are 0,1,2,3
; it would make it easier to add new tiles without having to update all of the indices

; offsets from VRAM_BG_BLOCK
; explore tiles
DEF TILE_COLOR_0                  EQU 0 ; unused
DEF TILE_UI_BORDER_EMPTY          EQU TILE_COLOR_0
DEF TILE_COLOR_1                  EQU 1
DEF TILE_EXPLORE_GROUND           EQU TILE_COLOR_1
DEF TILE_COLOR_2                  EQU 2
DEF TILE_EXPLORE_WALL             EQU TILE_COLOR_2
DEF TILE_COLOR_3                  EQU 3 ; unused
DEF TILE_EXPLORE_DIAG_R           EQU 4
DEF TILE_EXPLORE_DIAG_L           EQU 5
DEF TILE_GRASS_NEAR               EQU 6
DEF TILE_GRASS_FAR                EQU 7
DEF TILE_UI_BORDER_TL_CORNER      EQU 8
DEF TILE_UI_BORDER_HORIZONTAL     EQU 9
DEF TILE_UI_BORDER_BL_CORNER      EQU 10
DEF TILE_UI_BORDER_VERTICAL       EQU 11
DEF TILE_DISTANCE_FOG_LEFT_WALL   EQU 12
DEF TILE_DISTANCE_FOG_A           EQU 13
DEF TILE_DISTANCE_FOG_B           EQU 14
DEF TILE_DISTANCE_FOG_LEFT_CORNER EQU 15
DEF TILE_DISTANCE_FOG_GROUND      EQU 16
DEF TILES_ENV_BLOCK_LEFT          EQU 17
DEF TILES_ENV_BLOCK_RIGHT         EQU TILES_ENV_BLOCK_LEFT + ENC_ENV_BLOCK_TILE_SIZE

; offsets from NPC_SPRITE_TILE_VRAM_ADDR
DEF TILES_ENCOUNTER_NPC EQU $80

; offsets from WALL_TILE_VRAM_ADDR

; side far, column of 1
DEF TILE_FIELD_WALL_B_WALL          EQU $80
DEF TILE_FIELD_WALL_B_DOOR          EQU $82
DEF TILE_FIELD_WALL_B_SIDE_FAR_DIAG EQU $84
