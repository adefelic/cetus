SECTION "vblank handler stub", ROM0[$0040]
	jp VBlankHandler

SECTION "vblank handler", ROM0
VBlankHandler:
	push af
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
