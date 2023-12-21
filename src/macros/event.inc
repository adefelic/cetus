DEF ET_WALLS_OFFSET EQU $00
DEF ET_TYPE_OFFSET EQU $01
DEF ET_DEF_OFFSET EQU $02
MACRO event_trigger
	assert _NARG == 3, "event_trigger must have exactly 3 arguments"
	db \1 ; event walls ; no walls = room based event
	db \2 ; event_type; 0 = warp, 1 = dialog, 2 = storefront ...
	dw \3 ; addr of event definition
	; sequence of dialog boxes + sprites/animations
	; effects of pressing a on
	; an event has a sequence of event frames which have
ENDM

; this could be cut down quite a bit
; upon pressing A at the end of the event frames, the player is moved to the location described
DEF ED_MAP_OFFSET EQU $03
MACRO event_def_type_warp
	assert _NARG == 6, "event_type_warp must have exactly 6 arguments"
	db \1 ; # of frames. there must be at least 1
	dw \2 ; address of event_frames
	db \3 ; warp dest map
	db \4 ; warp dest x
	db \5 ; warp dest y
	db \6 ; warp dest orientation
ENDM

DEF EVENT_FRAME_SIZE EQU $05 ; this isnt true
MACRO event_frame
	assert _NARG == 4, "event_frame must have exactly 4 arguments"
	db \1 ; flag: player control lock?
	dw \2 ; addr of sprite
	db \3 ; size of text string
	ds \4 ; text to display ; todo idk if the size ds will work
ENDM

