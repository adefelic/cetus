INCLUDE "src/lib/structs.inc"

	struct Locale
		bytes 1, LocaleId
		words 1, WallTilesAddr
		words 1, MusicAddr
		words 1, BgPaletteSetAddr
		words 1, EncountersTableAddr
		;bytes 1, EncountersTableSize
		; todo add title card string
	end_struct
