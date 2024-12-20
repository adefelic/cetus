INCLUDE "src/constants/constants.inc"
INCLUDE "src/structs/event.inc"
INCLUDE "src/utils/macros.inc"

SECTION "Warp Event Input Handling", ROM0

; this is inefficient and can be improved once the WarpDestination and Locale struct designs have settled
DoWarp::
	ld hl, wWarpDestinationAddr
	DereferenceHlIntoHl
	push hl ; stash hl
	ld a, WarpDestination_DestinationX
	AddAToHl
	ld a, [hl]
	ld [wPlayerExploreX], a

	pop hl
	push hl
	ld a, WarpDestination_DestinationY
	AddAToHl
	ld a, [hl]
	ld [wPlayerExploreY], a

	pop hl
	push hl
	ld a, WarpDestination_DestinationOrientation
	AddAToHl
	ld a, [hl]
	ld [wPlayerOrientation], a

	pop hl
	; make hl point to the Locale now instead of the WarpDestination
	ld a, WarpDestination_DestinationLocale
	AddAToHl
	DereferenceHlIntoHl
	call LoadLocale
	jp DirtyFpSegmentsAndTilemap
