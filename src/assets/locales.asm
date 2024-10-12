INCLUDE "src/structs/locale.inc"

SECTION "Locale definitions", ROMX
	dstruct Locale, FieldLocale,  FieldWallBTiles, xMusicTown, FieldBgPaletteSet,  FieldNpcs
	dstruct Locale, SwampLocale,  FieldWallBTiles, XMusicRuin, SwampBgPaletteSet,  SwampNpcs
	dstruct Locale, TownLocale,   FieldWallBTiles, xMusicTown, TownBgPaletteSet,   SwampNpcs
	dstruct Locale, CoastLocale,  FieldWallBTiles, XMusicRuin, CoastBgPaletteSet,  SwampNpcs
	dstruct Locale, ForestLocale, FieldWallBTiles, XMusicRuin, ForestBgPaletteSet, SwampNpcs
	dstruct Locale, RuinLocale,   FieldWallBTiles, XMusicRuin, RuinBgPaletteSet,   SwampNpcs
