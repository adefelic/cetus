SECTION "Shadow BG Tilemap", WRAM0
wShadowTilemap::
ds TILEMAP_SIZE

SECTION "Shadow BG Tilemap Attrs", WRAM0
wShadowTilemapAttrs::
ds TILEMAP_SIZE

SECTION "Shadow OAM", WRAM0, ALIGN[0]
wShadowOam::
ds sizeof_OAM_ATTRS * OAM_COUNT
