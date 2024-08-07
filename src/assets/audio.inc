INCLUDE "src/structs/audio.inc"


DEF NR50_LEFT_SPEAKER_VOLUME_MAX  EQU %01110000
DEF NR50_RIGHT_SPEAKER_VOLUME_MAX EQU %00000111

; channel ids
DEF CHANNEL_1 EQU $00
DEF CHANNEL_2 EQU $01
DEF CHANNEL_3 EQU $02
DEF CHANNEL_4 EQU $03

; audio register macros
MACRO sound
	assert _NARG == 4, "sound macro must have exactly 4 arguments"
	rept _NARG
		db \1
		shift
	endr
ENDM

; aud_cmd struct
MACRO aud_cmd
	assert _NARG == 4, "note macro must have exactly 4 arguments"
	db \1 ; aud_cmd type
	dw \2 ; sound addr
	db \3 * \4 / 8; duration in remaining frames. arg 3: 16th note = 1, 8th = 2, quarter = 4, half = 8, whole = 16
ENDM

DEF TYPE_OFFSET     EQU $00
DEF SOUND_OFFSET    EQU $01
DEF DURATION_OFFSET EQU $03
DEF AUD_CMD_SIZE    EQU 4

; aud_cmd types
DEF NOTE     EQU $00
DEF END      EQU $01
DEF LOOP     EQU $02 ; nyi

SECTION "Audio Data", ROMX

; ack this still makes a popping noise. is the channel being switched off and on?
RestSound:: ; channel 4
	sound $00, $01, $00, $00

; todo deprecate
FootstepSound:: ; channnel 4
	sound $35, $F1, $80, $C0

; new sounds B)
	;dstruct Channel4Sound, FootstepCh4Sound, $35, $F1, $80, $C0

FootstepSfx::
	; tempo (almost bpm) ; unused
	; db 120 ; so 2 beats per second, so 30 frames per beat. db 120 means quarter note counter = 30
	; todo define channel 4?
	aud_cmd NOTE, FootstepSound, 2, 120
	;aud_cmd NOTE, RestSound, 1, 120
	aud_cmd NOTE, FootstepSound, 2, 120
	aud_cmd END, RestSound, 4, 0
