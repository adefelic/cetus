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

AddAToDe::
	add e
	ld e, a
	ld a, d
	adc 0
	ld d, a
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

; @param de, addr to dereference
; @return de, new addr
; uses a,b,c,d,e
DereferenceDeIntoDe::
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	ld c, a

	ld a, b
	ld e, a
	ld a, c
	ld d, a
	ret

; @param a, # to convert. must be >= 0 and <= 99
; @return d, # in 10s place
; @return e, # in 1s place
ConvertBinaryNumberToTwoDigitDecimalNumber::
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

; @param a, # to convert. must be >= 0 and <= 999
; @return b, # in 100s place
; @return d, # in 10s place
; @return e, # in 1s place
ConvertBinaryNumberToThreeDigitDecimalNumber::
	ld c, a ; stash source # in b
	; zero out return registers
	xor a
	ld b, a
	ld d, a
	ld e, a
	ld a, c ; replace source #

.subHundreds
	sub 100
	jp c, .carryFromHundreds
	jp z, .finishFromHundreds
	inc b
	jp .subHundreds
.carryFromHundreds
	add 100
	jp .subTens
.finishFromHundreds
	inc b
	ret

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

; @param d, modulo value
; @return a, remainder
SingleByteModulo::
.subtractionLoop
	sub d
	jp z, .returnZero
	jp c, .returnNonZero
	jp .subtractionLoop
.returnZero
	xor a
	ret
.returnNonZero
	add d
	ret
