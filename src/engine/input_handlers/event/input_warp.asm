INCLUDE "src/constants/constants.inc"
INCLUDE "src/structs/event.inc"

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
	push hl
	ld a, WarpDestination_BgPaletteSetAddr
	call AddAToHl
	call DereferenceHlIntoHl
	ld d, h
	ld e, l
	call EnqueueBgPaletteSetUpdate

	pop hl
	ld a, WarpDestination_DestinationLocation
	call AddAToHl
	ld a, [hl]
	ld [wPlayerLocation], a

	ld a, FALSE
	ld [wIsPlayerFacingWallInteractable], a
	jp DirtyFpSegmentsAndTilemap
