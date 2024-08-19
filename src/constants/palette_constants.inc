IF !DEF(DEF_PALETTES_CONSTANTS)
DEF DEF_PALETTES_CONSTANTS EQU 1

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
DEF NUM_PAL_IN_SET EQU 8
DEF PAL_COLOR_SIZE EQU 2 ; bytes. 5 bits per color channel (R G B)
DEF PALETTE_SIZE EQU NUM_PAL_COLORS * PAL_COLOR_SIZE ; bytes
DEF PALETTE_SET_SIZE EQU PALETTE_SIZE * NUM_PAL_IN_SET ; bytes


; palette offsets
; todo: currently only colors 1 and 2 are used for rendering walls and floor. 0 and 3 are unused
; one of those should become a fog color
DEF BG_PALETTE_Z0          EQU $00
DEF BG_PALETTE_SIDE_NEAR   EQU BG_PALETTE_Z0
DEF BG_PALETTE_GROUND_NEAR EQU BG_PALETTE_Z0

DEF BG_PALETTE_Z1         EQU $01
DEF BG_PALETTE_FRONT_NEAR EQU BG_PALETTE_Z1

DEF BG_PALETTE_Z2         EQU $02
DEF BG_PALETTE_SIDE_FAR   EQU BG_PALETTE_Z2
DEF BG_PALETTE_GROUND_FAR EQU BG_PALETTE_Z2


DEF BG_PALETTE_Z3        EQU $03
DEF BG_PALETTE_FRONT_FAR EQU BG_PALETTE_Z3

DEF BG_PALETTE_UI      EQU $04 ; ui elements
DEF BG_PALETTE_UI2     EQU $05 ; ui elements (highlighted) ; maybe this can be replaced with a cursor and i can have more space for special palettes
DEF BG_PALETTE_SPECIAL EQU $06 ; special wall? ; this will end up holding the enemy palette during encounters
DEF BG_PALETTE_ENEMY   EQU BG_PALETTE_SPECIAL
DEF BG_PALETTE_FOG     EQU $07 ; (fog) gate wall
DEF BG_PALETTE_ENEMY_DAMAGE EQU BG_PALETTE_FOG

DEF OBJ_PALETTE_QUARTZ EQU $00 
DEF OBJ_PALETTE_LAMP   EQU $01
DEF OBJ_PALETTE_TENT   EQU $02 ; unused
DEF OBJ_PALETTE_D      EQU $03 ; unused
DEF OBJ_PALETTE_E      EQU $04 ; unused
DEF OBJ_PALETTE_DANGER EQU $05
DEF OBJ_PALETTE_PLAYER EQU $06 ; used in encounter so ... deprecated
DEF OBJ_PALETTE_H      EQU $07 ; unused

ENDC ;DEF_PALETTES_CONSTANTS
