SECTION "Tile Data", ROMX, ALIGN[8]

;;; bg bank 0
BgBank0Tiles::
ExploreBGTiles::
INCBIN "build/gfx/bg-tiles.2bpp"
ExploreBGTilesEnd::
EncounterEnvTreesTiles::
INCBIN "build/gfx/encounter-env-trees.2bpp"
EncounterEnvTreesTilesEnd::
BgBank0TilesEnd::

;;; bg bank 1
ScribTiles::
INCBIN "build/gfx/scrib.2bpp"
ScribTilesEnd::

;;; bg/obj bank 0
NpcBrambleTiles::
INCBIN "build/gfx/npc/bramble.2bpp"
NpcOldBonesTiles::
INCBIN "build/gfx/npc/oldbones.2bpp"

;;; bg/obj bank 1
FieldWallBTiles::
INCBIN "build/gfx/wall-b-tiles.2bpp"

;;; obj bank 0
CompassTiles::
INCBIN "build/gfx/compass.2bpp"
CompassTilesEnd::
DangerIndicatorTiles::
INCBIN "build/gfx/danger-indicator.2bpp"
DangerIndicatorTilesEnd::
ItemTiles::
INCBIN "build/gfx/item-tiles.2bpp"
ItemTilesEnd::
