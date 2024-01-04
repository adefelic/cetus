;;
; overworld tileset
; this is a representation of the overworld tileset in vram in bank 0

; room type tiles / pausemap gfx tiles
; deprecated for use as collision map
; these tiles are both graphical tiles and the source of truth for the room map itself
; todo decouple these? nah the pausemap is a debug feature not a feature feature

; ow-simple
DEF PAUSEMAP_TILE_NONE EQU $00
DEF PAUSEMAP_TILE_L    EQU $01
DEF PAUSEMAP_TILE_B    EQU $02
DEF PAUSEMAP_TILE_BL   EQU $03
DEF PAUSEMAP_TILE_R    EQU $04
DEF PAUSEMAP_TILE_RL   EQU $05
DEF PAUSEMAP_TILE_RB   EQU $06
DEF PAUSEMAP_TILE_RBL  EQU $07
DEF PAUSEMAP_TILE_T    EQU $08
DEF PAUSEMAP_TILE_TL   EQU $09
DEF PAUSEMAP_TILE_TB   EQU $0A
DEF PAUSEMAP_TILE_TBL  EQU $0B
DEF PAUSEMAP_TILE_TR   EQU $0C
DEF PAUSEMAP_TILE_TRL  EQU $0D
DEF PAUSEMAP_TILE_TRB  EQU $0E
DEF PAUSEMAP_TILE_TRBL EQU $0F
DEF FP_TILE_DARK       EQU $10
DEF FP_TILE_GROUND     EQU $11
DEF FP_TILE_WALL_SIDE  EQU $12
DEF FP_TILE_WALL_FRONT EQU $13
DEF FP_TILE_DIAG_R     EQU $14
DEF FP_TILE_DIAG_L     EQU $15

; modal-simple
DEF MODAL_TILE_EMPTY              EQU $16
DEF MODAL_TILE_TOP_LEFT_CORNER    EQU $17
DEF MODAL_TILE_HORIZONTAL         EQU $18
DEF MODAL_TILE_BOTTOM_LEFT_CORNER EQU $19
DEF MODAL_TILE_VERTICAL           EQU $1A
