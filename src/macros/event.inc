INCLUDE "src/utils/structs.inc"

	; todo rename to DialogEvent?
	struct RoomEvent
		bytes 1, EventWalls ; a 4-bit WALLS_ constant. this means that all events must be on the same wall
		bytes 12, EventLabelText ; string. this is the text that occurs before entering the event eg "talk?"
		bytes 12, EventPromptText ; string. this is the first event frame that precedes the player selecting an option eg "hello there"
		bytes 1, DialogBranchesCount
		words 1, DialogBranchesAddr ; a collection of DialogBranches that is (DialogBranchCount * sizeof_DialogBranch) many bytes
	end_struct

	; subsequent DialogBranches must be contiguous in memory
	struct DialogBranch
		words 1, IsVisibleFlagAddr
		bytes 14, DialogBranchLabel ; string. this text is displayed in the dialog option menu
		bytes 1, DialogBranchFramesCount
		words 1, DialogBranchFramesAddr ; a collection of contiguous DialogBranchFrames that is (EventCount * sizeof_Event) many bytes
	end_struct

	; subsequent DialogBranchFrames must be contiguous in memory
	struct DialogBranchFrame
		words 1, SpriteAddr
		bytes 1, ItemGetOnCompletion ; 0 = no item
		words 1, FlagSetOnCompletion ; 0 = no flag
		bytes 14, TextLine0 ; string
		bytes 14, TextLine1 ; string
		bytes 14, TextLine2 ; string
		bytes 14, TextLine3 ; string
	end_struct
