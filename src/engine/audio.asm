INCLUDE "src/assets/audio.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/lib/hardware.inc"
INCLUDE "src/utils/macros.inc"

SECTION "Shadow Audio Registers", WRAM0
wNR50: db ; not used yet
wNR51: db ; not used yet
wNR52: db ; not used yet

SECTION "Audio WRAM Values", WRAM0
wCh4CurrentSound: dw ; address
wCh4CurrentAudCmd: dw ; address
wCh4NoteDurationRemaining: db ; counter
wIsCh4SoundLoaded: db ; flag. used so we dont restart a note that's currently playing
wIsCh4SfxActive: db ; flag. used to bypass audio engine if nothing is happening

SECTION "Audio Routines", ROM0

InitAudio::
	; turn on APU
	ld a, AUDENA_ON
	ldh [rNR52], a

	; set all channels to play out of both speakers
	ld a, AUDTERM_4_LEFT + AUDTERM_3_LEFT + AUDTERM_2_LEFT + AUDTERM_1_LEFT + AUDTERM_4_RIGHT + AUDTERM_3_RIGHT + AUDTERM_2_RIGHT + AUDTERM_1_RIGHT
	ldh [rNR51], a

	; set VIN channel left and right bits (like in rNR51) to 0
	; set left and right speakers to both play at full
	ld a, NR50_LEFT_SPEAKER_VOLUME_MAX + NR50_RIGHT_SPEAKER_VOLUME_MAX
	ldh [rNR50], a

	; todo replace this with a call to LoadCurrentMusic
	; comment out to disable hUGE
	;call InitMusic

	; this is from my old sound effect stuff and not hUGE
	xor a
	ld [wCh4NoteDurationRemaining], a
	ld [wCh4CurrentAudCmd], a
	ld [wCh4CurrentAudCmd + 1], a
	ld [wCh4CurrentSound], a
	ld [wCh4CurrentSound + 1], a
	ld a, FALSE
	ld [wIsCh4SoundLoaded], a
	ld [wIsCh4SfxActive], a
	ret

; it looks like this isn't necessary anyways because music is loaded when the map is loaded
;InitMusic:
;	ld a, [hCurrentRomBank]
;	push af
;	ld a, bank(MusicSwamp)
;	rst SwapBank
;	ld hl, MusicSwamp
;	call hUGE_init
;	jp BankReturn

LoadCurrentMusic::
	; oh no all music should probably be in the same bank because its parameterized
	; i'm not actually sure if this is necessary. i assume hUGE_init accesses music ROM
	ld a, [hCurrentRomBank]
	push af
	ld a, [wCurrentMusicBank]
	rst SwapBank
		ld hl, wCurrentMusicTrack
		DereferenceHlIntoHl
		call hUGE_init
	jp BankReturn

PlayFootstepSfx::
	ld hl, FootstepSfx
	jp BeginPlayCh4Sfx

; update audio engine state to begin play on next frame
; @param hl, sfx addr to play
BeginPlayCh4Sfx:
	ld a, TRUE
	ld [wIsCh4SfxActive], a
	; store first aud_cmd addr
	ld a, l
	ld [wCh4CurrentAudCmd], a
	ld a, h
	ld [wCh4CurrentAudCmd + 1], a
	jp ProcessAudCmd

ProcessAudCmd:
	; process audcmd type
	ld hl, wCh4CurrentAudCmd
	ld a, [hli]
	ld h, [hl]
	ld l, a
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
	; comment out to disable hUGE
	ld a, [hCurrentRomBank]
	push af
		ld a, bank(EquipmentTiles)
		rst SwapBank
		call hUGE_dosound
	pop af
	ldh [hCurrentRomBank], a
	ld [rROMB0], a

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
	ld [wIsCh4SoundLoaded], a ; todo should sfx interrupt?? or should i make them shorter
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
	ld a, [wIsCh4SoundLoaded]
	cp TRUE
	ret z
	; first dereference
	ld a, [wCh4CurrentSound]
	ld l, a
	ld a, [wCh4CurrentSound + 1]
	ld h, a
	DereferenceHlIntoHl ; second dereference ; todo just dereference once and store that value instead
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
	ld [wIsCh4SoundLoaded], a
	ret
