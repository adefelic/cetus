INCLUDE "src/constants/constants.inc"
INCLUDE "src/structs/event.inc"

SECTION "Warp Event Input Handling", ROMX

; this is inefficient and can be improved once the WarpDestination and Locale struct designs have settled
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
	; make hl point to the Locale now instead of the WarpDestination
	ld a, WarpDestination_DestinationLocale
	call AddAToHl
	call DereferenceHlIntoHl
	call LoadLocale
	jp DirtyFpSegmentsAndTilemap
