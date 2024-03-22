INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/item_constants.inc"
INCLUDE "src/macros/event.inc"
INCLUDE "src/lib/hardware.inc"

SECTION "Explore Screen Input Handling", ROMX

HandleInputExploreScreen::
	ld a, [wIsPlayerFacingWallInteractable]
	cp FALSE
	jp z, .handleExploreInput
.handleDialogInput:
	; todo should also handle the explore menu. they'll probably have shared controls
	ld a, [wDialogState]
	cp DIALOG_STATE_ROOT
	jp z, HandleInputFromDialogRoot
	cp DIALOG_STATE_BRANCH
	jp z, HandleInputFromDialogBranch
	; being in DIALOG_STATE_LABEL is essentially the same as exploring, only the "A" handler behaves differently
.handleExploreInput:
	ld a, [wExploreState]
	cp EXPLORE_STATE_MENU
	jp z, HandleInputFromItemMenu
.checkPressedStart:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_START
	jp nz, HandlePressedStart
.checkPressedSelect:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_SELECT
	jp nz, HandlePressedSelect
.checkPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp nz, HandlePressedA
.checkPressedB:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_B
	jp nz, HandlePressedB
.checkPressedUp:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_UP
	jp nz, HandlePressedUp
.checkPressedDown:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_DOWN
	jp nz, HandlePressedDown
.checkPressedLeft:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_LEFT
	jp nz, HandlePressedLeft
.checkPressedRight:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_RIGHT
	jp nz, HandlePressedRight
	ret

HandlePressedStart:
PauseGame:
	ld a, SCREEN_PAUSE
	ld [wActiveFrameScreen], a
	jp DirtyTilemap

HandlePressedSelect:
DebugEnterEncounter:
	call InitEncounter
	jp DirtyTilemap

HandlePressedA:
	ld a, [wIsPlayerFacingWallInteractable]
	cp FALSE
	ret z
.enterDialogMaybe:
	ld a, [wDialogState]
	cp DIALOG_STATE_LABEL
	jp z, PressedAFromDialogLabel
	; control should not reach here
	ret

HandlePressedB:
	; if current room has an item, call PickUpItem::
	call GetItemFromCurrentRoom ; puts current room item id in A
	cp ITEM_NONE
	jp nz, PickUpItem ; pick item if there is one, toggle menu otherwise
.setMenuState
	ld a, EXPLORE_STATE_MENU
	ld [wExploreState], a
	ld a, TRUE
	ld [wDialogModalDirty], a
	jp DirtyFpSegmentsAndTilemap ; this is to remove the event label if there is one

HandlePressedUp:
.seedRandMaybe
	ld a, [wIsRandSeeded]
	cp TRUE
	jp z, .attemptMoveUp
	ld a, [rDIV]
	ld c, a
	call Srand
.attemptMoveUp:
	ld a, [wPlayerExploreX]
	ld d, a
	ld a, [wPlayerExploreY]
	ld e, a
	call GetActiveMapRoomAddrFromCoords ; puts player bg map entry addr in hl
	call GetRoomWallAttributesAddrFromMapAddr ; put related RoomWallAttributes addr in hl
AdvanceIfNoCollisions:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	call GetWestWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp nz, .doNotAdvance
	ld a, [wPlayerExploreX]
	dec a
	ld [wPlayerExploreX], a
	jp .finishAdvance
.facingNorth
	call GetNorthWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp nz, .doNotAdvance
	ld a, [wPlayerExploreY]
	dec a
	ld [wPlayerExploreY], a
	jp .finishAdvance
.facingEast
	call GetEastWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp nz, .doNotAdvance
	ld a, [wPlayerExploreX]
	inc a
	ld [wPlayerExploreX], a
	jp .finishAdvance
.facingSouth
	call GetSouthWallTypeFromRoomAttrAddr
	cp a, WALL_TYPE_NONE
	jp nz, .doNotAdvance
	ld a, [wPlayerExploreY]
	inc a
	ld [wPlayerExploreY], a
	jp .finishAdvance
.doNotAdvance
	; todo play bonk sound
	ret
.finishAdvance
	call UpdateDangerLevel ; todo only do this if you're not on a safe space
	; todo reset danger if you're on a safe space
	call PlayFootstepSfx
	ld a, TRUE
	ld [wHasPlayerTranslatedThisFrame], a
	jp DirtyFpSegmentsAndTilemap

HandlePressedDown:
.attemptTurnAround:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	jp SetOrientationEast
.facingNorth
	jp SetOrientationSouth
.facingEast
	jp SetOrientationWest
.facingSouth
	jp SetOrientationNorth

HandlePressedLeft:
.attemptTurnLeft:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	jp SetOrientationSouth
.facingNorth
	jp SetOrientationWest
.facingEast
	jp SetOrientationNorth
.facingSouth
	jp SetOrientationEast

HandlePressedRight:
.attemptTurnRight:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	jp SetOrientationNorth
.facingNorth
	jp SetOrientationEast
.facingEast
	jp SetOrientationSouth
.facingSouth
	jp SetOrientationWest

SetOrientationNorth:
	ld a, ORIENTATION_NORTH
	ld [wPlayerOrientation], a
	ld a, TRUE
	ld [wHasPlayerRotatedThisFrame], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationSouth:
	ld a, ORIENTATION_SOUTH
	ld [wPlayerOrientation], a
	ld a, TRUE
	ld [wHasPlayerRotatedThisFrame], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationEast:
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a
	ld a, TRUE
	ld [wHasPlayerRotatedThisFrame], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationWest:
	ld a, ORIENTATION_WEST
	ld [wPlayerOrientation], a
	ld a, TRUE
	ld [wHasPlayerRotatedThisFrame], a
	jp DirtyFpSegmentsAndTilemap

DirtyFpSegmentsAndTilemap::
	call DirtyFpSegments
DirtyTilemap:
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	ret

InitDangerLevel::
	ld a, DANGER_INITIAL
	ld [wCurrentDangerLevel], a
	ld a, 1
	ld [wStepsToNextDangerLevel], a
	ret

; todo i could call InitDangerLevel when reset is hit
UpdateDangerLevel:
	ld a, [wStepsToNextDangerLevel]
	dec a
	ld [wStepsToNextDangerLevel], a
	cp 0
	ret nz
.incDangerLevel:
	ld a, [wCurrentDangerLevel]
	inc a
	ld [wCurrentDangerLevel], a
	cp DANGER_RESET
	jp nz, RollNewDangerLevelSteps
.resetDangerLevelToGrey:
	ld a, DANGER_GREY
	ld [wCurrentDangerLevel], a
InitEncounter:
	; todo really this should begin the encounter on the next frame, after the player has moved
	ld a, SCREEN_ENCOUNTER
	ld [wActiveFrameScreen], a
	call RollNewDangerLevelSteps
	jp GenerateEncounter

RollNewDangerLevelSteps: ; set wStepsToNextDangerLevel to a number between 3 and 6 inclusive
	call Rand ; between 0 and 255
	and `00000011 ; between 0 and 3
	add 3 ; between 3 and 6
	ld [wStepsToNextDangerLevel], a
	ret
