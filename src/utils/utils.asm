SECTION "Utils", ROMX


; TODO make these into macros?


; @param a, offset
; @param hl, address
AddAToHl::
	add l
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

; @param a, # to convert. must be >= 0 and <= 99
; @return d, # in 10s place
; @return e, # in 1s place
ConvertBinaryNumberToDecimalNumber::
	ld b, a
	xor a
	ld d, a
	ld e, a
	ld a, b
.subTens
	sub 10
	jp c, .carryFromTens
	jp z, .finishFromTens
	inc d
	jp .subTens
.carryFromTens
	add 10
	jp .subOnes
.finishFromTens
	inc d
	ret
.subOnes
	sub 1
	ret c
	jp z, .finishFromOnes
	inc e
	jp .subOnes
.finishFromOnes
	inc e
	ret
