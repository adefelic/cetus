INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/macros/event.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/assets/tiles/indices/computer_dark.inc"

SECTION "Map Data", ROMX

; the current map struct has two bits per wall. this means a wall can be open or one of 3 types
; 4 bits per wall would give 15 wall types. that sounds reasonable for now? there could be different wall sets per level
; i also think it makes sense for now to have table to govern both room graphics and collision

Maps::
DEF MAP1 EQU $00 ; map id
; todo this will require a GetMap addr function

Map1::
Map1Header::
; todo add starting orientation
; todo add starting coords
; todo add map width, height maybe?

; the "wall map"
; this is essentially a collision map that we're building through indices in vram for the pausemap tiles.
; todo it should be its own thing
; this can be printed to screen by making it writing it to tilemap vram, but only the top 18 rows, 20 columns
Map1Walls:: ; 32 x 32
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,TILE_PAUSEMAP_TBL,  TILE_PAUSEMAP_TB,   TILE_PAUSEMAP_T,  TILE_PAUSEMAP_TRB,  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,TILE_PAUSEMAP_NONE, TILE_PAUSEMAP_NONE, TILE_PAUSEMAP_RL, TILE_PAUSEMAP_NONE, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,TILE_PAUSEMAP_TRL,  TILE_PAUSEMAP_NONE, TILE_PAUSEMAP_L,  TILE_PAUSEMAP_TR,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,TILE_PAUSEMAP_L,    TILE_PAUSEMAP_TB,   TILE_PAUSEMAP_B,  TILE_PAUSEMAP_RB,   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,TILE_PAUSEMAP_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,TILE_PAUSEMAP_RL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,TILE_PAUSEMAP_BL,TILE_PAUSEMAP_TR,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,TILE_PAUSEMAP_RBL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,TILE_PAUSEMAP_TRL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,TILE_PAUSEMAP_RBL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
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
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Map1WallsEnd::

; the "event map"
; This table contains possible context events for the player on different squares
; each entry is an offset into the Map1EventTriggers Table
Map1EventLocations:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,EventTriggerGoIntoBuilding-Map1EventTriggers,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,EventTriggerGoBackToOW-Map1EventTriggers,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
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
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

Map1EventTriggers:
	nop ; this is a hack to make it so having an offset of 0 means there is no event

EventTriggerGoIntoBuilding:
	event_trigger WALLS_B, EVENT_TYPE_WARP, EventDefGoIntoBuilding ; it's probably more efficient to have a table offset than a ptr?
EventDefGoIntoBuilding:
	event_def_type_warp 1, EventFramesGoIntoBuilding, MAP1, 2, 9, ORIENTATION_SOUTH
EventFramesGoIntoBuilding:
	event_frame_simple "  Enter?  "

EventTriggerGoBackToOW:
	event_trigger WALLS_T, EVENT_TYPE_WARP, EventDefGoBackToOW
EventDefGoBackToOW:
	event_def_type_warp 1, EventFramesGoBackToOW, MAP1, 2, 8, ORIENTATION_NORTH
EventFramesGoBackToOW:
	event_frame_simple "  Leave?  "

Map1Encounters:


; todo
; there should be an object for wall _presence_ (collision)
; and there should be an object for wall _style_

; maps tiles data to wall presence data. supports 3 wall types
; these require the same ordering as the map room tiles in explore-simple for the pausemap to work (is that true?)
; 00 00 00 00 = wall definition, in n e s w order.
; 00 = open, 01 = wallA, 10 = wallB, 11 = wallC
; todo rename to room definition? wall sets?
; todo make a macro to define rooms with wall types
RoomWallAttributes::
	db %00000000 ; 0,  ROOM_NONE
	db %00000001 ; 1,  ROOM_L
	db %00000100 ; 2,  ROOM_B
	db %00000101 ; 3,  ROOM_BL
	db %00010000 ; 4,  ROOM_R
	db %00010001 ; 5,  ROOM_RL
	db %00010100 ; 6,  ROOM_RB
	db %00010101 ; 7,  ROOM_RBL
	db %01000000 ; 8,  ROOM_T
	db %01000001 ; 9,  ROOM_TL
	db %01000100 ; 10, ROOM_TB
	db %01000101 ; 11, ROOM_TBL
	db %01010000 ; 12, ROOM_TR
	db %01010001 ; 13, ROOM_TRL
	db %01010100 ; 14, ROOM_TRB
	db %01010100 ; 15, ROOM_TRBL
RoomWallAttributesEnd:

; tile ids for a hard-coded encounter screen
Map1EncounterScreen::
;; 20x18
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

	; 32x32
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_POINT,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_POINT,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_SHAFT,TILE_ENCOUNTER_ARROW_POINT,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,TILE_ENCOUNTER_GRASS,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,TILE_ENCOUNTER_RAMP_LOW,TILE_ENCOUNTER_RAMP_HIGH,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_FLAT, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,TILE_ENCOUNTER_GRASS,0,TILE_ENCOUNTER_RAMP_LOW,TILE_ENCOUNTER_RAMP_HIGH,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,TILE_ENCOUNTER_RAMP_HIGH,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,TILE_ENCOUNTER_RAMP_LOW,TILE_ENCOUNTER_RAMP_HIGH,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_FLAT,0,TILE_ENCOUNTER_GRASS,0,TILE_ENCOUNTER_RAMP_LOW,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS, 0,0,0,0,0,0,0,0,0,0,0,0
	db TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_FLAT,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS, 0,0,0,0,0,0,0,0,0,0,0,0
	db TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS, 0,0,0,0,0,0,0,0,0,0,0,0
	db TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS,TILE_ENCOUNTER_GRASS, 0,0,0,0,0,0,0,0,0,0,0,0

	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
Map1EncounterScreenEnd::
