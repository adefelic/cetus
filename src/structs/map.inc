INCLUDE "src/lib/structs.inc"

	struct Map
		bytes 1, Height ; in rooms ; 32 or 30 ... 32
		bytes 1, Width  ; in rooms
		bytes 1, StartingOrientation
		bytes 1, StartingX
		bytes 1, StartingY
		bytes 1, StartingLocale

		words 1, WallMapAddr
		words 1, EventMapAddr
	end_struct

	;struct Room
	;	bytes WALL_ROOM_SIZE, WallData
	;end_struct

	; it might be better to make room definition a macro that a struct
	; like ... ROOM 0,1,0,2,1 for N,E,S,W,F
	; this is going to be very hard to interpret at a glance regardless

	; why am i looking into this at all? because the current map entry format (using TILE_MAP_ constants) won't scale easily to having multiple wall types.
	; this won't either though, entry will be a big pain in the butt regardless
	; hmm ...
	; example macros

	;MACRO assert_valid_rgb
	;	rept _NARG
	;		assert 0 <= (\1) && (\1) <= 31, "RGB channel must be 0-31"
	;		shift
	;	endr
	;ENDM

	;MACRO RGB
	;	rept _NARG / 3
	;		assert_valid_rgb \1, \2, \3
	;		dw palred (\1) + palgreen (\2) + palblue (\3)
	;		shift 3
	;	endr
	;ENDM
