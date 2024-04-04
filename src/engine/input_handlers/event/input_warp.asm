INCLUDE "src/constants/constants.inc"
INCLUDE "src/macros/event.inc"

SECTION "Warp Event Input Handling", ROMX

; this is inefficient and can be improved once the WarpDestination struct design has settled
DoWarp::
	ld hl, wWarpDestinationAddr
	call DereferenceHlIntoHl
	push hl ; stash hl
	ld a, WarpDestination_DestinationX
	call AddAToHl
	ld a, [hl]
	ld [wPlayerExploreX], a

	pop hl
	push hl
	ld a, WarpDestination_DestinationY
	call AddAToHl
	ld a, [hl]
	ld [wPlayerExploreY], a

	pop hl
	push hl
	ld a, WarpDestination_DestinationOrientation
	call AddAToHl
	ld a, [hl]
	ld [wPlayerOrientation], a

	pop hl
	ld a, WarpDestination_BgPaletteSetAddr
	call AddAToHl
	call DereferenceHlIntoHl
	ld d, h
	ld e, l
	call EnqueueBgPaletteSetUpdate

	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a
	ld a, TRUE
	ld [wHasPlayerTranslatedThisFrame], a
	ld a, TRUE
	ld [wHasPlayerRotatedThisFrame], a ; possibly. it's probably fine to just set this
	jp DirtyFpSegmentsAndTilemap
