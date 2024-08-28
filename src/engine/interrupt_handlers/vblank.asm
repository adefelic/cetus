INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

SECTION "VBlank HRAM", HRAM
	hLCDC:: db

SECTION "vblank handler stub", ROM0[$0040]
	push af
	ldh a, [hLCDC]
	ldh [rLCDC], a
	jp VBlankHandler

SECTION "vblank handler", ROM0
VBlankHandler:
	push bc
	push de
	push hl
	; todo only call what makes sense for the current screen?: exp/enc/pause
	call SetEnqueuedBgPaletteSet
	call SetEnqueuedEnemyBgPalette ; todo would it make more sense to consolidate all palette updates? this overwrites palette 6
	call CopyBgWallTilesIntoVram
	call CopyNpcSpriteTilesIntoVram
	call CopyShadowsToTilemapVram
	call CopyWeaponIconTilesIntoVram
	call CopyWeaponPaperDollTilesIntoVram
	call GetKeys
	pop hl
	pop de
	pop bc
	pop af
	reti

CopyNpcSpriteTilesIntoVram:
	ld a, [wDoesNpcSpriteTileDataNeedToBeCopiedIntoVram]
	and a
	ret nz
.gdmaTileData:
	; source
	ld a, [wNpcSpriteTilesRomAddr + 1]
	ldh [rHDMA1], a
	ld a, [wNpcSpriteTilesRomAddr]
	ldh [rHDMA2], a

	; dest
	ld a, HIGH(NPC_SPRITE_TILE_VRAM_ADDR)
	ldh [rHDMA3], a
	ld a, LOW(NPC_SPRITE_TILE_VRAM_ADDR)
	ldh [rHDMA4], a

	; size + enable
	ld a, HDMA5F_MODE_GP + (NPC_SPRITE_TILES_SIZE / 16) - 1 ; length (number of 16-byte blocks - 1) (240 bytes total ... / 16 = 15, minus 1 = 14 blocks)
	ld [rHDMA5], a ; begin dma transfer

	ld a, FALSE
	ld [wDoesNpcSpriteTileDataNeedToBeCopiedIntoVram], a

	ld bc, NPC_SPRITE_TILES_SIZE * 2 + 4
.waitforDmaToFinish: ; necessary?
    dec bc
    jr nz, .waitforDmaToFinish

	ret

CopyBgWallTilesIntoVram:
	ld a, [wDoesBgWallTileDataNeedToBeCopiedIntoVram]
	and a
	ret nz
.gdmaTileData:
	; source
	ld a, [wCurrentWallTilesAddr + 1]
	ldh [rHDMA1], a
	ld a, [wCurrentWallTilesAddr]
	ldh [rHDMA2], a

	; dest
	ld a, HIGH(WALL_TILES_VRAM_ADDR)
	ldh [rHDMA3], a
	ld a, LOW(WALL_TILES_VRAM_ADDR)
	ldh [rHDMA4], a

	; size + enable
	; set bank 1
	ld a, 1
	ld [rVBK], a
	ld a, HDMA5F_MODE_GP + (WALL_TILES_SIZE / 16) - 1 ; length (number of 16-byte blocks - 1) (64 tiles = 1024 bytes total ... / 16 = 64, minus 1 = 63 blocks)
	ld [rHDMA5], a ; begin dma transfer

	ld a, FALSE
	ld [wDoesBgWallTileDataNeedToBeCopiedIntoVram], a

	ld bc, WALL_TILES_SIZE * 2 + 4
.waitforDmaToFinish: ; necessary?
    dec bc
    jr nz, .waitforDmaToFinish
	; set bank 0
	xor a
	ld [rVBK], a
	ret

CopyWeaponIconTilesIntoVram:
	ld a, [wDoesWeaponIconTileDataNeedToBeCopiedIntoVram]
	and a
	ret nz
.gdmaTileData:
	; source
	ld a, [wEquippedWeaponIconTiles + 1]
	ldh [rHDMA1], a
	ld a, [wEquippedWeaponIconTiles]
	ldh [rHDMA2], a

	; dest
	ld a, HIGH(WEAPON_ICON_VRAM_ADDR)
	ldh [rHDMA3], a
	ld a, LOW(WEAPON_ICON_VRAM_ADDR)
	ldh [rHDMA4], a

	; size + enable
	ld a, HDMA5F_MODE_GP + EQUIPMENT_ICON_TILES - 1 ; length in tiles, - 1
	ld [rHDMA5], a ; begin dma transfer

	ld a, FALSE
	ld [wDoesWeaponIconTileDataNeedToBeCopiedIntoVram], a

	ld bc, EQUIPMENT_ICON_SIZE * 2 + 4
.waitforDmaToFinish: ; necessary?
    dec bc
    jr nz, .waitforDmaToFinish
	ret

CopyWeaponPaperDollTilesIntoVram:
	ld a, [wDoesWeaponPaperDollTileDataNeedToBeCopiedIntoVram]
	and a
	ret nz
.gdmaTileData:
	; source
	ld a, [wEquippedWeaponPaperDollTiles + 1]
	ldh [rHDMA1], a
	ld a, [wEquippedWeaponPaperDollTiles]
	ldh [rHDMA2], a

	; dest
	ld a, HIGH(PAPER_DOLL_WEAPON_VRAM_ADDR)
	ldh [rHDMA3], a
	ld a, LOW(PAPER_DOLL_WEAPON_VRAM_ADDR)
	ldh [rHDMA4], a

	; size + enable
	ld a, HDMA5F_MODE_GP + PAPER_DOLL_WEAPON_TILES - 1 ; length in tiles, - 1
	ld [rHDMA5], a ; begin dma transfer

	ld a, FALSE
	ld [wDoesWeaponPaperDollTileDataNeedToBeCopiedIntoVram], a

	ld bc, PAPER_DOLL_WEAPON_TILES * 2 + 4
.waitforDmaToFinish: ; necessary?
    dec bc
    jr nz, .waitforDmaToFinish
	ret

; dma copy shadow ram to VRAM
CopyShadowsToTilemapVram::
.copyShadowTilemapIntoVram
	; select vram bank 0
	xor a
	ld [rVBK], a
	ld hl, wShadowBackgroundTilemap
	call GdmaShadowTilemapToVram
.copyShadowTilemapAttrsIntoVram
	; select vram bank 1
	ld a, 1
	ld [rVBK], a
	ld hl, wShadowBackgroundTilemapAttrs
	call GdmaShadowTilemapToVram
	; select vram bank 0.
	xor a
	ld [rVBK], a
.copyShadowOamIntoOam
	ld hl, wShadowOam
	call RunDma
.clean ; necessary?
	ld a, FALSE
	ld [wIsShadowTilemapDirty], a
	ret

; @param hl, src shadow tilemap to copy
GdmaShadowTilemapToVram:
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld hl, TILEMAP_BACKGROUND
	ld a, h
	ldh [rHDMA3], a
	ld a, l
	ldh [rHDMA4], a
	ld a, HDMA5F_MODE_GP + (VISIBLE_TILEMAP_SIZE / 16) - 1 ; length (number of 16-byte blocks - 1) (63 bytes, $10 * 4)
	ld [rHDMA5], a ; begin dma transfer
	ld bc, VISIBLE_TILEMAP_SIZE * 2 + 4
.waitforDmaToFinish: ; necessary?
    dec bc
    jr nz, .waitforDmaToFinish
    ret

; @param hl, source address, zero-aligned
RunDma:
    ld a, HIGH(hl)
    ldh [$FF46], a  ; start DMA transfer (starts right after instruction)
    ld a, 40        ; delay for a total of 4×40 = 160 cycles
.wait
    dec a           ; 1 cycle
    jr nz, .wait    ; 3 cycles
    ret
