INCLUDE "src/lib/structs.inc"

; todo use any of this

DEF AUD_CMD_NOTE EQU $00
DEF AUD_CMD_END  EQU $01
DEF AUD_CMD_LOOP EQU $02

	;struct AudioCommand
	;	bytes 1, Type
	;	words 1, Sound ; addr of a ChannelXSound
	;	bytes 2, Duration ; in frames


	;		db \1 ; aud_cmd type
	;dw \2 ; sound addr
	;db \3 * \4 / 8; duration in remaining frames. arg 3: 16th note = 1, 8th = 2, quarter = 4, half = 8, whole = 16


	; channel 1: pulse with period sweep
	struct Channel1Sound
		bytes 1, NR10 ; channel 1 sweep
		bytes 1, NR11 ; channel 1 length timer, duty cycle
		bytes 1, NR12 ; channel 1 volume, envelope
		bytes 1, NR13 ; channel 1 period low (write-only)
		bytes 1, NR14 ; channel 1 period high, control
	end_struct

	; channel 2: pulse. same as 1 but without NR10
	struct Channel2Sound
		bytes 1, NR21 ; channel 2 length timer, duty cycle
		bytes 1, NR22 ; channel 2 volume, envelope
		bytes 1, NR23 ; channel 2 period low (write-only)
		bytes 1, NR24 ; channel 2 period high, control
	end_struct

	; channel 3: wave. allows more control of the waveform
	struct Channel3Sound
		bytes 1, NR30 ; channel 3 DAC enable. turning off DAC turns off channel. sometimes necessary. may cause pop
		bytes 1, NR31 ; channel 3 length timer (write-only)
		bytes 1, NR32 ; channel 3 volume (only 0,25,50,100%)
		bytes 1, NR33 ; channel 3 period low (write-only)
		bytes 1, NR34 ; channel 3 period high, control
		bytes 16, WavePatternRam
	end_struct

	; channel 4: noise
	struct Channel4Sound
		bytes 1, NR41 ; channel 4 length timer. higher length timer = shorter sound
		bytes 1, NR42 ; channel 4 volume, envelope. same as NR12, NR22
		bytes 1, NR43 ; channel 4 period frequency, randomness
		bytes 1, NR44 ; channel 4 control
	end_struct
