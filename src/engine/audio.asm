INCLUDE "src/assets/audio.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/utils/hardware.inc"

SECTION "Audio WRAM Values", WRAM0

wCh4CurrentSound: dw ; address
wCh4CurrentAudCmd: dw ; address
wCh4NoteDurationRemaining: db ; counter
wIsCh4Playing: db ; flag. used so we dont restart a note that's currently playing
wIsCh4SfxActive: db ; flag. used to bypass audio engine if nothing is happening
SECTION "Audio Routines", ROMX

InitAudio::
	xor a
	ldh [rNR50], a ; master volume / vin
	ld a, %11111111 ; all audio both speakers
	ldh [rNR51], a ;
	ld a, AUDENA_ON
	ldh [rNR52], a

	xor a
	ld [wCh4NoteDurationRemaining], a
	ld [wCh4CurrentAudCmd], a
	ld [wCh4CurrentAudCmd + 1], a
	ld [wCh4CurrentSound], a
	ld [wCh4CurrentSound + 1], a
	ld a, FALSE
	ld [wIsCh4Playing], a
	ld [wIsCh4SfxActive], a
	ret

; unused
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

PlayFootstepSfx::
	ld hl, FootstepSfx
	jp BeginPlayCh4Sfx

; update audio engine state to begin play on next frame
; @param hl, sfx addr to play
BeginPlayCh4Sfx:
	ld a, TRUE
	ld [wIsCh4SfxActive], a
.stashFirstAudCmd
	ld a, l
	ld [wCh4CurrentAudCmd], a
	ld a, h
	ld [wCh4CurrentAudCmd + 1], a
ProcessAudCmd:
	; process audcmd type
	ld a, [wCh4CurrentAudCmd]
	ld l, a
	ld a, [wCh4CurrentAudCmd + 1]
	ld h, a
	ld a, [hl] ; the type is the 0th byte of the cmd
	cp NOTE
	jp z, .processNoteAudCmd
.processEndAudCmd:
	ld a, FALSE
	ld [wIsCh4SfxActive], a
	ret
.processNoteAudCmd:
	inc hl ; get sound field of audcmd
	ld a, l
	ld [wCh4CurrentSound], a ; stash sound address. unused?
	ld a, h
	ld [wCh4CurrentSound + 1], a
	inc hl
	inc hl ; get duration field of audcmd
	ld a, [hl]
	ld [wCh4NoteDurationRemaining], a ; stash duration of sound

UpdateAudio::
PlayChannel1:
PlayChannel2:
PlayChannel3:
PlayChannel4:
	ld a, [wIsCh4SfxActive]
	cp FALSE
	ret z
.decDuration
	ld a, [wCh4NoteDurationRemaining]
	cp 0
	jp nz, .playNote
.unsetIsPlaying
	ld a, FALSE
	ld [wIsCh4Playing], a ; todo should sfx interrupt?? or should i make them shorter
.incrementCh4CurrentAudCmd
	ld a, [wCh4CurrentAudCmd]
	add a, AUD_CMD_SIZE
	ld [wCh4CurrentAudCmd], a
	ld a, [wCh4CurrentAudCmd + 1]
	adc 0
	ld [wCh4CurrentAudCmd + 1], a
	jp ProcessAudCmd
.playNote:
	dec a
	ld [wCh4NoteDurationRemaining], a
	ld a, [wIsCh4Playing]
	cp TRUE
	ret z
	; first dereference
	ld a, [wCh4CurrentSound]
	ld l, a
	ld a, [wCh4CurrentSound + 1]
	ld h, a
	call DereferenceHl ; second dereference ; todo just dereference once and store that value instead
	jp LoadChannel4Sound

; @param hl: addr of sound
LoadChannel1Sound:
	ld a, [hli]
	ldh [rNR11], a
	ld a, [hli]
	ldh [rNR12], a
	ld a, [hli]
	ldh [rNR13], a
	ld a, [hl]
	ldh [rNR14], a
	ret

; @param hl: addr of sound
LoadChannel2Sound:
	ld a, [hli]
	ldh [rNR21], a
	ld a, [hli]
	ldh [rNR22], a
	ld a, [hli]
	ldh [rNR23], a
	ld a, [hl]
	ldh [rNR24], a
	ret

; @param hl: addr of sound
LoadChannel3Sound:
	ld a, [hli]
	ldh [rNR31], a
	ld a, [hli]
	ldh [rNR32], a
	ld a, [hli]
	ldh [rNR33], a
	ld a, [hl]
	ldh [rNR34], a
	ret

; @param hl: addr of sound
LoadChannel4Sound:
	ld a, [hli]
	ldh [rNR41], a
	ld a, [hli] ; envelope
	ldh [rNR42], a
	ld a, [hli] ; polynomial function
	ldh [rNR43], a
	ld a, [hl] ; r/l vin, volume
	ldh [rNR44], a
	ld a, TRUE
	ld [wIsCh4Playing], a
	ret
