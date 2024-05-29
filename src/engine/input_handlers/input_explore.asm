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
	ld a, [wInExploreMenu]
	cp TRUE
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
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a
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
.advanceEventState
	ld a, [wRoomEventType]
	cp ROOMEVENT_DIALOG
	jp z, PressedAFromDialogLabel
	cp ROOMEVENT_WARP
	jp z, DoWarp
	; control should not reach here
	ret

; open menu or pickup item if there is one
; todo move item pickup to long press of B
HandlePressedB:
	; check closest player facing wall. if it exists, the player isn't picking up an item, they are opening the item menu
.checkForWall
	call GetRoomCoordsCenterNearWRTPlayer
	call GetRoomWallAttributesFromRoomCoords ; put related RoomWallAttributes addr in hl
	call GetTopWallWrtPlayer
	cp WALL_TYPE_NONE
	jp nz, .openExploreMenu ; double negative >_< if there is a wall, then there isn't an item, so open explore menu
.checkForItem
	call GetRoomCoordsCenterFarWRTPlayer
	call GetActiveItemMapRoomAddrFromCoords
	ld a, [hl]
	cp ITEM_NONE ; if there isn't an item to pick up, the player is opening the item menu
	jp z, .openExploreMenu
.pickUpItem
	; stash item map room in de
	ld d, h
	ld e, l

	call IncrementInventoryItemQuantity

	xor a
	ld [de], a ; remove item from item map
	ret

.openExploreMenu
	ld a, TRUE
	ld [wInExploreMenu], a

	; these two variables reset the highlight state
	xor a
	ld [wDialogTextRowHighlighted], a
	ld [wDialogRootTextAreaRowsRendered], a

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
	call GetRoomWallAttributesFromRoomCoords ; put related RoomWallAttributes addr in hl
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
	ld [wHasPlayerTranslated], a
	jp DirtyFpSegmentsAndTilemap

HandlePressedDown:
.turnAround
	ld a, TRUE
	ld [wHasPlayerRotated], a
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, SetOrientationSouth
	cp a, ORIENTATION_EAST
	jp z, SetOrientationWest
	cp a, ORIENTATION_SOUTH
	jp z, SetOrientationNorth
	jp SetOrientationEast

HandlePressedLeft:
.turnLeft
	ld a, TRUE
	ld [wHasPlayerRotated], a
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, SetOrientationWest
	cp a, ORIENTATION_EAST
	jp z, SetOrientationNorth
	cp a, ORIENTATION_SOUTH
	jp z, SetOrientationEast
	jp SetOrientationSouth

HandlePressedRight:
.turnRight
	ld a, TRUE
	ld [wHasPlayerRotated], a
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, SetOrientationEast
	cp a, ORIENTATION_EAST
	jp z, SetOrientationSouth
	cp a, ORIENTATION_SOUTH
	jp z, SetOrientationWest
	jp SetOrientationNorth

SetOrientationNorth:
	ld a, ORIENTATION_NORTH
	ld [wPlayerOrientation], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationSouth:
	ld a, ORIENTATION_SOUTH
	ld [wPlayerOrientation], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationEast:
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a
	jp DirtyFpSegmentsAndTilemap

SetOrientationWest:
	ld a, ORIENTATION_WEST
	ld [wPlayerOrientation], a
	jp DirtyFpSegmentsAndTilemap

; todo move this to entering explore screen from encounter or main menu
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
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a
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
