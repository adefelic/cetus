SECTION "Utils", ROMX


; TODO make these into macros?


; @param a, offset
; @param hl, address
AddAToHl::
	ld b, a
	ld a, l
	add b
	ld l, a
	ld a, h
	adc 0
	ld h, a
	ret

; @param hl, addr to dereference
; @return hl, new addr
; uses a,b,c,h,l
DereferenceHlIntoHl::
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a

	ld a, b
	ld l, a
	ld a, c
	ld h, a
	ret
