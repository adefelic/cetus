INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/structs/event.inc"
INCLUDE "src/structs/map.inc"
INCLUDE "src/structs/locale.inc"

; csv:
;   https://docs.google.com/spreadsheets/d/13GqaktULwpdHMGMlaf0OvSwk79VNFjUJ6q3atw7Apqc/edit?usp=sharing

DEF MAP1_ROOM_HEIGHT EQU 32
DEF MAP1_ROOM_WIDTH  EQU 32
DEF MAP1_STARTING_ORIENTATION EQU ORIENTATION_EAST
DEF MAP1_STARTING_X EQU 1
DEF MAP1_STARTING_Y EQU 29

SECTION "Map1 Data", ROMX
	dstruct Map, Map1, MAP1_ROOM_HEIGHT, MAP1_ROOM_WIDTH, MAP1_STARTING_ORIENTATION, MAP1_STARTING_X, MAP1_STARTING_Y, FieldLocale, WallMap, EventMap

; this is a collision map + a wall graphics map
WallMap: ; 32 x 32
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	db 0,0,0,ROOM_TRL,0,ROOM_TRL,0,ROOM_TRL,0,0,0,0,0,0,0,0,0,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TR,0,0,ROOM_TL,ROOM_T,ROOM_TR,0,ROOM_TRL,0
	db 0,0,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0,0,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_TR,0,0,0,ROOM_TL,ROOM_TR2B,ROOM_TBL2,ROOM_TB,ROOM_R,ROOM_TRBL,ROOM_L,ROOM_TB,ROOM_TB,ROOM_NONE,ROOM_NONE,ROOM_R,0,ROOM_RL,0
	db 0,ROOM_TL,ROOM_TB,ROOM_B,ROOM_TB,ROOM_B,ROOM_TB,ROOM_RB,0,0,0,0,0,ROOM_L,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,0,0,0,ROOM_L,ROOM_TB,ROOM_R,0,0,ROOM_BL,ROOM_B,ROOM_RB,0,ROOM_RL,0
	db 0,ROOM_RL,0,0,0,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_BL,ROOM_TB,ROOM_TR,0,0,0,0,ROOM_RL,0
	db 0,ROOM_RL,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,ROOM_RL,0,0,0,ROOM_BL,ROOM_TB,ROOM_TB,ROOM_TR,0,ROOM_RL,0
	db 0,ROOM_BL,ROOM_TR,0,ROOM_TL,ROOM_TB,ROOM_RB,0,0,0,ROOM_TBL,ROOM_TR,0,0,ROOM_RL,0,0,0,0,0,0,ROOM_RL,0,ROOM_TRL,0,0,0,0,ROOM_RL,0,ROOM_RL,0
	db 0,0,ROOM_L,ROOM_TB,ROOM_RB,0,0,0,0,0,0,ROOM_RL,0,0,ROOM_RL,0,ROOM_TL,ROOM_TR,0,0,0,ROOM_L,ROOM_TB,ROOM_R,0,0,0,0,ROOM_RL,0,ROOM_RL,0
	db 0,0,ROOM_RL,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,0,0,ROOM_L,ROOM_TB,ROOM_B,ROOM_RB,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,0,ROOM_RL,0,ROOM_RL,0
	db 0,0,ROOM_L,ROOM_TB,ROOM_T,ROOM_TB,ROOM_RB,0,0,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,0,0,ROOM_TR2L,ROOM_RBL2,0,ROOM_RL,0,0,ROOM_TR2L,ROOM_TBL2,ROOM_R2B,ROOM_TBL2,ROOM_R,0
	db 0,0,ROOM_RL,0,ROOM_RL,0,0,0,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_RB,0,0,ROOM_RL,0,0,0,0,0,ROOM_RL,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,ROOM_TL,ROOM_RB,0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_TBL,ROOM_B,ROOM_TB,ROOM_TRB,0,0,0,ROOM_RL,0,ROOM_TBL,ROOM_B,ROOM_TRB,0,ROOM_RL,ROOM_TB,ROOM_TR,0,ROOM_RL,0
	db 0,ROOM_RL,0,0,ROOM_RL,0,ROOM_TL,ROOM_T,ROOM_TR,0,0,0,0,0,0,0,0,0,0,0,ROOM_RL,0,0,0,0,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0
	db 0,ROOM_RL,0,0,ROOM_RL,0,ROOM_BL,ROOM_NONE,ROOM_RB,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TR,0,0,0,0,0,ROOM_RL,0,ROOM_TBL,ROOM_T,ROOM_TRB,0,ROOM_RL,ROOM_TB,ROOM_RB,0,ROOM_RL,0
	db 0,ROOM_BL,ROOM_TR,0,ROOM_RL,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,ROOM_BL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,0,ROOM_RL,0,ROOM_BL,ROOM_TRB,0,ROOM_RL,0,0,ROOM_RL,0,ROOM_TRL,0,0,0,0,0,0,0,ROOM_RL,0,0,ROOM_BL,ROOM_T,ROOM_TB,ROOM_NONE,ROOM_TB,ROOM_TR,0,ROOM_RL,0
	db 0,0,ROOM_RL,0,0,0,ROOM_TL,ROOM_RB,0,0,ROOM_L,ROOM_TB,ROOM_NONE,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TRB,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0
	db 0,0,ROOM_BL,ROOM_TR,0,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,0,0,0,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_L,ROOM_TB,ROOM_RB,0,ROOM_RL,0
	db 0,0,0,ROOM_L,ROOM_TB,ROOM_TB,ROOM_RB,0,ROOM_TRL,0,ROOM_RL,0,ROOM_RBL,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_T,ROOM_TB,ROOM_RB,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,0,0,ROOM_RL,0,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,ROOM_RL,0,0,0,ROOM_RL,0,0,0,0,0,ROOM_RL,0,ROOM_L,ROOM_TB,ROOM_TR,0,ROOM_RL,0
	db 0,0,0,ROOM_L,ROOM_TB,ROOM_TR,0,0,ROOM_RL,0,ROOM_RL,0,0,ROOM_TL,ROOM_RB,0,ROOM_TL,ROOM_TB,ROOM_RB,0,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_R,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0
	db 0,0,0,ROOM_RL,0,ROOM_RL,0,0,ROOM_RL,0,ROOM_RL,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,0,0,0,0,ROOM_RL,0,ROOM_BL,ROOM_TB,ROOM_RB,0,ROOM_RL,0
	db 0,ROOM_TL,ROOM_TB,ROOM_R,0,ROOM_BL,ROOM_TB,ROOM_TB,ROOM_RB,0,ROOM_RBL,0,ROOM_TL,ROOM_RB,0,ROOM_TL,ROOM_RB,0,0,0,0,0,0,0,ROOM_RL,0,0,0,0,0,ROOM_RL,0
	db 0,ROOM_RL,0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_RL,0,0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_RL,0,ROOM_TL,ROOM_TB,ROOM_TR2,ROOM_TBL2,ROOM_R,0
	db 0,ROOM_RL,0,ROOM_BL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_T,ROOM_TR2B,ROOM_BL2,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,0,0,ROOM_TL,ROOM_TR,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0,ROOM_RL,0
	db 0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_RL,0,0,0,0,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_NONE,ROOM_R,0,ROOM_BL,ROOM_TB,ROOM_R,0,ROOM_RL,0,ROOM_RL,0
	db 0,ROOM_RBL,0,0,0,0,0,0,0,0,ROOM_RB2L,0,0,0,0,0,0,ROOM_TL,ROOM_TB,ROOM_RB,0,ROOM_BL,ROOM_RB,0,0,0,ROOM_L,ROOM_TB,ROOM_RB,0,ROOM_RL,0
	db 0,0,0,0,0,0,0,0,ROOM_TRL,0,ROOM_T2RL,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_RB,ROOM_TBL,ROOM_TB,ROOM_TR,0,0,0,ROOM_TRL,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,0,0,0,ROOM_TL,ROOM_TB,ROOM_TB,ROOM_TB,ROOM_B,ROOM_TB,ROOM_NONE,ROOM_TB,ROOM_RB,0,0,0,0,0,0,0,ROOM_RL,0,0,0,ROOM_RL,0,ROOM_RL,0,0,0,ROOM_RL,0
	db 0,ROOM_TBL2,ROOM_TB,ROOM_TB,ROOM_RB,0,0,0,0,0,ROOM_RBL,0,0,0,0,0,0,0,0,ROOM_TBL,ROOM_NONE,ROOM_TBL,ROOM_TB,ROOM_TB,ROOM_B,ROOM_TB,ROOM_B,ROOM_TR,0,0,ROOM_RL,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,ROOM_RBL,0,0,0,0,0,0,ROOM_RBL,0,0,ROOM_RBL,0
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

; now that each of these is a word, would it make more sense for a combined map room object? no it would take the same amount of space
EventMap:
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,SwampTownWarpEast,SwampTownWarpWest,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,TownRuinWarpEast,TownRuinWarpWest,0,0,0,0,TownForestWarpEast,TownForestWarpWest,TownCoastWarpEast,TownCoastWarpWest,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,CoastForestWarpEast,CoastForestWarpWest,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,SwampRuinWarpEast,SwampRuinWarpWest,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,FieldSwampWarpSouth,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,TownHall,0,FieldSwampWarpNorth,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,BackWarp,TownHall,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

DEF CROSS_FOG_STRING EQUS "\"cross fog?\""
; dang these are offsets and not indices. they need to be indices so i can support more of them at once
Map1Events::
	nop ; this is a hack to make it so having an offset of 0 means there is no event
	dstruct RoomEvent, TownHall,            WALLS_T, "  Enter?  ", "Ask about", ROOMEVENT_DIALOG, 3, TownHall_DialogBranches
	dstruct RoomEvent, FieldSwampWarpNorth, WALLS_T, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, FieldSwampWarpNorth_WarpDestination
	dstruct RoomEvent, FieldSwampWarpSouth, WALLS_B, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, FieldSwampWarpSouth_WarpDestination
	dstruct RoomEvent, BackWarp,            WALLS_L, "debug hole",     "", ROOMEVENT_WARP, 0, BackWarp_WarpDestination
	dstruct RoomEvent, SwampTownWarpEast,   WALLS_R, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, SwampTownWarpEast_WarpDestination
	dstruct RoomEvent, SwampTownWarpWest,   WALLS_L, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, SwampTownWarpWest_WarpDestination
	dstruct RoomEvent, TownCoastWarpEast,   WALLS_R, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, TownCoastWarpEast_WarpDestination
	dstruct RoomEvent, TownCoastWarpWest,   WALLS_L, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, TownCoastWarpWest_WarpDestination
	dstruct RoomEvent, TownForestWarpEast,  WALLS_R, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, TownForestWarpEast_WarpDestination
	dstruct RoomEvent, TownForestWarpWest,  WALLS_L, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, TownForestWarpWest_WarpDestination
	dstruct RoomEvent, CoastForestWarpEast, WALLS_R, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, CoastForestWarpEast_WarpDestination
	dstruct RoomEvent, CoastForestWarpWest, WALLS_L, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, CoastForestWarpWest_WarpDestination
	dstruct RoomEvent, TownRuinWarpEast,    WALLS_R, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, TownRuinWarpEast_WarpDestination
	dstruct RoomEvent, TownRuinWarpWest,    WALLS_L, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, TownRuinWarpWest_WarpDestination
	dstruct RoomEvent, SwampRuinWarpEast,   WALLS_R, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, SwampRuinWarpEast_WarpDestination
	dstruct RoomEvent, SwampRuinWarpWest,   WALLS_L, CROSS_FOG_STRING, "", ROOMEVENT_WARP, 0, SwampRuinWarpWest_WarpDestination

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
	dstruct WarpDestination, BackWarp_WarpDestination, 21, 8, ORIENTATION_SOUTH, SwampLocale
	dstruct WarpDestination, FieldSwampWarpNorth_WarpDestination, 10, 26, ORIENTATION_NORTH, SwampLocale
	dstruct WarpDestination, FieldSwampWarpSouth_WarpDestination, 10, 27, ORIENTATION_SOUTH, FieldLocale
	dstruct WarpDestination, SwampTownWarpEast_WarpDestination, 19, 2, ORIENTATION_EAST, TownLocale
	dstruct WarpDestination, SwampTownWarpWest_WarpDestination, 18, 2, ORIENTATION_WEST, SwampLocale
	dstruct WarpDestination, TownCoastWarpEast_WarpDestination, 29, 9, ORIENTATION_EAST, CoastLocale
	dstruct WarpDestination, TownCoastWarpWest_WarpDestination, 28, 9, ORIENTATION_WEST, TownLocale
	dstruct WarpDestination, TownForestWarpEast_WarpDestination, 27, 9, ORIENTATION_EAST, TownLocale
	dstruct WarpDestination, TownForestWarpWest_WarpDestination, 26, 9, ORIENTATION_WEST, ForestLocale
	dstruct WarpDestination, CoastForestWarpEast_WarpDestination, 29, 23, ORIENTATION_EAST, CoastLocale
	dstruct WarpDestination, CoastForestWarpWest_WarpDestination, 28, 23, ORIENTATION_WEST, ForestLocale
	dstruct WarpDestination, TownRuinWarpEast_WarpDestination, 21, 9, ORIENTATION_EAST, TownLocale
	dstruct WarpDestination, TownRuinWarpWest_WarpDestination, 20, 9, ORIENTATION_WEST, RuinLocale
	dstruct WarpDestination, SwampRuinWarpEast_WarpDestination, 12, 24, ORIENTATION_EAST, RuinLocale
	dstruct WarpDestination, SwampRuinWarpWest_WarpDestination, 11, 24, ORIENTATION_WEST, SwampLocale

;SECTION "Locale definitions", ROMX
; this is here to force Locales to be defined in the same bank as Map1 :(
Locales:
	dstruct Locale, FieldLocale,  FieldWallBTiles, bank(FieldWallBTiles), xMusicTown, FieldBgPaletteSet,  FieldNpcs
	dstruct Locale, SwampLocale,  FieldWallBTiles, bank(FieldWallBTiles), xMusicRuin, SwampBgPaletteSet,  SwampNpcs
	dstruct Locale, TownLocale,   FieldWallBTiles, bank(FieldWallBTiles), xMusicTown, TownBgPaletteSet,   SwampNpcs
	dstruct Locale, CoastLocale,  FieldWallBTiles, bank(FieldWallBTiles), xMusicRuin, CoastBgPaletteSet,  SwampNpcs
	dstruct Locale, ForestLocale, FieldWallBTiles, bank(FieldWallBTiles), xMusicRuin, ForestBgPaletteSet, SwampNpcs
	dstruct Locale, RuinLocale,   FieldWallBTiles, bank(FieldWallBTiles), xMusicRuin, RuinBgPaletteSet,   SwampNpcs

; tile ids for a hard-coded encounter screen
; todo move this somewhere else. todo just get rid of this if the encounter background is tile 0
BlackBackground::
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
BlackBackgroundEnd::
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
