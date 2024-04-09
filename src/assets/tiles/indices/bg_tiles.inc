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
DEF TILE_FOG_BLANK                EQU $24
DEF TILE_FOG_R6_C0                EQU $25
DEF TILE_FOG_R6_C7                EQU $26
DEF TILE_FOG_R7_C0                EQU $27
DEF TILE_FOG_R7_C1                EQU $28
DEF TILE_FOG_R7_C2                EQU $29
DEF TILE_FOG_R7_C3                EQU $2A
DEF TILE_FOG_R7_C4                EQU $2B
DEF TILE_FOG_R7_C5                EQU $2C
DEF TILE_FOG_R7_C6                EQU $2D
DEF TILE_FOG_R7_C7                EQU $2E
DEF TILE_FOG_R8_C0                EQU $2F
DEF TILE_FOG_R8_C1                EQU $30
DEF TILE_FOG_R8_C2                EQU $31
DEF TILE_FOG_R8_C3                EQU $32
DEF TILE_FOG_R8_C4                EQU $33
DEF TILE_FOG_R8_C5                EQU $34
DEF TILE_FOG_R8_C6                EQU $35
DEF TILE_FOG_R8_C7                EQU $36
DEF TILE_FOG_R9_C0                EQU $37
DEF TILE_FOG_R9_C1                EQU $38
DEF TILE_FOG_R9_C2                EQU $39
DEF TILE_FOG_R9_C3                EQU $3A
DEF TILE_FOG_R9_C4                EQU $3B
DEF TILE_FOG_R9_C5                EQU $3C
DEF TILE_FOG_R9_C6                EQU $3D
DEF TILE_FOG_R9_C7                EQU $3E
DEF TILE_FOG_R10_C0               EQU $3F
DEF TILE_FOG_R10_C1               EQU $40
DEF TILE_FOG_R10_C2               EQU $41
DEF TILE_FOG_R10_C3               EQU $42
DEF TILE_FOG_R10_C4               EQU $43
DEF TILE_FOG_R10_C5               EQU $44
DEF TILE_FOG_R10_C6               EQU $45
DEF TILE_FOG_R10_C7               EQU $46
DEF TILE_FOG_R11_C0               EQU $47
DEF TILE_FOG_R11_C1               EQU $48
DEF TILE_FOG_R11_C2               EQU $49
DEF TILE_FOG_R11_C3               EQU $4A
DEF TILE_FOG_R11_C4               EQU $4B
DEF TILE_FOG_R11_C5               EQU $4C
DEF TILE_FOG_R11_C6               EQU $4D
DEF TILE_FOG_R11_C7               EQU $4E
DEF TILE_FOG_R12_C0               EQU $4F
DEF TILE_FOG_R12_C1               EQU $50
DEF TILE_FOG_R12_C2               EQU $51
DEF TILE_FOG_R12_C3               EQU $52
DEF TILE_FOG_R12_C4               EQU $53
DEF TILE_FOG_R12_C5               EQU $54
DEF TILE_FOG_R12_C6               EQU $55
DEF TILE_FOG_R12_C7               EQU $56
DEF TILE_DISTANCE_FOG_LEFT_WALL   EQU $57
DEF TILE_DISTANCE_FOG_A           EQU $58
DEF TILE_DISTANCE_FOG_B           EQU $59
DEF TILE_DISTANCE_FOG_LEFT_CORNER EQU $5A
DEF TILE_DISTANCE_FOG_GROUND      EQU $5B
