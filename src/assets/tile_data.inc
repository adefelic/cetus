SECTION "Tile Data", ROMX

; bg bank 0
OWTiles::
INCBIN "build/gfx/explore-simple.2bpp"
OWTilesEnd::

ModalTiles::
INCBIN "build/gfx/modal-simple.2bpp"
ModalTilesEnd::

EncounterTiles::
INCBIN "build/gfx/encounter-simple.2bpp"
EncounterTilesEnd::

; this is the big image version of fog
FogTiles::
INCBIN "build/gfx/fog.2bpp"
FogTilesEnd::

; this is the lightweight one
DistanceFogTiles::
INCBIN "build/gfx/distance-fog.2bpp"
DistanceFogTilesEnd::

; bg bank 1
ComputerDarkTiles::
INCBIN "build/gfx/computer-dark.2bpp"
ComputerDarkTilesEnd::

ScribTiles::
INCBIN "build/gfx/scrib.2bpp"
ScribTilesEnd::

; sprites bank 0
CompassTiles::
INCBIN "build/gfx/compass.2bpp"
CompassTilesEnd::

DangerIndicatorTiles::
INCBIN "build/gfx/danger-indicator.2bpp"
DangerIndicatorTilesEnd::

ChinchillaTiles::
INCBIN "build/gfx/chinchilla.2bpp"
ChinchillaTilesEnd::

ItemTiles::
INCBIN "build/gfx/item-tiles.2bpp"
ItemTilesEnd::
