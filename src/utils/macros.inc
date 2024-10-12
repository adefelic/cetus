; macros

; @param a, offset
; @param hl, address
macro AddAToHl
	add l
	ld l, a
	ld a, h
	adc 0
	ld h, a
endm

; @param a, offset
; @param hl, address
macro AddAToDe
	add e
	ld e, a
	ld a, d
	adc 0
	ld d, a
endm

; @param hl, addr to dereference
; @return hl, new addr
; uses a,b,c,h,l
macro DereferenceHlIntoHl
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld c, a

	ld a, b
	ld l, a
	ld a, c
	ld h, a
endm

; @param de, addr to dereference
; @return de, new addr
; uses a,b,c,d,e
macro DereferenceDeIntoDe
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	ld c, a

	ld a, b
	ld e, a
	ld a, c
	ld d, a
endm

; copy bytes from one area to another
; @param de: source
; @param hl: destination
; @param bc: length
macro Memcopy
.loop\@
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jp nz, .loop\@
endm

; copy bytes from one area to another. max 256 bytes
; @param de: source
; @param hl: destination
; @param b: length
macro MemcopySmall
.loop\@
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jp nz, .loop\@
endm
