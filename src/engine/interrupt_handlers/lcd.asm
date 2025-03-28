INCLUDE "src/lib/hardware.inc"

SECTION "lcd handler stub", ROM0[$0048]
	jp LcdHandler

SECTION "lcd handler", ROM0
LcdHandler:
.pushes
	push af
	push bc
	push de
	push hl
.updateAudio
	call UpdateAudio
.advanceEncounterAnimation
	ld a, [wAnimationFramesRemaining]
	dec a
	jp z, .pops
	ld [wAnimationFramesRemaining], a
.pops
	pop hl
	pop de
	pop bc
	pop af
	reti
