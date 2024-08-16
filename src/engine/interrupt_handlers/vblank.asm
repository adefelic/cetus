INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"

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
	call SetEnqueuedBgPaletteSet
	call SetEnqueuedEnemyBgPalette ; todo would it make more sense to consolidate all palette updates? this overwrites palette 6
	call CopyBgWallTilesIntoVram
	call CopyNpcSpriteTilesIntoVram
	call CopyShadowsToVram
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
	ret

CopyBgWallTilesIntoVram:
	ld a, [wDoesBgWallTileDataNeedToBeCopiedIntoVram]
	and a
	ret nz
.gdmaTileData:
	;ld hl, wCurrentWallTilesAddr
	;call DereferenceHlIntoHl

	; source
	ld a, [wCurrentWallTilesAddr + 1]
	ldh [rHDMA1], a
	ld a, [wCurrentWallTilesAddr]
	ldh [rHDMA2], a

	; dest
	ld a, HIGH(VRAM_BOTH_BLOCK)
	ldh [rHDMA3], a
	ld a, LOW(VRAM_BOTH_BLOCK)
	ldh [rHDMA4], a

	; size + enable
	; set bank 1
	ld a, 1
	ld [rVBK], a
	ld a, HDMA5F_MODE_GP + (WALL_TILES_SIZE / 16) - 1 ; length (number of 16-byte blocks - 1) (64 tiles = 1024 bytes total ... / 16 = 64, minus 1 = 63 blocks)
	ld [rHDMA5], a ; begin dma transfer
	; set bank 0
	ld a, 0
	ld [rVBK], a

	ld a, FALSE
	ld [wDoesBgWallTileDataNeedToBeCopiedIntoVram], a
	ret

