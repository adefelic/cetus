INCLUDE "src/lib/structs.inc"

	struct Locale
		words 1, WallTilesAddr
		bytes 1, WallTilesBank
		words 1, MusicAddr
		bytes 1, MusicBank
		words 1, BgPaletteSetAddr
		words 1, EncountersTableAddr
		;bytes 1, EncountersTableSize
		; todo add title card string
	end_struct
