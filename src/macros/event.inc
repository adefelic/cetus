INCLUDE "src/utils/structs.inc"

DEF ET_WALLS_OFFSET EQU $00
DEF ET_TYPE_OFFSET EQU $01
DEF ET_DEF_OFFSET EQU $02
MACRO event_trigger
	assert _NARG == 3, "event_trigger must have exactly 3 arguments"
	db \1 ; event walls ; which walls can be interacted with to trigger the event
	db \2 ; event_type; 0 = warp, 1 = dialog, 2 = storefront ...
	dw \3 ; addr of event definition
	; todo:  	db \4 ; flag: player control lock?
	; todo?:    db \5 ; # of lines tall. this will probably be an event style.
	;                   like small box top or big box bottom + sprite
ENDM

; this could be cut down quite a bit
; upon pressing A at the end of the event frames, the player is moved to the location described
DEF ED_MAP_OFFSET EQU $03
MACRO event_def_type_warp
	assert _NARG == 6, "event_type_warp must have exactly 6 arguments"
	db \1 ; # of frames. there must be at least 1
	; todo: type of event frame. label or dialog
	dw \2 ; address of event_frames
	db \3 ; warp dest map
	db \4 ; warp dest x
	db \5 ; warp dest y
	db \6 ; warp dest orientation
ENDM

DEF EVENT_FRAME_SIMPLE_SIZE EQU $0A
MACRO event_frame_simple
	assert _NARG == 1, "event_frame must have exactly 1 arguments"
	db \1 ; this needs to be only 10 bytes
	; ds NAME_BUF_LEN - charlen("\1") this should work
ENDM

DEF EVENT_FRAME_SIZE EQU $20
MACRO event_frame
	assert _NARG == 3, "event_frame must have exactly 4 arguments"
	dw \1 ; addr of sprite
	ds 10, \2 ; text to display
	ds 10, \3 ; text to display
	ds 10, \4 ; text to display
ENDM

; new kind of events that uses structs
	; todo rename to DialogEvent?
	struct RoomEvent
		bytes 1, EventWalls ; a 4-bit WALLS_ constant. this means that all events must be on the same wall
		bytes 12, EventLabelText ; string. this is the text that occurs before entering the event eg "talk?"
		bytes 12, EventPromptText ; string. this is the first event frame that precedes the player selecting an option eg "hello there"
		bytes 1, DialogOptionsSize
		words 1, DialogOptionsAddr ; a collection of DialogOptions that is (DialogOptionCount * sizeof_DialogOption) many bytes
	end_struct

	; subsequent DialogOptions must be contiguous in memory
	struct DialogOption
		words 1, IsVisibleFlagAddr
		bytes 14, DialogOptionLabel ; string. this text is displayed in the dialog option menu
		bytes 1, DialogOptionFramesSize
		words 1, DialogOptionFramesAddr ; a collection of contiguous DialogOptionFrames that is (EventCount * sizeof_Event) many bytes
	end_struct

	; subsequent DialogOptionFrames must be contiguous in memory
	struct DialogOptionFrame
		words 1, SpriteAddr
		bytes 1, ItemGetOnCompletion ; 0 = no item
		words 1, FlagSetOnCompletion ; 0 = no flag
		bytes 14, TextLine0 ; string
		bytes 14, TextLine1 ; string
		bytes 14, TextLine2 ; string
		bytes 14, TextLine3 ; string
	end_struct
