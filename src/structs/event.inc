INCLUDE "src/lib/structs.inc"
INCLUDE "src/constants/menu_constants.inc"

; RoomEvent Types
DEF ROOMEVENT_DIALOG EQU $00
DEF ROOMEVENT_WARP EQU $01

; todo? augh i should've just made it so the first byte of every collection is the count
; it would mean that a collection can't be more than 255 things but that seems fine

	struct RoomEvent
		bytes 1, EventWalls ; a 4-bit WALLS_ constant. this means that all events must be on the same wall
		bytes BYTES_IN_DIALOG_LABEL, EventLabelText ; string. this is the text that occurs before entering the event eg "talk?"
		bytes BYTES_IN_DIALOG_LABEL, EventPromptText ; string. this is the header line of text that goes in the first ui row
		bytes 1, Type
		bytes 1, DialogBranchesCount ; unused

		alias WarpDestinationAddr ; if the event type is ROOMEVENT_WARP, this points to the corresponding WarpDestination
		words 1, DialogBranchesAddr ; a collection of DialogBranches that is (DialogBranchCount * sizeof_DialogBranch) many bytes
	end_struct

	; subsequent DialogBranches must be contiguous in memory
	struct DialogBranch
		words 1, IsVisibleFlagAddr
		bytes BYTES_IN_DIALOG_STRING, Label ; string. this text is displayed in the dialog option menu
		bytes 1, FramesCount
		words 1, FramesAddr ; a collection of contiguous DialogBranchFrames that is (EventCount * sizeof_Event) many bytes
	end_struct

	; subsequent DialogBranchFrames must be contiguous in memory
	struct DialogBranchFrame
		words 1, SpriteAddr
		bytes 1, ItemGetOnCompletion ; 0 = no item
		words 1, FlagSetOnCompletion ; 0 = no flag
		bytes BYTES_IN_DIALOG_STRING, TextLine0 ; string
		bytes BYTES_IN_DIALOG_STRING, TextLine1 ; string
		bytes BYTES_IN_DIALOG_STRING, TextLine2 ; string
		bytes BYTES_IN_DIALOG_STRING, TextLine3 ; string
	end_struct

	struct WarpDestination
		bytes 1, DestinationX
		bytes 1, DestinationY
		bytes 1, DestinationOrientation
		words 1, BgPaletteSetAddr
	end_struct
