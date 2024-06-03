SECTION "Shadow OAM", WRAM0, ALIGN[8]
wShadowOam::
ds sizeof_OAM_ATTRS * OAM_COUNT
wShadowOamEnd::

SECTION "Shadow Background Tilemap", WRAM0
wShadowBackgroundTilemap::
ds VISIBLE_TILEMAP_SIZE
wShadowBackgroundTilemapEnd::

SECTION "Shadow Background Tilemap Attrs", WRAM0
wShadowBackgroundTilemapAttrs::
ds VISIBLE_TILEMAP_SIZE
wShadowBackgroundTilemapAttrsEnd::

; todo maybe rather than shadowing this we can actually update the tilemap
;   in realish time and then hit the switch to enable window
SECTION "Shadow Window Tilemap", WRAM0
wShadowWindowTilemap::
ds VISIBLE_TILEMAP_SIZE
wShadowWindowTilemapEnd::

SECTION "Shadow Window Tilemap Attrs", WRAM0
wShadowWindowTilemapAttrs::
ds VISIBLE_TILEMAP_SIZE
wShadowWindowTilemapAttrsEnd::

; fixme this is space inefficient and will need to be changed
SECTION "Item Map", WRAM0
wItemMap::
ds TILEMAP_SIZE
wItemMapEnd::
