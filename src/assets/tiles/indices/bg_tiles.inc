;;
; overworld tileset
; this is a representation of the overworld tileset in vram in bank 0

; room type tiles / pausemap gfx tiles
; deprecated for use as collision map
; these tiles are both graphical tiles and the source of truth for the room map itself
; todo decouple these? nah the pausemap is a debug feature not a feature feature

; explore-simple
DEF TILE_MAP_NONE                 EQU $00
DEF TILE_MAP_L                    EQU $01
DEF TILE_MAP_B                    EQU $02
DEF TILE_MAP_BL                   EQU $03
DEF TILE_MAP_R                    EQU $04
DEF TILE_MAP_RL                   EQU $05
DEF TILE_MAP_RB                   EQU $06
DEF TILE_MAP_RBL                  EQU $07
DEF TILE_MAP_T                    EQU $08
DEF TILE_MAP_TL                   EQU $09
DEF TILE_MAP_TB                   EQU $0A
DEF TILE_MAP_TBL                  EQU $0B
DEF TILE_MAP_TR                   EQU $0C
DEF TILE_MAP_TRL                  EQU $0D
DEF TILE_MAP_TRB                  EQU $0E
DEF TILE_MAP_TRBL                 EQU $0F
DEF TILE_EXPLORE_DARK             EQU $10
DEF TILE_EXPLORE_GROUND           EQU $11
DEF TILE_EXPLORE_WALL_SIDE        EQU $12
DEF TILE_EXPLORE_WALL_FRONT       EQU $13
DEF TILE_EXPLORE_DIAG_R           EQU $14
DEF TILE_EXPLORE_DIAG_L           EQU $15
DEF TILE_GRASS_NEAR               EQU $16
DEF TILE_GRASS_FAR                EQU $17
DEF TILE_MODAL_TOP_LEFT_CORNER    EQU $18
DEF TILE_MODAL_HORIZONTAL         EQU $19
DEF TILE_MODAL_BOTTOM_LEFT_CORNER EQU $1A
DEF TILE_MODAL_VERTICAL           EQU $1B
DEF TILE_MODAL_EMPTY              EQU $1C
DEF TILE_ENCOUNTER_BLANK          EQU $1D
DEF TILE_ENCOUNTER_RAMP_LOW       EQU $1E
DEF TILE_ENCOUNTER_FLAT           EQU $1F
DEF TILE_ENCOUNTER_RAMP_HIGH      EQU $20
DEF TILE_ENCOUNTER_GRASS          EQU $21
DEF TILE_ENCOUNTER_ARROW_SHAFT    EQU $22
DEF TILE_ENCOUNTER_ARROW_POINT    EQU $23
DEF TILE_DISTANCE_FOG_LEFT_WALL   EQU $24
DEF TILE_DISTANCE_FOG_A           EQU $25
DEF TILE_DISTANCE_FOG_B           EQU $26
DEF TILE_DISTANCE_FOG_LEFT_CORNER EQU $27
DEF TILE_DISTANCE_FOG_GROUND      EQU $28
