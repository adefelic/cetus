INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/palette.inc"
INCLUDE "src/constants/gfx_constants.inc"

SECTION "Palette Update State", WRAM0
wBgPaletteUpdateAddr:: dw

SECTION "General Graphics Utilities", ROMX

InitColorPalettes::
	xor a
	ld [wBgPaletteUpdateAddr], a
	ld [wBgPaletteUpdateAddr + 1], a

	ld de, ForestBgPaletteSet
	call SetBgPaletteSet
	ld de, OwObjPaletteSet
	jp SetObjPaletteSet

; @param de: source palette set addr
EnqueueBgPaletteSetUpdate::
	ld a, d
	ld [wBgPaletteUpdateAddr], a
	ld a, e
	ld [wBgPaletteUpdateAddr + 1], a
	ret

; this should only be called on VBlank
SetEnqueuedBgPaletteSet::
	ld a, [wBgPaletteUpdateAddr]
	ld d, a
	ld a, [wBgPaletteUpdateAddr + 1]
	ld e, a

	xor a, d
	ret z

	call SetBgPaletteSet

	xor a
	ld [wBgPaletteUpdateAddr], a
	ld [wBgPaletteUpdateAddr + 1], a

	ret

; this should only be called on VBlank
; @param de: source palette set addr
SetBgPaletteSet:
	ld a, BCPSF_AUTOINC ; load bg color palette specification auto increment on write + addr of zero
	ld [rBCPS], a
	ld hl, rBCPD
	ld b, PALETTE_SET_SIZE
	jp CopyColorsToPalette

; this should only be called on VBlank
; @param de: source palette set addr
SetObjPaletteSet:
	ld a, OCPSF_AUTOINC ; load obj color palette specification auto increment on write + addr of zero
	ld [rOCPS], a
	ld hl, rOCPD
	ld b, PALETTE_SET_SIZE
	jp CopyColorsToPalette

; @param de: source
; @param hl: destination
; @param b: length
CopyColorsToPalette:
	ld a, [de]
	ld [hl], a
	inc de
	dec b
	jp nz, CopyColorsToPalette
	ret

; necessary when drawing background environment tiles
DirtyFpSegmentsAndTilemap::
	call DirtyFpSegments

; necessary when drawing over background environmenttiles
DirtyTilemap::
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	ret
