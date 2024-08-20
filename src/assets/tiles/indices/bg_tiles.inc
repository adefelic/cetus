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
; explore-simple
;DEF TILE_MAP_NONE                 EQU $00 all unused
;DEF TILE_MAP_L                    EQU $01
;DEF TILE_MAP_B                    EQU $02
;DEF TILE_MAP_BL                   EQU $03
;DEF TILE_MAP_R                    EQU $04
;DEF TILE_MAP_RL                   EQU $05
;DEF TILE_MAP_RB                   EQU $06
;DEF TILE_MAP_RBL                  EQU $07
;DEF TILE_MAP_T                    EQU $08
;DEF TILE_MAP_TL                   EQU $09
;DEF TILE_MAP_TB                   EQU $0A
;DEF TILE_MAP_TBL                  EQU $0B
;DEF TILE_MAP_TR                   EQU $0C
;DEF TILE_MAP_TRL                  EQU $0D
;DEF TILE_MAP_TRB                  EQU $0E
;DEF TILE_MAP_TRBL                 EQU $0F
;DEF TILE_EXPLORE_DARK             EQU $10
DEF TILE_EXPLORE_GROUND           EQU $11
DEF TILE_EXPLORE_WALL        EQU $12
;DEF TILE_EXPLORE_WALL_FRONT       EQU $13 unused
DEF TILE_EXPLORE_DIAG_R           EQU $14
DEF TILE_EXPLORE_DIAG_L           EQU $15
DEF TILE_GRASS_NEAR               EQU $16
DEF TILE_GRASS_FAR                EQU $17
DEF TILE_MODAL_TL_CORNER          EQU $18
DEF TILE_MODAL_HORIZONTAL         EQU $19
DEF TILE_MODAL_BOTTOM_LEFT_CORNER EQU $1A ; todo replace this with TILE_MODAL_TL_CORNER but flipped
DEF TILE_MODAL_VERTICAL           EQU $1B
DEF TILE_MODAL_EMPTY              EQU $1C ; todo replace this with the T shaped tile
;DEF TILE_ENCOUNTER_BLANK          EQU $1D unused
;DEF TILE_ENCOUNTER_RAMP_LOW       EQU $1E
;DEF TILE_ENCOUNTER_FLAT           EQU $1F
;DEF TILE_ENCOUNTER_RAMP_HIGH      EQU $20
;DEF TILE_ENCOUNTER_GRASS          EQU $21
;DEF TILE_ENCOUNTER_ARROW_SHAFT    EQU $22
;DEF TILE_ENCOUNTER_ARROW_POINT    EQU $23
DEF TILE_DISTANCE_FOG_LEFT_WALL   EQU $24
DEF TILE_DISTANCE_FOG_A           EQU $25
DEF TILE_DISTANCE_FOG_B           EQU $26
DEF TILE_DISTANCE_FOG_LEFT_CORNER EQU $27
DEF TILE_DISTANCE_FOG_GROUND      EQU $28
; env tiles
DEF TILES_ENV_BLOCK_LEFT          EQU $29
DEF TILES_ENV_BLOCK_RIGHT         EQU $42
DEF TILES_ENV_LINE_WIDTH          EQU $05

; offsets from NPC_SPRITE_TILE_VRAM_ADDR
DEF TILES_ENCOUNTER_NPC EQU $80

; offsets from WALL_TILE_VRAM_ADDR

; side far, column of 1
DEF TILE_FIELD_WALL_B_BLANK         EQU $80
DEF TILE_FIELD_WALL_B_SIDE_FAR_TOP  EQU $81
DEF TILE_FIELD_WALL_B_BLANK_DOOR    EQU $82
DEF TILE_FIELD_WALL_B_SIDE_DIAG     EQU $83
DEF TILE_FIELD_WALL_B_SIDE_FAR_DIAG EQU $84

; front far, rows of 4:
DEF TILE_FIELD_WALL_B_FRONT_FAR_TL EQU $85
DEF TILE_FIELD_WALL_B_FRONT_FAR_TM EQU $86
; TM again
; TL x-flipped

DEF TILE_FIELD_WALL_B_FRONT_FAR_SIDE EQU $87
; blank-door
; blank-door
; far-side x-flipped

; repeat the row above 3 more times

; front near, rows of 6
DEF TILE_FIELD_WALL_B_FRONT_NEAR_TLL EQU $88
DEF TILE_FIELD_WALL_B_FRONT_NEAR_TL  EQU $89
DEF TILE_FIELD_WALL_B_FRONT_NEAR_TM  EQU $8A
; TM
; TL x-flipped
; TLL x-flipped

; TILE_FIELD_WALL_B_FRONT_FAR_SIDE
; blank-door
; blank-door
; blank-door
; blank-door
; TILE_FIELD_WALL_B_FRONT_FAR_SIDE x-flipped

; the above row 7 times total

; side near, column of 1
DEF TILE_FIELD_WALL_B_SIDE_NEAR_T EQU $8B
DEF TILE_FIELD_WALL_B_SIDE_NEAR_DOOR EQU $8C
; the above tile is used for 10 rows
