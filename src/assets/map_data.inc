INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/structs/event.inc"

SECTION "Map Data", ROMX

; big time todo: copy only 18x20 tiles instead of the whole section. compare how long these take

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
; each tilemap entry offset is correlated to an entry in RoomWallAttributes
; this can be printed to screen by making it writing it to tilemap vram, but only the top 18 rows, 20 columns
Map1Tiles:: ; 32 x 32
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,TILE_MAP_TRL,0,TILE_MAP_TRL,0,TILE_MAP_TRL,0,0,0,0,0,0,0,0,0,0,0,0,0,TILE_MAP_TL,TILE_MAP_T,TILE_MAP_TR,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TR,0,0,0
	db 0,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,TILE_MAP_TBL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TR,0,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_R,TILE_MAP_TRBL,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_R,TILE_MAP_NONE,TILE_MAP_L,0,0,0
	db 0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_B,TILE_MAP_TB,TILE_MAP_B,TILE_MAP_TB,TILE_MAP_RB,0,0,0,0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_R,0,0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_R,0,0,TILE_MAP_BL,TILE_MAP_TB,TILE_MAP_RB,0,0,0
	db 0,TILE_MAP_RL,0,0,0,0,0,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0,TILE_MAP_BL,TILE_MAP_TB,TILE_MAP_TR,0,0,0,0,0,0
	db 0,TILE_MAP_RL,0,0,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,0,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_BL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TR,0,0,0
	db 0,TILE_MAP_BL,TILE_MAP_TR,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_RB,0,0,0,TILE_MAP_TBL,TILE_MAP_TR,0,0,TILE_MAP_RL,0,0,0,0,0,0,TILE_MAP_RL,0,TILE_MAP_TRL,0,0,0,0,TILE_MAP_RL,0,0,0
	db 0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_RB,0,0,0,0,0,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,TILE_MAP_TL,TILE_MAP_TR,0,0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_R,0,0,0,0,TILE_MAP_RL,0,0,0
	db 0,0,TILE_MAP_RL,0,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_R,0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_B,TILE_MAP_RB,0,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,0,0,TILE_MAP_RL,0,0,0
	db 0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_T,TILE_MAP_TB,TILE_MAP_RB,0,0,0,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,0,0,0,TILE_MAP_TL,TILE_MAP_RB,0,TILE_MAP_RL,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_B,TILE_MAP_TB,TILE_MAP_TR,0
	db 0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,0,TILE_MAP_TBL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,0,TILE_MAP_RL,0,0,0,0,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0
	db 0,TILE_MAP_TL,TILE_MAP_RB,0,TILE_MAP_RL,0,0,0,0,0,0,0,0,TILE_MAP_TBL,TILE_MAP_B,TILE_MAP_TB,TILE_MAP_TRB,0,0,0,TILE_MAP_RL,0,TILE_MAP_TBL,TILE_MAP_B,TILE_MAP_TRB,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0
	db 0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,TILE_MAP_TL,TILE_MAP_T,TILE_MAP_TR,0,0,0,0,0,0,0,0,0,0,0,TILE_MAP_RL,0,0,0,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0
	db 0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,TILE_MAP_BL,TILE_MAP_NONE,TILE_MAP_RB,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TR,0,0,0,0,0,TILE_MAP_RL,0,TILE_MAP_TBL,TILE_MAP_T,TILE_MAP_TRB,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0
	db 0,TILE_MAP_BL,TILE_MAP_TR,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_BL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_R,0,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0
	db 0,0,TILE_MAP_RL,0,TILE_MAP_BL,TILE_MAP_TRB,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,TILE_MAP_TRL,0,0,0,0,0,0,0,TILE_MAP_RL,0,0,TILE_MAP_BL,TILE_MAP_T,TILE_MAP_TB,TILE_MAP_NONE,TILE_MAP_TB,TILE_MAP_TR,0,TILE_MAP_RL,0
	db 0,0,TILE_MAP_RL,0,0,0,TILE_MAP_TL,TILE_MAP_RB,0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_NONE,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TRB,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,TILE_MAP_RL,0,TILE_MAP_RL,0
	db 0,0,TILE_MAP_BL,TILE_MAP_TR,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,0,0,0,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_RB,0,TILE_MAP_RL,0
	db 0,0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,TILE_MAP_TRL,0,TILE_MAP_RL,0,TILE_MAP_RBL,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_T,TILE_MAP_TB,TILE_MAP_RB,0,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0
	db 0,0,0,TILE_MAP_RL,0,0,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0,0,0,0,0,TILE_MAP_RL,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_TR,0,TILE_MAP_RL,0
	db 0,0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_TR,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,TILE_MAP_TL,TILE_MAP_RB,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_RB,0,TILE_MAP_TBL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_R,0,TILE_MAP_RL,0,TILE_MAP_RL,0,TILE_MAP_RL,0
	db 0,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,0,0,0,0,0,TILE_MAP_RL,0,TILE_MAP_BL,TILE_MAP_TB,TILE_MAP_RB,0,TILE_MAP_RL,0
	db 0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_R,0,TILE_MAP_BL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,TILE_MAP_RBL,0,TILE_MAP_TL,TILE_MAP_RB,0,TILE_MAP_TL,TILE_MAP_RB,0,0,0,0,0,0,0,TILE_MAP_RL,0,0,0,0,0,TILE_MAP_RL,0
	db 0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,0,0,0,0,0,0,TILE_MAP_RL,0,0,TILE_MAP_RL,0,0,0,0,0,0,0,0,TILE_MAP_RL,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_T,TILE_MAP_TB,TILE_MAP_R,0
	db 0,TILE_MAP_RL,0,TILE_MAP_BL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_T,TILE_MAP_TB,TILE_MAP_B,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,0,0,0,0,TILE_MAP_TL,TILE_MAP_TR,0,TILE_MAP_RL,0,TILE_MAP_RL,0,TILE_MAP_RL,0,TILE_MAP_RL,0
	db 0,TILE_MAP_RL,0,0,0,0,0,0,0,0,TILE_MAP_RL,0,0,0,0,0,0,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_NONE,TILE_MAP_R,0,TILE_MAP_BL,TILE_MAP_TB,TILE_MAP_R,0,TILE_MAP_RL,0,TILE_MAP_RL,0
	db 0,TILE_MAP_RBL,0,0,0,0,0,0,0,0,TILE_MAP_RBL,0,0,0,0,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_RB,0,TILE_MAP_BL,TILE_MAP_RB,0,0,0,TILE_MAP_L,TILE_MAP_TB,TILE_MAP_RB,0,TILE_MAP_RL,0
	db 0,0,0,0,0,0,0,0,TILE_MAP_TRL,0,TILE_MAP_TRL,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,0,0,0,0,0,TILE_MAP_TRL,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0
	db 0,0,0,0,TILE_MAP_TL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_B,TILE_MAP_TB,TILE_MAP_NONE,TILE_MAP_TB,TILE_MAP_RB,0,0,0,0,0,0,0,0,0,0,0,TILE_MAP_RL,0,TILE_MAP_RL,0,0,0,TILE_MAP_RL,0
	db 0,TILE_MAP_TBL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_RB,0,0,0,0,0,TILE_MAP_RBL,0,0,0,0,0,0,0,0,0,0,TILE_MAP_TBL,TILE_MAP_TB,TILE_MAP_TB,TILE_MAP_B,TILE_MAP_TB,TILE_MAP_B,TILE_MAP_TR,0,0,TILE_MAP_RL,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,TILE_MAP_RBL,0,0,TILE_MAP_RBL,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
Map1TilesEnd::

; the "event map"
; This table contains possible context events for the player on different squares
; each entry is an offset into the Map1Events table
Map1EventLocations::
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	; delete two blank lines when uncommenting the two lines below
	;db 0,0,EventTriggerGoIntoBuilding-Map1EventTriggers,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,EventTriggerGoBackToOW-Map1EventTriggers,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
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
	db 0,0,0,0,0,0,0,0,0,0,SouthSwampFogWarpDown-Map1Events,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,TownHall-Map1Events,0,SouthSwampFogWarpUp-Map1Events,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,BackWarp-Map1Events,TownHall-Map1Events,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; event triggers
Map1Events:
	nop ; this is a hack to make it so having an offset of 0 means there is no event
	dstruct RoomEvent, TownHall, WALLS_T, "  Enter?  ", "Ask about", ROOMEVENT_DIALOG, 3, TownHall_DialogBranches
	dstruct RoomEvent, SouthSwampFogWarpUp, WALLS_T, "cross fog?", "", ROOMEVENT_WARP, 0, SouthSwampFogWarpUp_WarpDestination
	dstruct RoomEvent, SouthSwampFogWarpDown, WALLS_B, "cross fog?", "", ROOMEVENT_WARP, 0, SouthSwampFogWarpDown_WarpDestination
	dstruct RoomEvent, BackWarp, WALLS_L, "swamp", "", ROOMEVENT_WARP, 0, BackWarp_WarpDestination ; debug warp

; dialog
TownHall_DialogBranches:
	dstruct DialogBranch, TownHall_SayHello, wAlwaysTrueEventFlag, "say hello", 5, TownHall_SayHello_DialogBranchFrames
	dstruct DialogBranch, TownHall_AskAboutFog, wAlwaysTrueEventFlag, "ask: fog", 1, TownHall_AskAboutFog_DialogBranchFrames
	dstruct DialogBranch, TownHall_AskAboutSkull, wFoundSkullFlag, "ask: skull", 1, TownHall_AskAboutSkull_DialogBranchFrames
TownHall_SayHello_DialogBranchFrames:
	dstruct DialogBranchFrame, TownHall_SayHello_Frame0, .SpriteAddr=0, .FlagSetOnCompletion=0, .ItemGetOnCompletion=0, .TextLine0="well,", .TextLine1="hello back to", .TextLine2="you stranger", .TextLine3="... say,"
	dstruct DialogBranchFrame, TownHall_SayHello_Frame1, .SpriteAddr=0, .FlagSetOnCompletion=0, .ItemGetOnCompletion=0, .TextLine0="not from round", .TextLine1="here, are you?", .TextLine2="", .TextLine3=""
	dstruct DialogBranchFrame, TownHall_SayHello_Frame2, .SpriteAddr=0, .FlagSetOnCompletion=0, .ItemGetOnCompletion=0, .TextLine0="well, if youre", .TextLine1="looking to get", .TextLine2="the lay of", .TextLine3="this place"
	dstruct DialogBranchFrame, TownHall_SayHello_Frame3, .SpriteAddr=0, .FlagSetOnCompletion=0, .ItemGetOnCompletion=0, .TextLine0="take this note", .TextLine1="up to the", .TextLine2="house, through", .TextLine3="the swamp,"
	dstruct DialogBranchFrame, TownHall_SayHello_Frame4, .SpriteAddr=0, .FlagSetOnCompletion=0, .ItemGetOnCompletion=0, .TextLine0="to the north-", .TextLine1="east.", .TextLine2="", .TextLine3=""
TownHall_AskAboutFog_DialogBranchFrames:
	dstruct DialogBranchFrame, TownHall_AskAboutFog_Frame0, .SpriteAddr=0, .FlagSetOnCompletion=0, .ItemGetOnCompletion=0, .TextLine0="real misty", .TextLine1="out there", .TextLine2="isnt it...", .TextLine3="cold too"
TownHall_AskAboutSkull_DialogBranchFrames:
	dstruct DialogBranchFrame, TownHall_AskAboutSkull_Frame0, .SpriteAddr=0, .FlagSetOnCompletion=0, .ItemGetOnCompletion=0, .TextLine0="i'm not sure", .TextLine1="what you're", .TextLine2="speaking of...", .TextLine3="*cough*"

; warps
	dstruct WarpDestination, BackWarp_WarpDestination, 7, 12, ORIENTATION_SOUTH, SwampBgPaletteSet
	dstruct WarpDestination, SouthSwampFogWarpUp_WarpDestination, 10, 26, ORIENTATION_NORTH, SwampBgPaletteSet
	dstruct WarpDestination, SouthSwampFogWarpDown_WarpDestination, 10, 27, ORIENTATION_SOUTH, ForestBgPaletteSet

; tile ids for a hard-coded encounter screen
Map1EncounterScreen::
	; 32x32
	; now 18x20
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
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
Map1EncounterScreenEnd::

	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0

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

	;; 32x32
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0

	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
	;db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
