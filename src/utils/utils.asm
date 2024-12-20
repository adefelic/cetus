
SECTION "Utils", ROM0

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
