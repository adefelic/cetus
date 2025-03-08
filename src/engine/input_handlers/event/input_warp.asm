INCLUDE "src/constants/constants.inc"
INCLUDE "src/structs/event.inc"
INCLUDE "src/utils/macros.inc"
INCLUDE "src/lib/hardware.inc"

SECTION "Warp Event Input Handling", ROM0

; this is inefficient and can be improved once the WarpDestination and Locale struct designs have settled
DoWarp::
	; swap bank
	ld a, [hCurrentRomBank]
	push af
		ld a, bank(Map1) ; hardcoded
		rst SwapBank
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
	; restore bank
	pop af
	ldh [hCurrentRomBank], a
	ld [rROMB0], a
	jp DirtyFpSegmentsAndTilemap
