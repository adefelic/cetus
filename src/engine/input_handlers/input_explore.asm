INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/event_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/item_constants.inc"
INCLUDE "src/constants/room_constants.inc"
INCLUDE "src/structs/event.inc"
INCLUDE "src/lib/hardware.inc"

SECTION "Explore Screen Input Handling", ROM0

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

; fixme use room cache instead of GetCurrentMapWallsRoomAddrFromRoomCoords
; open menu or pickup item if there is one
; todo move item pickup to long press of B
HandlePressedB:
	; check closest player facing wall. if it exists, the player isn't picking up an item, they are opening the item menu
.checkForWall ; zzz
	ld hl, wRoomNearCenter
	call GetNorthWallTypeFromRoomAddr ; it's looking at top wall not north, namespace problems ;_;
	cp WALL_TYPE_NONE
	jp nz, .openExploreMenu ; if there is a wall, then there isn't an item, so open explore menu
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
	ld [wTextRowsRendered], a

	ld a, TRUE
	ld [wBottomMenuDirty], a
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
	ld hl, wRoomNearCenter ; use room cache hell yeah wrote somethin good
	call GetNorthWallTypeFromRoomAddr ; top not north
	cp a, WALL_TYPE_NONE
	jp z, .advance
.doNotAdvance
	; todo play bonk sound
	ret
.advance:
	ld a, [wPlayerOrientation]
	cp a, ORIENTATION_NORTH
	jp z, .facingNorth
	cp a, ORIENTATION_EAST
	jp z, .facingEast
	cp a, ORIENTATION_SOUTH
	jp z, .facingSouth
.facingWest
	ld a, [wPlayerExploreX]
	dec a
	ld [wPlayerExploreX], a
	jp .finishAdvance
.facingNorth
	ld a, [wPlayerExploreY]
	dec a
	ld [wPlayerExploreY], a
	jp .finishAdvance
.facingEast
	ld a, [wPlayerExploreX]
	inc a
	ld [wPlayerExploreX], a
	jp .finishAdvance
.facingSouth
	ld a, [wPlayerExploreY]
	inc a
	ld [wPlayerExploreY], a
.finishAdvance
	call UpdateDangerLevel ; todo only do this if you're not on a safe space
	; todo reset danger if you're on a safe space
	call PlayFootstepSfx
	call HandleVisibleEvents
	call DirtyFpSegmentsAndTilemap
	ret

HandlePressedDown:
.turnAround
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
	call HandleVisibleEvents
	jp DirtyFpSegmentsAndTilemap

SetOrientationSouth:
	ld a, ORIENTATION_SOUTH
	ld [wPlayerOrientation], a
	call HandleVisibleEvents
	jp DirtyFpSegmentsAndTilemap

SetOrientationEast:
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a
	call HandleVisibleEvents
	jp DirtyFpSegmentsAndTilemap

SetOrientationWest:
	ld a, ORIENTATION_WEST
	ld [wPlayerOrientation], a
	call HandleVisibleEvents
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
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a
	ld a, SCREEN_ENCOUNTER
	ld [wActiveFrameScreen], a
	call RollNewDangerLevelSteps ; maybe do this once the encounter is over? it doesn't matter
	jp BeginEncounter

RollNewDangerLevelSteps: ; set wStepsToNextDangerLevel to a number between 3 and 6 inclusive
	call Rand ; between 0 and 255
	and `00000011 ; between 0 and 3
	add 3 ; between 3 and 6
	ld [wStepsToNextDangerLevel], a
	ret
