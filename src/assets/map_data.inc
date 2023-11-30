INCLUDE "src/constants/map_constants.inc"

SECTION "Map Data", ROMX

; the current map struct has two bits per wall. this means a wall can be open or one of 3 types
; 4 bits per wall would give 15 wall types. that sounds reasonable for now? there could be different wall sets per level
; i also think it makes sense for now to have table to govern both room graphics and collision

; this is essentially a collision map that we're building through indices in vram for the pausemap tiles.
; todo it should be its own thing
; this can be printed to screen by making it writing it to tilemap vram, but only the top 18 rows, 20 columns
Map1:: ; 32 x 32
	; todo add starting orientation
	; todo add starting coords
	; todo add map width, height maybe?
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_TBL,  ROOM_TYPE_TILE_TB,   ROOM_TYPE_TILE_T,  ROOM_TYPE_TILE_TRB,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_NONE, ROOM_TYPE_TILE_NONE, ROOM_TYPE_TILE_RL, ROOM_TYPE_TILE_NONE, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_TRL,  ROOM_TYPE_TILE_NONE, ROOM_TYPE_TILE_L,  ROOM_TYPE_TILE_TR,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_L,    ROOM_TYPE_TILE_TB,   ROOM_TYPE_TILE_B,  ROOM_TYPE_TILE_RB,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,ROOM_TYPE_TILE_BL,ROOM_TYPE_TILE_TR,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,ROOM_TYPE_TILE_RBL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Map1End::

; unused
TilemapAttributeEntry:
	db `00000000 ; palette 0
TilemapAttributeEntryEnd:

OWTiles::
INCBIN "build/gfx/ow-simple.2bpp"
OWTilesEnd::

; maps tiles data to wall presence data. supports 3 wall types
; these require the same ordering as the map room tiles in ow-simple for the pausemap to work (is that true?)
; 00 00 00 00 = wall definition, in n e s w order.
; 00 = open, 01 = wallA, 10 = wallB, 11 = wallC
; todo rename to room definition? wall sets?
; todo make a macro to define rooms with wall types
RoomWallAttributes::
	db %00000000 ; 0,  ROOM_NONE
	db %00000001 ; 1,  ROOM_L
	db %00000100 ; 2,  ROOM_B
	db %00000101 ; 3,  ROOM_BL
	db %00010001 ; 4,  ROOM_RL
	db %00010100 ; 5,  ROOM_RB
	db %00010101 ; 6,  ROOM_RBL
	db %01000000 ; 7,  ROOM_T
	db %01000100 ; 8,  ROOM_TB
	db %01000101 ; 9,  ROOM_TBL
	db %01010000 ; 10, ROOM_TR
	db %01010001 ; 11, ROOM_TRL
	db %01010100 ; 12, ROOM_TRB
RoomWallAttributesEnd:

