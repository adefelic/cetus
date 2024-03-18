INCLUDE "src/utils/structs.inc"

DEF BYTES_IN_DIALOG_LABEL EQU 12
DEF BYTES_IN_DIALOG_STRING EQU 14

	; todo rename to DialogEvent?
	struct RoomEvent
		bytes 1, EventWalls ; a 4-bit WALLS_ constant. this means that all events must be on the same wall
		bytes BYTES_IN_DIALOG_LABEL, EventLabelText ; string. this is the text that occurs before entering the event eg "talk?"
		bytes BYTES_IN_DIALOG_LABEL, EventPromptText ; string. this is the first event frame that precedes the player selecting an option eg "hello there"
		bytes 1, DialogBranchesCount
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
