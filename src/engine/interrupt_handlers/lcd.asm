INCLUDE "src/lib/hardware.inc"

SECTION "lcd handler stub", ROM0[$0048]
	jp LcdHandler

SECTION "lcd handler", ROM0
LcdHandler:
	push af
	push bc
	push de
	push hl
	ld a, BANK(UpdateAudio)
	ld [rROMB0], a
	;call UpdateAudio zzz
	call AdvanceEncounterAnimation
	pop hl
	pop de
	pop bc
	pop af
	reti

AdvanceEncounterAnimation:
	ld a, [wAnimationFramesRemaining]
	dec a
	ret z
	ld [wAnimationFramesRemaining], a
	ret
