;DEF TILE_WIDTH EQU 8 ; pixels
;DEF LEN_2BPP_TILE EQU 2 * TILE_WIDTH ; bytes
;DEF tiles EQUS "* LEN_2BPP_TILE"

; palette macros
MACRO assert_valid_rgb
	rept _NARG
		assert 0 <= (\1) && (\1) <= 31, "RGB channel must be 0-31"
		shift
	endr
ENDM

MACRO RGB
	rept _NARG / 3
		assert_valid_rgb \1, \2, \3
		dw palred (\1) + palgreen (\2) + palblue (\3)
		shift 3
	endr
ENDM

DEF palred   EQUS "(1 << 0) *"
DEF palgreen EQUS "(1 << 5) *"
DEF palblue  EQUS "(1 << 10) *"

; palette defs
DEF NUM_PAL_COLORS EQU 4
DEF PAL_COLOR_SIZE EQU 2 ; bytes
DEF PALETTE_SIZE EQU NUM_PAL_COLORS * PAL_COLOR_SIZE ; bytes

; screen defs
DEF SCREEN_WIDTH EQU 20  ; tiles
DEF SCREEN_HEIGHT EQU 18 ; tiles

; tilemap defs
DEF TILEMAP_WIDTH EQU 32  ; bytes / tile ids / tiles
DEF TILEMAP_HEIGHT EQU 32 ; bytes / tile ids / tiles
DEF TILEMAP_SIZE EQU TILEMAP_WIDTH * TILEMAP_HEIGHT ; bytes

; misc
DEF CLEAN EQU $00
DEF DIRTY EQU $01

; tilemap offsets
DEF BG_ROW_0  EQU $0
DEF BG_ROW_1  EQU $20
DEF BG_ROW_2  EQU $40
DEF BG_ROW_3  EQU $60
DEF BG_ROW_4  EQU $80
DEF BG_ROW_5  EQU $A0
DEF BG_ROW_6  EQU $C0
DEF BG_ROW_7  EQU $E0
DEF BG_ROW_8  EQU $100
DEF BG_ROW_9  EQU $120
DEF BG_ROW_10 EQU $140
DEF BG_ROW_11 EQU $160
DEF BG_ROW_12 EQU $180
DEF BG_ROW_13 EQU $1A0
DEF BG_ROW_14 EQU $1C0
DEF BG_ROW_15 EQU $1E0
DEF BG_ROW_16 EQU $200
DEF BG_ROW_17 EQU $220

DEF BG_COL_0  EQU $0
DEF BG_COL_1  EQU $1
DEF BG_COL_2  EQU $2
DEF BG_COL_3  EQU $3
DEF BG_COL_4  EQU $4
DEF BG_COL_5  EQU $5
DEF BG_COL_6  EQU $6
DEF BG_COL_7  EQU $7
DEF BG_COL_8  EQU $8
DEF BG_COL_9  EQU $9
DEF BG_COL_10 EQU $A
DEF BG_COL_11 EQU $B
DEF BG_COL_12 EQU $C
DEF BG_COL_13 EQU $D
DEF BG_COL_14 EQU $E
DEF BG_COL_15 EQU $F
DEF BG_COL_16 EQU $10
DEF BG_COL_17 EQU $11
DEF BG_COL_18 EQU $12
DEF BG_COL_19 EQU $13

; palette indices
DEF INDEX_OW_PALETTE_Z0 EQU $00
DEF INDEX_OW_PALETTE_Z1 EQU $01
DEF INDEX_OW_PALETTE_Z2 EQU $02