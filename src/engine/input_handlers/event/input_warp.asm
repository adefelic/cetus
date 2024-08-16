INCLUDE "src/constants/constants.inc"
INCLUDE "src/structs/event.inc"
INCLUDE "src/structs/locale.inc"

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

; @param hl, addr of Locale
LoadLocale::
.loadPaletteSet
	push hl ; contains addr of Locale
	ld a, Locale_BgPaletteSetAddr
	call AddAToHl ; contains addr of Locale_BgPaletteSetAddr
	call DereferenceHlIntoHl
	ld d, h
	ld e, l
	call EnqueueBgPaletteSetUpdate
	pop hl
	push hl

.loadEncountersTable
	ld a, Locale_EncountersTableAddr
	call AddAToHl
	ld a, [hli]
	ld [wCurrentEncounterTable], a
	ld a, [hl]
	ld [wCurrentEncounterTable+1], a
	pop hl
	push hl

.loadMusic
	ld a, Locale_MusicAddr
	call AddAToHl
	ld a, [hli]
	ld [wCurrentMusicTrack], a
	ld a, [hl]
	ld [wCurrentMusicTrack+1], a

	call LoadCurrentMusic

	pop hl

.loadSpecialWallTiles
	ld a, Locale_WallTilesAddr
	call AddAToHl
	ld a, [hli]
	ld [wCurrentWallTilesAddr], a
	ld a, [hl]
	ld [wCurrentWallTilesAddr+1], a

	ld a, TRUE
	ld [wDoesBgWallTileDataNeedToBeCopiedIntoVram], a
	ret
