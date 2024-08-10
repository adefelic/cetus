INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/location_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/structs/event.inc"
INCLUDE "src/structs/map.inc"

DEF MAP1_ROOM_HEIGHT EQU 32 ; not yet used
DEF MAP1_ROOM_WIDTH  EQU 32 ; not yet used
DEF MAP1_STARTING_ORIENTATION EQU ORIENTATION_EAST
DEF MAP1_STARTING_X EQU 1
DEF MAP1_STARTING_Y EQU 29
DEF MAP1_STARTING_LOCATION EQU LOCATION_FIELD

SECTION "Map1 Data", ROMX
	dstruct Map, Map1, MAP1_ROOM_HEIGHT, MAP1_ROOM_WIDTH, MAP1_STARTING_ORIENTATION, MAP1_STARTING_X, MAP1_STARTING_Y, MAP1_STARTING_LOCATION, WallMap, EventMap

; this is a collision map + a wall graphics map
WallMap: ; 32 x 32
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,ROOM_TRL,0,ROOM_TRL,0,ROOM_TRL,0,0,0,0,0,0,0,0,0,0,0,0,0,ROOM_TL,ROOM_T,ROOM_TR,0,0,ROOM_TL,ROOM_TB,ROOM_TR,0,0,0
	db 0,0,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0,0,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_TR,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,ROOM_TRBL,ROOM_L,ROOM_TB,ROOM_TB,ROOM_R,ROOM_NONE,ROOM_L,0,0,0
	db 0,ROOM_TL,ROOM_TB,ROOM_B,ROOM_TB,ROOM_B,ROOM_TB,ROOM_RB,0,0,0,0,0,ROOM_L,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,0,0,0,ROOM_L,ROOM_TB,ROOM_R,0,0,ROOM_BL,ROOM_TB,ROOM_RB,0,0,0
	db 0,ROOM_RL,0,0,0,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_BL,ROOM_TB,ROOM_TR,0,0,0,0,0,0
	db 0,ROOM_RL,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,ROOM_RL,0,0,0,ROOM_BL,ROOM_TB,ROOM_TB,ROOM_TR,0,0,0
	db 0,ROOM_BL,ROOM_TR,0,ROOM_TL,ROOM_TB,ROOM_RB,0,0,0,ROOM_TBL,ROOM_TR,0,0,ROOM_RL,0,0,0,0,0,0,ROOM_RL,0,ROOM_TRL,0,0,0,0,ROOM_RL,0,0,0
	db 0,0,ROOM_L,ROOM_TB,ROOM_RB,0,0,0,0,0,0,ROOM_RL,0,0,ROOM_RL,0,ROOM_TL,ROOM_TR,0,0,0,ROOM_L,ROOM_TB,ROOM_R,0,0,0,0,ROOM_RL,0,0,0
	db 0,0,ROOM_RL,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,0,0,ROOM_L,ROOM_TB,ROOM_B,ROOM_RB,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,0,ROOM_RL,0,0,0
	db 0,0,ROOM_L,ROOM_TB,ROOM_T,ROOM_TB,ROOM_RB,0,0,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,0,0,ROOM_TL,ROOM_RB,0,ROOM_RL,0,0,ROOM_TL,ROOM_TB,ROOM_B,ROOM_TB,ROOM_TR,0
	db 0,0,ROOM_RL,0,ROOM_RL,0,0,0,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_RB,0,0,ROOM_RL,0,0,0,0,0,ROOM_RL,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,ROOM_TL,ROOM_RB,0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_TBL,ROOM_B,ROOM_TB,ROOM_TRB,0,0,0,ROOM_RL,0,ROOM_TBL,ROOM_B,ROOM_TRB,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,ROOM_RL,0,0,ROOM_RL,0,ROOM_TL,ROOM_T,ROOM_TR,0,0,0,0,0,0,0,0,0,0,0,ROOM_RL,0,0,0,0,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,ROOM_RL,0,0,ROOM_RL,0,ROOM_BL,ROOM_NONE,ROOM_RB,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TR,0,0,0,0,0,ROOM_RL,0,ROOM_TBL,ROOM_T,ROOM_TRB,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,ROOM_BL,ROOM_TR,0,ROOM_RL,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,ROOM_BL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,0,ROOM_RL,0,ROOM_BL,ROOM_TRB,0,ROOM_RL,0,0,ROOM_RL,0,ROOM_TRL,0,0,0,0,0,0,0,ROOM_RL,0,0,ROOM_BL,ROOM_T,ROOM_TB,ROOM_NONE,ROOM_TB,ROOM_TR,0,ROOM_RL,0
	db 0,0,ROOM_RL,0,0,0,ROOM_TL,ROOM_RB,0,0,ROOM_L,ROOM_TB,ROOM_NONE,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TRB,0,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0
	db 0,0,ROOM_BL,ROOM_TR,0,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,0,0,0,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_L,ROOM_TB,ROOM_RB,0,ROOM_RL,0
	db 0,0,0,ROOM_L,ROOM_TB,ROOM_TB,ROOM_RB,0,ROOM_TRL,0,ROOM_RL,0,ROOM_RBL,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_T,ROOM_TB,ROOM_RB,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,0,0,ROOM_RL,0,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,ROOM_RL,0,0,0,ROOM_RL,0,0,0,0,0,ROOM_RL,0,ROOM_L,ROOM_TB,ROOM_TR,0,ROOM_RL,0
	db 0,0,0,ROOM_L,ROOM_TB,ROOM_TR,0,0,ROOM_RL,0,ROOM_RL,0,0,ROOM_TL,ROOM_RB,0,ROOM_TL,ROOM_TB,ROOM_RB,0,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0
	db 0,0,0,ROOM_RL,0,ROOM_RL,0,0,ROOM_RL,0,ROOM_RL,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,0,0,0,0,ROOM_RL,0,ROOM_BL,ROOM_TB,ROOM_RB,0,ROOM_RL,0
	db 0,ROOM_TL,ROOM_TB,ROOM_R,0,ROOM_BL,ROOM_TB,ROOM_TB,ROOM_RB,0,ROOM_RBL,0,ROOM_TL,ROOM_RB,0,ROOM_TL,ROOM_RB,0,0,0,0,0,0,0,ROOM_RL,0,0,0,0,0,ROOM_RL,0
	db 0,ROOM_RL,0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_RL,0,ROOM_TL,ROOM_TB,ROOM_T,ROOM_TB,ROOM_R,0
	db 0,ROOM_RL,0,ROOM_BL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_T,ROOM_TB,ROOM_B,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,0,0,ROOM_TL,ROOM_TR,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0
	db 0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_NONE,ROOM_R,0,ROOM_BL,ROOM_TB,ROOM_R,0,ROOM_RL,0,ROOM_RL,0
	db 0,ROOM_RBL,0,0,0,0,0,0,0,0,ROOM_RBL,0,0,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_RB,0,ROOM_BL,ROOM_RB,0,0,0,ROOM_L,ROOM_TB,ROOM_RB,0,ROOM_RL,0
	db 0,0,0,0,0,0,0,0,ROOM_TRL,0,ROOM_TRL,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,0,0,0,ROOM_TRL,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_B,ROOM_TB,ROOM_NONE,ROOM_TB,ROOM_RB,0,0,0,0,0,0,0,0,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,0,0,ROOM_RBL,0,0,0,0,0,0,0,0,0,0,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_B,ROOM_TB,ROOM_B,ROOM_TR,0,0,ROOM_RL,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,ROOM_RBL,0,0,ROOM_RBL,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; this table contains possible context events for the player on different squares
; each entry is an offset into the Map1Events table
EventMap:
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
Map1Events::
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

; todo associate music and npc tables with ... warps? or locations?
; warps
	dstruct WarpDestination, BackWarp_WarpDestination, 7, 12, ORIENTATION_SOUTH, SwampBgPaletteSet, LOCATION_SWAMP
	dstruct WarpDestination, SouthSwampFogWarpUp_WarpDestination, 10, 26, ORIENTATION_NORTH, SwampBgPaletteSet, LOCATION_SWAMP
	dstruct WarpDestination, SouthSwampFogWarpDown_WarpDestination, 10, 27, ORIENTATION_SOUTH, ForestBgPaletteSet, LOCATION_FIELD

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

;; 20x18 template
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
;
;; 32x32 template
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0

;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
;	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0
