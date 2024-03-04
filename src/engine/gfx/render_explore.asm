INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"
INCLUDE "src/assets/tiles/indices/object_tiles.inc"
INCLUDE "src/macros/event.inc"
INCLUDE "src/utils/hardware.inc"

; todo move this
DEF DIALOG_MODAL_HEIGHT EQU 6 ; fixme this is a redefinition ...

SECTION "Dialog Modal State", WRAM0
wDialogModalState:: db ; should the game render the dialog root or a dialog option
wDialogHighlightedOption:: dw  ; addr of the dialog option that is currently highlighted if in the DIALOG_STATE_ROOT state
wCurrentDialogFrame:: dw ; addr of the dialog option frame is currently rendered if in the DIALOG_STATE_OPTION state
wCurrentLabelAddr:: dw ; addr of the label to paint if the dialog state is DIALOG_STATE_LABEL

SECTION "Dialog Rendering State", WRAM0
wTextRowsDrawnCount:: db

SECTION "Explore Screen Renderer", ROMX
; first person perspective can render up to 6 tiles:
;
; [1][2][3]
; [4][5][6]
;
; player is in tile 5 facing tile 2.
;

InitExploreState::
	ld a, DIALOG_STATE_LABEL
	ld [wDialogModalState], a
	; todo put all state in here, give reasonable defaults
	ret

SetInitialEventRenderingState::
	ld a, DIALOG_STATE_LABEL
	ld [wDialogModalState], a
	; really the below should happen once we enter DIALOG_ROOT state
	xor a
	ld [wTextRowsDrawnCount], a
	ret

; todo change map stuff to compass directions. trbl is player relative, nesw is absolute
; todo rename this to ... draw FP Tilemap?
; trbl are all relative to the player's orientation
LoadExploreScreen::
.updateShadowBgTilemap
	; render walls
	; todo:
	;   maybe make it so when rendering an event, all other background are painted with a single palette?
	;   it might look weird flattening depth like that.
	call RenderFirstPersonView
	; maybe render event on top of first person view
	ld a, [wIsPlayerFacingWallInteractable]
	cp FALSE
	jp z, .updateShadowOam
	call RenderDialog
.updateShadowOam:
	ld a, [wPreviousFrameScreen]
	cp SCREEN_EXPLORE
	jp z, .updateExploreSprites
.unloadUnusedSprites
	cp SCREEN_ENCOUNTER
	jp nz, .updateExploreSprites
	call PaintEncounterSpritesOffScreen
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

; overlay event bg tiles, reading from the active event pointers
RenderDialog:
	; check if we are rendering the dialog option tree or a specific dialog option
	ld a, [wDialogModalState]
	cp DIALOG_STATE_LABEL
	jp z, RenderLabel
	cp DIALOG_STATE_ROOT
	jp z, RenderDialogRoot
	cp DIALOG_STATE_OPTION
	jp z, RenderDialogOption
	; control shouldn't reach here
	ret

RenderLabel:
	; load wRoomEventAddr, add EventLabelText offset, store in wCurrentLabelAddr
	ld a, [wRoomEventAddr]
	add RoomEvent_EventLabelText
	ld [wCurrentLabelAddr], a
	ld a, [wRoomEventAddr + 1]
	adc 0
	ld [wCurrentLabelAddr + 1], a
	call PaintLabelModel
	ret

RenderDialogRoot:
; okay so highlighting an entry just changes its palette
; when A is pressed, text is replaced with the text of the first frame ofthe highlighted entry.
; when an entry is highlighted, the _wHighlightedDialogOption_ flag is updated, which points to the option
; when A is pressed, we switch to option rendering mode and render the first frame
.renderTopRow
	call PaintDialogTopRow
.renderDialogOptionLabelsWithTrueFlag
	; iterate over DialogOptions array @ wDialogOptionsAddr w wDialogOptionsSize and wDialogOptionsIndex
	; load counter
	ld a, [wDialogOptionsSize]
	ld b, a ; b is the # of times we can loop
	; load 0th array element addr into hl
	ld a, [wDialogOptionsAddr]
	ld l, a
	ld a, [wDialogOptionsAddr + 1]
	ld h, a
.loop
	; the word at offset 0 of a DialogOption is the address of the flag that determines if it should be displayed
	push hl ; stash DialogOption[b] addr
	call DereferenceHlIntoHl ; load addr of flag
	ld a, [hl]
	cp FALSE
	jp z, .checkIfAllDialogOptionsHaveBeenIteratedOver
.renderDialogOptionLabel
	pop hl ; restore addr of DialogOption[b]
	push hl ; save addr of DialogOption[b]
	; add 2 to get the addr of the label text (DialogOptionLabel)
	inc hl
	inc hl
	ld a, [wTextRowsDrawnCount]
	ld c, a
	call PaintDialogTextRow
	; inc # of text rows drawn
	ld a, [wTextRowsDrawnCount]
	inc a
	ld [wTextRowsDrawnCount], a
.checkIfAllDialogOptionsHaveBeenIteratedOver
	pop hl ; restore addr of DialogOption[b]
	ld a, b
	dec a
	ld b, a
	cp 0
	jp z, .finishRenderingDialogRoot
	; get the next
	ld a, sizeof_DialogOption
	add a, l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	jp .loop
.finishRenderingDialogRoot
.fillWithEmptyRows
	; draw blank rows until (wTextRowsDrawnCount == DIALOG_MODAL_TEXT_AREA_HEIGHT)
	ld a, [wTextRowsDrawnCount]
.fillLoop
	cp DIALOG_MODAL_HEIGHT - 2
	jp z, .renderBottomRow
	call PaintEmptyRow
	inc a
	ld [wTextRowsDrawnCount], a ; saving this value to ram might be unnecessary
	jp .fillLoop
.renderBottomRow
	call PaintDialogBottomRow
	ret

RenderDialogOption:
	ret

PaintExploreSpritesOffScreen::
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
ProcessRoomCenterNear: ; process rooms closest to farthest w/ dirtying to only draw topmost z segments
.checkLeftWall:
	call GetRoomCoordsCenterNearWRTPlayer ; todo, put coords in ram?
	call GetActiveMapRoomAddrFromCoords ; puts player tilemap entry addr in hl. should probably put this somewhere?
	call GetRoomWallAttributesAddrFromMapAddr ; put related RoomWallAttributes addr in hl
	call GetLeftWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .checkTopWall
.paintLeftWall
	; okay instead we can say ... load that wall's panel index
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
	call CheckSegmentP
	ld d, TILE_EXPLORE_DIAG_L
	call CheckSegmentPDiag
.checkTopWall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .checkRightWall
.paintTopWall
	ld e, BG_PALETTE_Z1
	ld d, TILE_EXPLORE_WALL_SIDE
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
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
	call CheckSegmentR
	ld d, TILE_EXPLORE_DIAG_R
	call CheckSegmentRDiag
.paintGround
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_GROUND ; todo on all ground paints, flip (shuffle could be cool) ground every step
	call CheckSegmentQ

ProcessRoomLeftNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsLeftNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintTopWall
	ld e, BG_PALETTE_Z1
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentK
.paintGround
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentP
	call CheckSegmentPDiag

ProcessRoomRightNear:
	; todo bounds check
.checkTopWall
	call GetRoomCoordsRightNearWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintGround
.paintTopWall
	ld e, BG_PALETTE_Z1
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentE
	call CheckSegmentO
.paintGround
	ld e, BG_PALETTE_Z0
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentR
	call CheckSegmentRDiag

ProcessRoomCenterFar:
.checkLeftWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetLeftWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintLeftGround ; paint ground if no left wall
.paintLeftWall
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentB
	call CheckSegmentL
	ld d, TILE_EXPLORE_DIAG_L
	call CheckSegmentLDiag
	jp .checkTopWall
.paintLeftGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
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
	ld d, TILE_EXPLORE_WALL_SIDE
	ld e, BG_PALETTE_Z3
	call CheckSegmentC
	jp .checkRightWall
.paintDistance
	; todo: set to distance palette
	ld e, BG_PALETTE_FOG
	ld d, TILE_EXPLORE_DARK
	call CheckSegmentCFog
.checkRightWall
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetRightWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintRightGround ; paint ground if no right wall
.paintRightWall
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentN
	ld d, TILE_EXPLORE_DIAG_R
	call CheckSegmentNDiag
	jp .paintCenterGround
.paintRightGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentN
	call CheckSegmentNDiag
.paintCenterGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentM

ProcessRoomLeftFar:
.checkTopWall
	call GetRoomCoordsLeftFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, BG_PALETTE_Z3
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentA
	call CheckSegmentB
	jp .paintGround
.paintDistance
	; todo: set to distance palette
	ld e, BG_PALETTE_FOG2
	ld d, TILE_EXPLORE_DARK
	; add fog
	call CheckSegmentA
	call CheckSegmentB
	;call CheckSegmentAFog
	;call CheckSegmentBFog
.paintGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentK
	call CheckSegmentL
	call CheckSegmentLDiag

ProcessRoomRightFar:
.checkTopWall
	call GetRoomCoordsRightFarWRTPlayer
	call GetActiveMapRoomAddrFromCoords
	call GetRoomWallAttributesAddrFromMapAddr
	call GetTopWallWrtPlayer
	cp a, WALL_TYPE_NONE
	jp z, .paintDistance
.paintTopWall
	ld e, BG_PALETTE_Z3
	ld d, TILE_EXPLORE_WALL_SIDE
	call CheckSegmentD
	call CheckSegmentE
	jp .paintGround
.paintDistance
	; todo: set to distance palette
	ld e, BG_PALETTE_FOG2
	ld d, TILE_EXPLORE_DARK
	; add fog
	call CheckSegmentD
	call CheckSegmentE
	;call CheckSegmentDFog
	;call CheckSegmentEFog
.paintGround
	ld e, BG_PALETTE_Z2
	ld d, TILE_EXPLORE_GROUND
	call CheckSegmentO
	call CheckSegmentN
	call CheckSegmentNDiag
.finish
	ret
