INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/audio.inc"

SECTION "Audio Routines", ROMX

InitAudio::
	xor a
	ldh [rNR50], a ; master volume / vin
	ld a, %11111111 ; all audio both speakers
	ldh [rNR51], a ;
	ld a, AUDENA_ON
	ldh [rNR52], a
	ret

InitTimer::
	; timer modulo
	ld a, $FF
	ldh [rTMA], a

	; enable timer at 4 khz
	ld a, TACF_START | TACF_4KHZ
	ldh [rTAC], a

	; enable timer overflow interrupt
	ld a, IEF_TIMER
	ldh [rIE], a
	ret


; todo it would be cool to do a left step, right step
PlayFootstep::
	; If the functionality is enabled, a channel’s length timer ticks up5 at 256 Hz (tied to DIV-APU)
	;   from the value it’s initially set at.
	; When the length timer reaches 64, the channel is turned off.
	;ld a, %00000001
	;ldh [rNR41], a ; audlen
	;ld a, %11110111 ; envelope
	;ldh [rNR42], a
	;ld a, %00000000
	;ldh [rNR43], a
	;ld a, %11000000
	;ldh [rNR44], a
	ld a, [Footstep]
	ldh [rNR41], a
	ld a, [Footstep+1] ; envelope
	ldh [rNR42], a
	ld a, [Footstep+2] ; polynomial function
	ldh [rNR43], a
	ld a, [Footstep+3] ; r/l vin, volume
	ldh [rNR44], a
	ret

PlayTick::
	ld a, [Tick]
	ldh [rNR41], a
	ld a, [Tick+1] ; envelope
	ldh [rNR42], a
	ld a, [Tick+2] ; polynomial function
	ldh [rNR43], a
	ld a, [Tick+3] ; r/l vin, volume
	ldh [rNR44], a
	ret
