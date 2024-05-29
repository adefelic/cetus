SECTION "Shadow OAM", WRAM0, ALIGN[8]
wShadowOam::
ds sizeof_OAM_ATTRS * OAM_COUNT
wShadowOamEnd::

SECTION "Shadow BG Tilemap", WRAM0
wShadowTilemap::
ds VISIBLE_TILEMAP_SIZE
wShadowTilemapEnd::

SECTION "Shadow BG Tilemap Attrs", WRAM0
wShadowTilemapAttrs::
ds VISIBLE_TILEMAP_SIZE
wShadowTilemapAttrsEnd::

; fixme this is space inefficient and will need to be changed
SECTION "Item Map", WRAM0
wItemMap::
ds TILEMAP_SIZE
wItemMapEnd::
