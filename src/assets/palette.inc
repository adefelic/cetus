INCLUDE "src/constants/palette_constants.inc"

SECTION "Palette Data", ROMX

OwBgPaletteSet::
    ;    ?         floor       wall       ?
	;    dark,     tan,        green,     grey-brown,
	RGB  4, 4, 4,  12, 9, 8,   0, 8, 6,   7, 6, 8 ; z = 0, near sides
	RGB  4, 4, 4,  13,10, 8,   1, 9, 6,   8, 6, 8 ; z = 1, near front
	RGB  4, 4, 4,  14,11, 9,   1,10, 7,   9, 7, 8 ; z = 2, far sides
	RGB  4, 4, 4,  15,12, 9,   1,11, 7,  10, 7, 8 ; z = 3, far front

	RGB  1, 1, 1,  13,13,13,   2,10, 2,   2, 2,10 ; ui
	RGB  13,13,13,  2,10, 2,   2, 2,10,   1, 1, 1 ; ui2 (highlighted)
	RGB  4,12, 8,  13,15,15,   7,14,10,  10,15,12 ; fog
	RGB  1, 4, 1,   1, 4, 1,   1, 6, 2,   1, 8, 4 ; fog2 ; this is the dark fog for ABDE segments. temporary!

; Obj palettes
OwObjPaletteSet::
	;   clear  lightblue  blue       unused
	RGB 0,0,0,  0,27,31,  00,14,24,  31,31,31 ; quartz
	;   clear  lightbrown brown      yellow
	RGB 0,0,0, 20,12, 3,  13, 9, 0,  31,26, 0 ; lamp
	RGB 0,0,0,  1,10, 6,  14, 5, 6,  13,10, 8 ; tent
	RGB 0,0,0,  0, 8, 6,  13, 4, 5,  12, 9, 8 ; unused
	RGB 0,0,0, 13,13,13,   2, 2,10,   2,10, 2 ; unused
	RGB 0,0,0, 14, 3, 3,   9, 9, 2,   9, 9, 9 ; danger
	RGB 0,0,0, 10,10,12,   6, 6, 8,   2, 2, 4 ; player
	RGB 0,0,0,  0, 0, 0,   0, 0, 0,   0, 0, 0 ; unused
	RGB 0,0,0,  0, 0, 0,   0, 0, 0,   0, 0, 0 ; unused
