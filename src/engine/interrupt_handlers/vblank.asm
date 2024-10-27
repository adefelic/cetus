INCLUDE "src/lib/hardware.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/assets/tiles/indices/bg_tiles.inc"

macro gdmaSmall
	; source
	ld a, [hli]
	ldh [rHDMA2], a
	ld a, [hl]
	ldh [rHDMA1], a

	; dest
	ld a, HIGH(DEST)
	ldh [rHDMA3], a
	ld a, LOW(DEST)
	ldh [rHDMA4], a

	; size + enable
	ld a, HDMA5F_MODE_GP + SIZE_TILES - 1 ; length in tiles, - 1
	ld [rHDMA5], a ; begin dma transfer
	ld bc, SIZE_TILES * 2 + 4
	.waitforDmaToFinish: ; necessary?
	dec bc
	jr nz, .waitforDmaToFinish
endm

SECTION "VBlank HRAM", HRAM
	hLCDC:: db

SECTION "vblank handler stub", ROM0[$0040]
	push af
	ldh a, [hLCDC]
	ldh [rLCDC], a
	jp VBlankHandler

SECTION "vblank handler", ROM0
VBlankHandler:
	;ret ; zzz
	push bc
	push de
	push hl
.updatePalettes
	; explore
	;ld a, BANK(SetEnqueuedBgPaletteSet)
	;ld [rROMB0], a
	call SetEnqueuedBgPaletteSet
	; encounter
	;ld a, BANK(SetEnqueuedEnemyBgPalette)
	;ld [rROMB0], a
	call SetEnqueuedEnemyBgPalette ; todo would it make more sense to consolidate all palette updates? this overwrites palette 6
.updateTiles
	; explore
	call CopyBgWallTilesIntoVram
	; encounter
	call CopyNpcSpriteTilesIntoVram
	; pause
	call CopyWeaponIconTilesIntoVram
	call CopyHeadPaperDollTilesIntoVram
	call CopyBodyPaperDollTilesIntoVram
	call CopyLegsPaperDollTilesIntoVram
	call CopyWeaponPaperDollTilesIntoVram
.updateTilemap
	call CopyShadowsToTilemapVram
	call GetKeys
	pop hl
	pop de
	pop bc
	pop af
	reti

CopyNpcSpriteTilesIntoVram:
	ld a, [wNpcSpriteTilesReadyForVramWrite]
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
	ld [wNpcSpriteTilesReadyForVramWrite], a

	ld bc, NPC_SPRITE_TILES_SIZE * 2 + 4
.waitforDmaToFinish: ; necessary?
	dec bc
	jr nz, .waitforDmaToFinish

	ret

CopyBgWallTilesIntoVram:
	ld a, [wBgWallTilesReadyForVramWrite]
	and a
	ret nz

	ld hl, wCurrentWallTilesAddr
	; hmm there are some warnings here ...
	DEF DEST = WALL_TILES_VRAM_ADDR
	DEF SIZE_TILES = strfmt("${WALL_TILES_SIZE}")
	gdmaSmall

	ld a, FALSE
	ld [wBgWallTilesReadyForVramWrite], a
	ret

CopyWeaponIconTilesIntoVram:
	ld a, [wWeaponIconTilesReadyForVramWrite]
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
	ld [wWeaponIconTilesReadyForVramWrite], a

	ld bc, EQUIPMENT_ICON_SIZE * 2 + 4
.waitforDmaToFinish: ; necessary?
	dec bc
	jr nz, .waitforDmaToFinish
	ret

CopyWeaponPaperDollTilesIntoVram:
	ld a, [wWeaponPaperDollTilesReadyForVramWrite]
	and a
	ret nz

	; set bank 1
	ld a, 1
	ld [rVBK], a

	ld hl, wEquippedWeaponPaperDollTiles
	DEF DEST = PAPER_DOLL_WEAPON_VRAM_ADDR
	DEF SIZE_TILES = PAPER_DOLL_WEAPON_TILES
	gdmaSmall

	; set bank 0
	xor a
	ld [rVBK], a

	ld a, FALSE
	ld [wWeaponPaperDollTilesReadyForVramWrite], a
	ret

CopyHeadPaperDollTilesIntoVram:
	ld a, [wHeadPaperDollTilesReadyForVramWrite]
	and a
	ret nz

	; set bank 1
	ld a, 1
	ld [rVBK], a

	ld hl, wEquippedHeadPaperDollTiles
	DEF DEST = PAPER_DOLL_HEAD_VRAM_ADDR
	DEF SIZE_TILES = PAPER_DOLL_HEAD_TILES
	gdmaSmall

	; set bank 0
	xor a
	ld [rVBK], a

	ld a, FALSE
	ld [wHeadPaperDollTilesReadyForVramWrite], a
	ret

CopyBodyPaperDollTilesIntoVram:
	ld a, [wBodyPaperDollTilesReadyForVramWrite]
	and a
	ret nz

	; set bank 1
	ld a, 1
	ld [rVBK], a

	ld hl, wEquippedBodyPaperDollTiles
	DEF DEST = PAPER_DOLL_BODY_VRAM_ADDR
	DEF SIZE_TILES = PAPER_DOLL_BODY_TILES
	gdmaSmall

	; set bank 0
	xor a
	ld [rVBK], a

	ld a, FALSE
	ld [wBodyPaperDollTilesReadyForVramWrite], a
	ret

CopyLegsPaperDollTilesIntoVram:
	ld a, [wLegsPaperDollTilesReadyForVramWrite]
	and a
	ret nz

	; set bank 1
	ld a, 1
	ld [rVBK], a

	ld hl, wEquippedLegsPaperDollTiles
	DEF DEST = PAPER_DOLL_LEGS_VRAM_ADDR
	DEF SIZE_TILES = PAPER_DOLL_LEGS_TILES
	gdmaSmall

	; set bank 0
	xor a
	ld [rVBK], a

	ld a, FALSE
	ld [wLegsPaperDollTilesReadyForVramWrite], a
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
