INCLUDE "src/constants/palette_constants.inc"

SECTION "Palette Data", ROMX

; BG palettes
ForestBgPaletteSet::

	; palettes 0 - 3
	; explore: walls and ground
	;    door      ground     walls     unused
	; encounter: unused (todo, pick one for environment)
	;    dark,     tan,        green,     grey-brown,
	RGB  00,00,00, 12, 9, 8,  0, 8, 6,   7, 6, 8 ; z0, near sides
	RGB  00,00,00, 20,10,15,  1, 9, 6,   8, 6, 8 ; z1, near front
	RGB  00,00,00, 14,11, 9,  1,10, 7,   9, 7, 8 ; z2, far sides
	RGB  00,00,00, 11,11,11,  1,11, 7,  10, 7, 8 ; z3, far front

	; palettes 4 & 5
	; explore & encounter:
	;    text bg   text       text2?     unused
	RGB  2, 2, 2,  13,13,13,  2,10, 2,   2, 2,10 ; ui
	RGB  03,03,03,  2,10, 2,  2, 2,10,   2, 2,10 ; ui2 (highlighted)

	; palette 6
	; explore: special, for bridge walls maybe? has no depth. unused so far
	; encounter: enemy portrait palette
	RGB  00,00,00, 20,00,00,  00,20,00,  00,00,20

	; palette 7
	; explore: fog & fog corners
	;    fog 1     fog 2      ground     wall
	; encounter: enemy damage
	RGB  15,15,15, 14,14,14,  14,11,09,  01,12,07 ; fog

SwampBgPaletteSet::
	;                                    grey-brown,
	RGB  00,00,00,  4, 4, 4,  5, 5, 8,   7, 6, 8 ; z0, near sides
	RGB  00,00,00, 00,00,00,  5, 5, 9,   8, 6, 8 ; z1, near front
	RGB  00,00,00,  6, 5, 6,  5, 6,10,   9, 7, 8 ; z2, far sides
	RGB  00,00,00, 00,00,00,  5, 6,11,  10, 7, 8 ; z3, far front

	RGB  2, 2, 2,  13,13,13,  2,10, 2,   2, 2,10 ; ui
	RGB  13,13,13,  2,10, 2,  2, 2,10,   1, 1, 1 ; ui2 (highlighted)

	RGB  4,12, 8,  13,15,15,  7,14,10,  10,15,12 ; special, for ocean walls? has no depth. unused so far

	;    fog 1     fog 2      ground    wall
	RGB  11,11,11, 10,10,10,  6, 5, 6,  05,06,12, ; fog

; Obj palettes
OwObjPaletteSet::
	RGB 0,0,0,  0,27,31,  00,14,24,  31,31,31 ; rock: clear, light blue, blue, unused
	RGB 0,0,0, 31,25,00,  20,12, 3,  13,09,00 ; lamp: clear, yellow, dark brown, light brown
	RGB 0,0,0,  1,10, 6,  14, 5, 6,  13,10, 8 ; tent
	RGB 0,0,0,  0, 8, 6,  13, 4, 5,  12, 9, 8 ; unused
	RGB 0,0,0, 13,13,13,   2, 2,10,   2,10, 2 ; unused
	RGB 0,0,0, 14, 3, 3,   9, 9, 2,   9, 9, 9 ; danger indicator
	RGB 0,0,0, 10,10,12,   6, 6, 8,   2, 2, 4 ; player
	RGB 0,0,0,  0, 0, 0,   0, 0, 0,   0, 0, 0 ; unused
	RGB 0,0,0,  0, 0, 0,   0, 0, 0,   0, 0, 0 ; unused


; Enemy/NPC Palettes
NPCGreenBriarsPalette::
	;    bckgrnd   branch    thorn     thorn highlight
	RGB  00,00,00, 10,10,04, 16,04,02, 20,04,02
NPCOldBonesPalette::
	;    bckgrnd   bone      handle    blade
	RGB  00,00,00, 22,22,18, 13,10,03, 08,08,08
NPCSunflowerPalette::
	;    bckgrnd   stem      flower    eyes
	RGB  00,00,00, 10, 7, 4, 16,10,02, 12,06,03
NPCMoonflowerPalette::
	;    bckgrnd   stem      flower    eyes
	RGB  00,00,00, 10,10,13, 02,08,16, 15,15,20


