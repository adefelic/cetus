INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/map_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/utils/hardware.inc"

SECTION "Explore Screen Renderer", ROMX

; first person perspective can render up to 6 tiles:
;
; [1][2][3]
; [4][5][6]
;
; player is in tile 5 facing tile 2.
;
; ceilings will not be rendered

; for attempt #1 this will write directly to vram
; future thoughts: could compare the 6-room submap that's being rendered for differences to the current submap and use that to set segment clean flags
; walls that matter:
;   - center near left
;       if same, set APK+diag to clean
;   - center near top
;       if same, set BCDL+diagMN+diag to clean
;   - center near right
;       if same, set EOR+diag to clean
;   - left near top
;       if same, set APK+diag to clean
;   - right near top
;   - center far left
;   - center far top
;   - center far right
;   - left far top
;   - right far top
; [T][TRL][T]
; [T][TRL][T]

; todo change map stuff to compass directions. trbl is player relative, nesw is absolute
; todo rename this to ... draw FP Tilemap?
; trbl are all relative to the player's orientation
LoadExploreScreen::
.updateShadowBgTilemap
	; render walls
	call RenderFirstPersonView
	; maybe render event modal
	ld a, [wIsEventActive]
	cp FALSE
	jp z, .updateShadowOam
	; overlay a text box reading from the active event pointers
	call PaintEventModal
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	cp SCREEN_EXPLORE
	jp z, .updateExploreSprites
.unloadUnusedSprites
	cp SCREEN_ENCOUNTER
	jp nz, .updateExploreSprites
	call UnloadEncounterSprites
;.initExploreSprites
	; init maybe not right word.
	; they should all be initialized (loaded into oam) when the game loads
	; this may be unnecessary if all the sprites are already in vram, just have to update coords
.updateExploreSprites
	; todo this is writing to the oam every frame.
	; it should write once and update when necessary
	call PaintDangerIndicator
	call PaintCompass
	ret

UnloadExploreSprites::
	ld a, OFFSCREEN_Y
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_Y], a
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_Y], a

	ld a, OFFSCREEN_X
	ld [wShadowOam + OAM_HUD_COMPASS_ARROW + OAMA_X], a
	ld [wShadowOam + OAM_HUD_COMPASS_CHAR + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_0 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_1 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_2 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_3 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_4 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_5 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_6 + OAMA_X], a
	ld [wShadowOam + OAM_HUD_DANGER_7 + OAMA_X], a
	ret

RenderFirstPersonView::
	; todo? move wCurrentVisibleRoomAttrs to wPreviousVisibleRoomAttrs
	; todo bounds check and skip rooms that are oob
	; currently this does no bounds checking for rooms with negative coords.
	;   the whole map starts at 1,1 rather than 0,0 to make it unnecessary
ProcessTileCenterNear: ; process rooms closest to farthest w/ dirtying to only draw topmost z segments
.checkLeftWall:
	call GetRoomCoordsCenterNearWRTPlayer ; todo, put coords in ram?
	call GetActiveMapRoomAddrFromCoords ; puts player tilemap entry addr in hl. should probably put this somewhere?
	call GetRoomWallAttributesAddrFromMapAddr ; put related RoomWallAttributes addr in hl
	call GetLeftWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .checkTopWall
.paintLeftWall
	; okay instead we can say ... load that wall's panel index
	ld e, INDEX_OW_PALETTE_Z0
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
	call CheckSegmentP
	ld d, TILE_ENVIRONMENT_DIAG_L
	call CheckSegmentPDiag
.checkTopWall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .checkRightWall
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z1
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentB
	call CheckSegmentC
	call CheckSegmentD
	call CheckSegmentL
	call CheckSegmentLDiag
	call CheckSegmentM
	call CheckSegmentN
	call CheckSegmentNDiag
.checkRightWall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetRightWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintRightWall
	ld e, INDEX_OW_PALETTE_Z0
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
	call CheckSegmentR
	ld d, TILE_ENVIRONMENT_DIAG_R
	call CheckSegmentRDiag
.paintGround
	ld e, INDEX_OW_PALETTE_Z0
	ld d, TILE_ENVIRONMENT_GROUND ; todo on all ground paints, flip (shuffle could be cool) ground every step
	call CheckSegmentQ

ProcessTileLeftNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsLeftNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z1
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
.paintGround
	ld e, INDEX_OW_PALETTE_Z0
	ld d, TILE_ENVIRONMENT_GROUND
	call CheckSegmentP
	call CheckSegmentPDiag

ProcessTileRightNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsRightNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z1
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
.paintGround
	ld e, INDEX_OW_PALETTE_Z0
	ld d, TILE_ENVIRONMENT_GROUND
	call CheckSegmentR
	call CheckSegmentRDiag

ProcessTileCenterFar:
.checkLeftWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetLeftWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintLeftGround ; paint ground if no left wall
.paintLeftWall
	ld e, INDEX_OW_PALETTE_Z2
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentB
	call CheckSegmentL
	ld d, TILE_ENVIRONMENT_DIAG_L
	call CheckSegmentLDiag
	jp .checkTopWall
.paintLeftGround
	ld e, INDEX_OW_PALETTE_Z2
	ld d, TILE_ENVIRONMENT_GROUND
	call CheckSegmentL
	call CheckSegmentLDiag
.checkTopWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	ld e, INDEX_OW_PALETTE_Z3
	call CheckSegmentC
	jp .checkRightWall
.paintDistance
	; todo: set to distance palette
	ld e, INDEX_OW_PALETTE_Z0
	ld d, TILE_ENVIRONMENT_DARK
	call CheckSegmentC
.checkRightWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetRightWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintRightGround ; paint ground if no right wall
.paintRightWall
	ld e, INDEX_OW_PALETTE_Z2
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentN
	ld d, TILE_ENVIRONMENT_DIAG_R
	call CheckSegmentNDiag
	jp .paintCenterGround
.paintRightGround
	ld e, INDEX_OW_PALETTE_Z2
	ld d, TILE_ENVIRONMENT_GROUND
	call CheckSegmentN
	call CheckSegmentNDiag
.paintCenterGround
	ld e, INDEX_OW_PALETTE_Z2
	ld d, TILE_ENVIRONMENT_GROUND
	call CheckSegmentM

ProcessTileLeftFar:
.checkTopWall
	call GetRoomCoordsLeftFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z3
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentB
	jp .paintGround
.paintDistance
	; todo: set to distance palette
	ld e, INDEX_OW_PALETTE_Z0
	ld d, TILE_ENVIRONMENT_DARK
	call CheckSegmentA
	call CheckSegmentB
.paintGround
	ld e, INDEX_OW_PALETTE_Z2
	ld d, TILE_ENVIRONMENT_GROUND
	call CheckSegmentK
	call CheckSegmentL
	call CheckSegmentLDiag

ProcessTileRightFar:
.checkTopWall
	call GetRoomCoordsRightFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, INDEX_OW_PALETTE_Z3
	ld d, TILE_ENVIRONMENT_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentE
	jp .paintGround
.paintDistance
	; todo: set to distance palette
	ld e, INDEX_OW_PALETTE_Z0
	ld d, TILE_ENVIRONMENT_DARK
	call CheckSegmentD
	call CheckSegmentE
.paintGround
	ld e, INDEX_OW_PALETTE_Z2
	ld d, TILE_ENVIRONMENT_GROUND
	call CheckSegmentO
	call CheckSegmentN
	call CheckSegmentNDiag
.finish
	ret
