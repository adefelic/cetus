INCLUDE "src/constants/palette_constants.inc"

SECTION "Palette Data", ROMX

; BG palettes
ForestBgPaletteSet::
	;    unused    ground      wall       unused
	;    dark,     tan,        green,     grey-brown,
	RGB  4, 4, 4,  12, 9, 8,  0, 8, 6,   7, 6, 8 ; z = 0, near sides
	RGB  4, 4, 4,  00,00,00,  1, 9, 6,   8, 6, 8 ; z = 1, near front
	RGB  4, 4, 4,  14,11, 9,  1,10, 7,   9, 7, 8 ; z = 2, far sides
	RGB  4, 4, 4,  00,00,00,  1,11, 7,  10, 7, 8 ; z = 3, far front

	;    text bg   text       text2?     unused
	RGB  1, 1, 1,  13,13,13,  2,10, 2,   2, 2,10 ; ui
	RGB  03,03,03,  2,10, 2,  2, 2,10,   2, 2,10 ; ui2 (highlighted)

	RGB  00,00,00, 20,00,00,  00,20,00,  00,00,20 ; special, for bridge walls maybe? has no depth. unused so far

	;    fog 1     fog 2      ground     wall
	RGB  15,15,15, 14,14,14,  14,11,09,  01,12,07 ; fog

SwampBgPaletteSet::
	;    unused    ground     wall       unused
	RGB  4, 4, 4,   4, 4, 4,  5, 5, 8,   0, 0, 0 ; z = 0, near sides
	RGB  4, 4, 4,  00,00,00,  5, 5, 9,   0, 0, 0 ; z = 1, near front
	RGB  4, 4, 4,   6, 5, 6,  5, 6,10,   0, 0, 0 ; z = 2, far sides
	RGB  4, 4, 4,  00,00,00,  5, 6,11,   0, 0, 0 ; z = 3, far front
	RGB  1, 1, 1,  13,13,13,  2,10, 2,   2, 2,10 ; ui
	RGB  13,13,13,  2,10, 2,  2, 2,10,   1, 1, 1 ; ui2 (highlighted)
	RGB  4,12, 8,  13,15,15,  7,14,10,  10,15,12 ; special, for ocean walls? has no depth. unused so far
	;    fog 1     fog 2      ground     wall
	RGB  11,11,11, 10,10,10,  6, 5, 6,  05,06,12, ; fog

; Obj palettes
OwObjPaletteSet::
	RGB 0,0,0,  0,27,31,  00,14,24,  31,31,31 ; quartz: clear, lightblue, blue, unused
	RGB 0,0,0, 31,25,00,  20,12, 3,  13,09,00 ; lamp: clear, yellow, dark brown, light brown
	RGB 0,0,0,  1,10, 6,  14, 5, 6,  13,10, 8 ; tent
	RGB 0,0,0,  0, 8, 6,  13, 4, 5,  12, 9, 8 ; unused
	RGB 0,0,0, 13,13,13,   2, 2,10,   2,10, 2 ; unused
	RGB 0,0,0, 14, 3, 3,   9, 9, 2,   9, 9, 9 ; danger indicator
	RGB 0,0,0, 10,10,12,   6, 6, 8,   2, 2, 4 ; player
	RGB 0,0,0,  0, 0, 0,   0, 0, 0,   0, 0, 0 ; unused
	RGB 0,0,0,  0, 0, 0,   0, 0, 0,   0, 0, 0 ; unused
