INCLUDE "src/constants/gfx_constants.inc"

SECTION "Palette Data", ROMX

; BG palettes
; z = 0, near sides
; z = 1, near front
; z = 2, far sides
; z = 3, far front

;ui colors
;fog colors (3 + a wall color?)
;z0 floor color 1, floor color 2, wall color 1, wall color 2
;z1 floor color 1, floor color 2, wall color 1, wall color 2
;z2 floor color 1, floor color 2, wall color 1, wall color 2
;z3 floor color 1, floor color 2, wall color 1, wall color 2
;empty
;empty

OwBgPaletteSet::
    ;   ?       floor      wall        ?
	;   dark,   tan,       green,   grey-brown,
	;RGB 4,4,4,  15,12,8,   2,11,6 ,   10,7, 8    ; z = 0, near sides
	;RGB 4,4,4,  14,11,8,   1,10,6 ,   9, 7, 8    ; z = 1, near front
	;RGB 4,4,4,  13,10,8,   1,9,6 ,   8, 6, 8     ; z = 2, far sides
	;RGB 4,4,4,  12,9,8,    0,8,6  ,   7, 6, 8    ; z = 3, far front
	RGB 4,4,4,  12,9,8,    0,8,6  ,   7, 6, 8    ; z = 0
	RGB 4,4,4,  13,10,8,   1,9,6 ,   8, 6, 8     ; z = 1
	RGB 4,4,4,  14,11,9,   1,10,7 ,   9, 7, 8    ; z = 2
	RGB 4,4,4,  15,12,9,   1,11,7 ,   10,7, 8    ; z = 3

	RGB 1,1,1,  13,13,13,  2,10,2 ,   2, 2,10     ; modal
	RGB 4,12,8, 13,15,15,  7,14,10,   10,15,12    ; fog
	;RGB 1,10,6, 6,13,9,    4,12,8,   2,11,7  ; fog, white green
	;RGB 1,10,6, 1,4,1,    1,6,2,   1,8,4     ; fog, dark green ; this palette is great, should use somewhere else
	RGB 1,4,1, 1,4,1,    1,6,2,   1,8,4     ; fog2 ; this is the dark fog for ABDE segments. temporary!
	RGB 0,0,0, 0,0,0,     0, 0, 0,    0,0,0  ; unused

; Obj palettes
OwObjPaletteSet::
	RGB 4,4,4, 2,11,6,   16, 7, 8,   15,12,8 ; unused
	RGB 4,4,4, 1,10,6,   15, 6, 7,   14,11,8 ; unused
	RGB 4,4,4, 1,10,6,   14, 5, 6,   13,10,8 ; unused
	RGB 4,4,4, 0,8,6,    13, 4, 5,   12,9,8  ; unused
	RGB 1,1,1, 13,13,13,  2, 2, 10,   2,10,2 ; unused
	RGB 0,0,0, 14,3,3,    9, 9, 2,    9,9,9  ; danger
	RGB 0,0,0, 10,10,12,  6, 6, 8,    2,2,4  ; player
	RGB 0,0,0, 0,0,0,     0, 0, 0,    0,0,0  ; unused
	RGB 0,0,0, 0,0,0,     0, 0, 0,    0,0,0  ; unused
