SECTION "Shadow BG Tilemap", WRAM0
wShadowTilemap::
ds TILEMAP_SIZE
wShadowTilemapEnd::

SECTION "Shadow BG Tilemap Attrs", WRAM0
wShadowTilemapAttrs::
ds TILEMAP_SIZE
wShadowTilemapAttrsEnd::

SECTION "Shadow OAM", WRAM0, ALIGN[0]
wShadowOam::
ds sizeof_OAM_ATTRS * OAM_COUNT
wShadowOamEnd::

; fixme this is very inefficient and will need to be changed
SECTION "Item Map", WRAM0
wItemMap::
ds TILEMAP_SIZE
wItemMapEnd::
