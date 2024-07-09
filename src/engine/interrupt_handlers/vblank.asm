INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/npc_constants.inc"

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
	call CopyEnqueuedNpcSpriteTilesIntoVram
	call CopyShadowsToVram
	call GetKeys
	pop hl
	pop de
	pop bc
	pop af
	reti

CopyEnqueuedNpcSpriteTilesIntoVram:
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
