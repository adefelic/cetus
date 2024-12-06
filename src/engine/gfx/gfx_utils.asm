INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"
INCLUDE "src/utils/macros.inc"

SECTION "Palette Update State", WRAM0
wBgPaletteSetUpdateAddr:: dw
wBgPaletteUpdateAddr:: dw

SECTION "Palette Routines", ROM0
InitColorPalettes::
	; bg:
	; zero out bg palette set. it'll be written to when the map is loaded
	xor a
	ld [wBgPaletteSetUpdateAddr], a
	ld [wBgPaletteSetUpdateAddr + 1], a
	; obj:
	; hardcode loading OwObjPaletteSet

	; this might be preemptive?
	; swap bank for copy
	ld a, [hCurrentBank]
	push af
	ld a, bank(OwObjPaletteSet)
	rst SwapBank

	ld de, OwObjPaletteSet
	jr SetObjPaletteSet

InitTileLoadingFlags::
	ld a, FALSE
	ld [wNpcSpriteTilesReadyForVramWrite], a
	ld [wBgWallTilesReadyForVramWrite], a

	; hmm, except for the initial load-in, these should only need to be updated one-at-a-time, i think?
	ld [wWeaponIconTilesReadyForVramWrite], a
	ret

; @param de: source palette set addr
EnqueueBgPaletteSetUpdate::
	ld a, d
	ld [wBgPaletteSetUpdateAddr], a
	ld a, e
	ld [wBgPaletteSetUpdateAddr + 1], a
	ret

; enqueues an update to the BG_PALETTE_SPECIAL palette
; @param hl: source palette address
EnqueueEnemyBgPaletteUpdate::
	ld a, h
	ld [wBgPaletteUpdateAddr], a
	ld a, l
	ld [wBgPaletteUpdateAddr + 1], a
	ret

SetEnqueuedEnemyBgPalette::
	ld a, [wBgPaletteUpdateAddr]
	ld d, a
	ld a, [wBgPaletteUpdateAddr + 1]
	ld e, a

	xor a, d
	ret z ; return if wBgPaletteUpdateAddr is 0x0000

	call SetEnemyBgPalette

	xor a
	ld [wBgPaletteUpdateAddr], a
	ld [wBgPaletteUpdateAddr + 1], a
	ret


; updates all 8 BG palettes
; this should only be called on VBlank
; enqueues if wBgPaletteSetUpdateAddr != 0
SetEnqueuedBgPaletteSet::
	ld a, [wBgPaletteSetUpdateAddr]
	ld d, a
	ld a, [wBgPaletteSetUpdateAddr + 1]
	ld e, a

	xor a, d
	ret z ; return if wBgPaletteSetUpdateAddr is 0x0000 ; wait this might be possible if it's in a different bank?

	ld a, [hCurrentBank]
	push af
	ld a, bank(Palettes) ; hard coded
	rst SwapBank

	call SetBgPaletteSetAutoInc

	xor a
	ld [wBgPaletteSetUpdateAddr], a
	ld [wBgPaletteSetUpdateAddr + 1], a
	jp BankReturn

SetEnemyBgPalette:
	; hack
	;ld a, [hCurrentBank]
	;push af
	;ld a, bank(Palettes)
	;rst SwapBank

	ld a, BCPSF_AUTOINC | PALETTE_SIZE * BG_PALETTE_ENEMY; load bg color palette specification auto increment on write + addr of BG_PALETTE_ENEMY
	ld [rBCPS], a
	ld hl, rBCPD
	ld b, PALETTE_SIZE
	MemcopySmall
	;jp BankReturn
	ret

; this should only be called on VBlank
; @param de: source palette set addr
SetBgPaletteSetAutoInc:
	ld a, BCPSF_AUTOINC ; load bg color palette specification auto increment on write + addr of zero
	ld [rBCPS], a
	ld hl, rBCPD
	ld b, PALETTE_SET_SIZE
.loop
	ld a, [de]
	ld [hl], a
	inc de
	dec b
	jp nz, .loop
	ret

; this should only be called on VBlank
; @param de: source palette set addr
SetObjPaletteSet:
	ld a, OCPSF_AUTOINC ; load obj color palette specification auto increment on write + addr of zero
	ld [rOCPS], a
	ld hl, rOCPD
	ld b, PALETTE_SET_SIZE
.loop_do_not_increment_hl
	ld a, [de]
	ld [hl], a
	inc de
	dec b
	jp nz, .loop_do_not_increment_hl
	jp BankReturn

; i'm trialing replacing this with MemcopySmall+ret
;; @param de: source
;; @param hl: destination
;; @param b: length
;CopyColorsToPalette:
;	ld a, [de]
;	ld [hl], a
;	inc de
;	dec b
;	jp nz, CopyColorsToPalette
;	ret

SECTION "Tilemap Dirty Routines", ROM0

; necessary when drawing background environment tiles
DirtyFpSegmentsAndTilemap::
	call DirtyFpSegments
; necessary when drawing over background environmenttiles
DirtyTilemap::
	ld a, TRUE
	ld [wIsShadowTilemapDirty], a
	ret
