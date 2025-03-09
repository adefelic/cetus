SECTION "Tile Data", ROMX, ALIGN[8]

;;; bg bank 0
BgBank0Tiles::
ExploreBGTiles::
INCBIN "build/gfx/bg-tiles.2bpp"
ExploreBGTilesEnd::

; todo, load env trees during the encounter or something more dynamic
EncounterEnvTreesTiles::
INCBIN "build/gfx/encounter-env-trees.2bpp"
EncounterEnvTreesTilesEnd::
BgBank0TilesEnd::

;;; bg bank 1
ScribTiles::
INCBIN "build/gfx/scrib.2bpp"
ScribTilesEnd::

;;; bg/obj bank 0

; npc tiles
NpcTiles::
NpcBrambleTiles::
INCBIN "build/gfx/npc/bramble.2bpp"
NpcOldBonesTiles::
INCBIN "build/gfx/npc/oldbones.2bpp"
NpcSunflowerTiles::
INCBIN "build/gfx/npc/sunflower.2bpp"
NpcButterflyTiles::
INCBIN "build/gfx/npc/butterfly.2bpp"
NpcScarecrowTiles::
INCBIN "build/gfx/npc/scarecrow.2bpp"

;; equipment tiles

; paper doll tiles
; weapon
EquipmentDefaultWeaponTiles::
EquipmentFlailTiles::
INCBIN "build/gfx/equipment/flail.2bpp"
; head
EquipmentDefaultHeadTiles::
EquipmentHelmFrogMouthTiles::
INCBIN "build/gfx/equipment/helm-frog-mouth.2bpp"
; body
EquipmentDefaultBodyTiles::
EquipmentSurcoatRootTiles::
INCBIN "build/gfx/equipment/surcoat-root.2bpp"
; legs
EquipmentDefaultLegTiles::
EquipmentLegWrappingsTiles::
INCBIN "build/gfx/equipment/leg-wrappings.2bpp"

; icon tiles
; weapon
IconFlailTiles::
INCBIN "build/gfx/icons/icon-flail.2bpp"
; head
IconHelmFrogMouthTiles::
INCBIN "build/gfx/icons/icon-flail.2bpp"
; body
IconSurcoatRootTiles::
INCBIN "build/gfx/icons/icon-flail.2bpp"
; legs
IconLegWrappingsTiles::
INCBIN "build/gfx/icons/icon-flail.2bpp"

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
