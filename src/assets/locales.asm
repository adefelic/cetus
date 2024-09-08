INCLUDE "src/structs/locale.inc"

SECTION "Locale definitions", ROMX
	dstruct Locale, FieldLocale,  FieldWallBTiles, MusicSwamp, FieldBgPaletteSet, FieldNpcs
	dstruct Locale, SwampLocale,  FieldWallBTiles, MusicSwamp, SwampBgPaletteSet,  SwampNpcs
	dstruct Locale, TownLocale,   FieldWallBTiles, MusicSwamp, TownBgPaletteSet,   SwampNpcs
	dstruct Locale, CoastLocale,  FieldWallBTiles, MusicSwamp, CoastBgPaletteSet,  SwampNpcs
	dstruct Locale, ForestLocale, FieldWallBTiles, MusicSwamp, ForestBgPaletteSet, SwampNpcs
	dstruct Locale, RuinLocale,   FieldWallBTiles, MusicSwamp, RuinBgPaletteSet,   SwampNpcs
