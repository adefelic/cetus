INCLUDE "src/structs/locale.inc"

SECTION "Locale definitions", ROMX
	dstruct Locale, FieldLocale,  FieldWallBTiles, MusicTown, FieldBgPaletteSet,  FieldNpcs
	dstruct Locale, SwampLocale,  FieldWallBTiles, MusicRuin, SwampBgPaletteSet,  SwampNpcs
	dstruct Locale, TownLocale,   FieldWallBTiles, MusicTown, TownBgPaletteSet,   SwampNpcs
	dstruct Locale, CoastLocale,  FieldWallBTiles, MusicRuin, CoastBgPaletteSet,  SwampNpcs
	dstruct Locale, ForestLocale, FieldWallBTiles, MusicRuin, ForestBgPaletteSet, SwampNpcs
	dstruct Locale, RuinLocale,   FieldWallBTiles, MusicRuin, RuinBgPaletteSet,   SwampNpcs
