INCLUDE "src/constants/locale_constants.inc"
INCLUDE "src/structs/locale.inc"

; todo deprecate LOCALE ids
SECTION "Locale definitions", ROMX
	dstruct Locale, FieldLocale, LOCALE_FIELD, FieldWallBTiles, MusicSwamp, ForestBgPaletteSet, FieldNpcs
	dstruct Locale, SwampLocale, LOCALE_SWAMP, FieldWallBTiles, MusicSwamp, SwampBgPaletteSet, SwampNpcs
