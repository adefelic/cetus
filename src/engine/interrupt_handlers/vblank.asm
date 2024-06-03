INCLUDE "src/lib/hardware.inc"

SECTION "VBlank HRAM", HRAM
	hLCDC:: db

SECTION "vblank handler stub", ROM0[$0040]
	push af
	ldh a, [hLCDC]
	ldh [rLCDC], a
	jp VBlankHandler

SECTION "vblank handler", ROM0
VBlankHandler:
	push bc
	push de
	push hl
	call SetEnqueuedBgPaletteSet
	call CopyShadowsToVram
	call GetKeys
	pop hl
	pop de
	pop bc
	pop af
	reti
