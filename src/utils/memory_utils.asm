SECTION "Memory Copy Utils", ROMX

; @param d: source tile id
; @param hl: destination
; @param b: length
CopyByteInDToRange::
	ld a, d
.loop
	ld [hli], a ; write tile id
	dec b
	jp nz, .loop
	ret

; @param e: BG Map Attribute byte
; @param hl: destination
; @param bc: length
CopyByteInEToRangeLarge::
	ld a, e
	ld [hli], a ; write palette id
	dec bc
	ld a, b
	or c
	jp nz, CopyByteInEToRangeLarge
	ret

; @param e: BG Map Attribute byte
; @param hl: destination
; @param b: length
CopyByteInEToRange::
	ld a, e
.loop
	ld [hli], a ; write palette id
	dec b
	jp nz, .loop
	ret

; copy bytes from one area to another
; @param de: source
; @param hl: destination
; @param bc: length
Memcopy::
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jp nz, Memcopy
	ret

; copy bytes from one area to another. max 256 bytes
; @param de: source
; @param hl: destination
; @param b: length
MemcopySmall::
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jp nz, MemcopySmall
	ret

; copy bytes from one area to another. max 256 bytes
; @param d: source value
; @param hl: destination
; @param b: length
CopyIncrementing::
	ld a, d
	ld [hli], a
	inc d
	dec b
	ld a, b
	jp nz, CopyIncrementing
	ret
