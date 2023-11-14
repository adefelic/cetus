INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/map_data.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/gfx_constants.inc"

Section "Game State", WRAM0
wPlayerX:: db
wPlayerY:: db
wPlayerOrientation:: db
wGameState:: db ; this could be a single bit
wScreenDirty:: db ; this could be a single bit

SECTION "Input Variables", WRAM0
wCurKeys: db
wNewKeys: db

SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; make room for the header

EntryPoint:
	; don't turn off the lcd outside of VBlank
	call WaitVBlank
	; turn the LCD off. the screen must be off to safely access VRAM and OAM
	call DisableLcd

	; Copy BG tile data into VRAM
	ld de, Tiles            ; source in ROM
	ld hl, _VRAM9000        ; dest in VRAM
	ld bc, TilesEnd - Tiles ; # of bytes (pixel data) remaining
	call Memcopy

	; Copy BG tilemap into VRAM
	ld de, MapTilemap                 ; source in ROM
	ld hl, _SCRN0                     ; dest in VRAM
	ld bc, MapTilemapEnd - MapTilemap ; # of bytes (tile indices) remaining
	call Memcopy

	; Init a color palette
	call InitColorPalette0

	call CopyDMARoutine

	ld a, 0        ; value to write to bytes
	ld b, 160      ; # of bytes to write
	ld hl, _OAMRAM ; dest
ClearOam:
	ld [hli], a
	dec b
	jp nz, ClearOam

InitGameState:
	ld a, 3
	ld [wPlayerX], a
	ld a, 1
	ld [wPlayerY], a
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a

	ld a, GAME_UNPAUSED
	ld [wGameState], a

	ld a, DIRTY
	ld [wScreenDirty], a
	call DirtyFPScreen

; todo set sane defaults
;wCurrentCenterNearWallAttrs
;wCurrentLeftNearWallAttrs
;wCurrentRightNearWallAttrs
;wCurrentCenterFarWallAttrs
;wCurrentLeftFarWallAttrs
;wCurrentRightFarWallAttrs
;wPreviousCenterNearWallAttrs
;wPreviousLeftNearWallAttrs
;wPreviousRightNearWallAttrs
;wPreviousCenterFarWallAttrs
;wPreviousLeftFarWallAttrs
;wPreviousRightFarWallAttrs

	call EnableLcd

Main:
	;call WaitVBlank
	call UpdateKeys ; gets new player input
	call CheckKeysAndUpdateGameState ; processes input, sets dirty flags
	call UpdateScreen ; draws screen to shadow tilemap, cleans dirty flags

	; draw screen
	call WaitVBlank
	ld hl, wShadowTilemap
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld hl, _SCRN0
	ld a, h
	ldh [rHDMA3], a
	ld a, l
	ldh [rHDMA4], a
	ld a, HDMA5F_MODE_GP + (TILEMAP_SIZE / 16) - 1 ; length (number of 16-byte blocks - 1)
	call hTilemapDMA
	jp Main

; -- draw screen
UpdateScreen:
	ld a, [wScreenDirty] ; determines drawing
	cp DIRTY
	ret nz
	ld a, [wGameState]
	cp a, GAME_PAUSED
	jp nz, DrawFPScreen
DrawPauseScreen:
	call LoadPauseScreenTilemap
	jp CleanScreen
DrawFPScreen:
	call LoadShadowFPTilemapByMapTile
CleanScreen:
	ld a, CLEAN
	ld [wScreenDirty], a
	ret

; -- update state
; this will handle one button input then quit
CheckKeysAndUpdateGameState:
CheckPressedStart:
	ld a, [wNewKeys]
	and a, PADF_START
	jp nz, HandleStart
CheckPressedSelect:
CheckPressedA:
CheckPressedB:
CheckPressedUp:
	ld a, [wNewKeys]
	and a, PADF_UP
	jp nz, HandleUp
CheckPressedDown:
	ld a, [wNewKeys]
	and a, PADF_DOWN
	jp nz, HandleDown
CheckPressedLeft:
	ld a, [wNewKeys]
	and a, PADF_LEFT
	jp nz, HandleLeft
CheckPressedRight:
	ld a, [wNewKeys]
	and a, PADF_RIGHT
	jp nz, HandleRight
	ret

; pause screen contains automap
LoadPauseScreenTilemap:
	ld de, MapTilemap ; source in ROM
	ld hl, wShadowTilemap     ; dest in VRAM
	ld bc, MapTilemapEnd - MapTilemap ; # of bytes (tile indices) remaining
	;call DisableLcd
	call Memcopy
	ld a, GAME_PAUSED
	ld [wGameState], a
	;call EnableLcd
	ret

InitBGTileMapAttributes:
	ld a, 1
	ld [rVBK], a ; select VRAM bank 1

InitColorPalette0:
	ld a, BCPSF_AUTOINC ; load bg color palette specification auto increment on write + addr of zero
	ld [rBCPS], a

	ld de, ColorPalette0 ; source in ROM
	ld bc, ColorPalette0End - ColorPalette0 ; # of bytes (tile indices) remaining
	call WriteColorsToPalette
	ret

UpdateKeys:
	; poll controller buttons
	ld a, P1F_GET_BTN
	call .onenibble
	ld b, a ; b3-0 are button input, b7-4 are 1s

	; poll controller dpad
	ld a, P1F_GET_DPAD
	call .onenibble
	swap a ; a7-4 are dpad input, a3-0 are 1s

	; input is active low so we xor with 1s to check for input
	xor a, b ; a7-4 are dpad input, a3-0 are button input
	ld b, a

	; release the controller
	ld a, P1F_GET_NONE
	ldh [rP1], a

	; combine with previous wCurKeys to make wNewKeys
	ld a, [wCurKeys]
	xor a, b ; a = keys that changed state
	and a, b ; a = keys that changes state to pressed
	ld [wNewKeys], a
	ld a, b
	ld [wCurKeys], a
	ret
.onenibble ; load nibble into a
	ldh [rP1], a ; switch the key matrix. why hram?
	call .knownret ; burn 10 cycles
	ldh a, [rP1] ; ignore value while waiting for key matrix to settle
	ldh a, [rP1]
	ldh a, [rP1] ; this read counts
	or a, $F0 ; mask out top nibble
.knownret
	ret

; copy bytes from one area to another
; @param de: source
; @param hl: destination
; @param bc: length
Memcopy::
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jp nz, Memcopy
	ret

; @param de: source (must be multiple of 2 bytes, color defs are 2 bytes)
; @param bc: length in bytes
WriteColorsToPalette:
	ld a, [de]
	ld [rBCPD], a
	inc de
	dec bc
	ld a, b
	or c
	jp nz, WriteColorsToPalette
	ret

WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank
	ret

DisableLcd::
	ld a, 0
	ld [rLCDC], a
	ret

EnableLcd::
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
	ld [rLCDC], a
	ret

SECTION "Tilemap DMA Routine ROM", ROM0
CopyDMARoutine:
  ld de, DMARoutine
  ld bc, DMARoutineEnd - DMARoutine ; Number of bytes to copy
  ld hl, hTilemapDMA
  call Memcopy

DMARoutine:
	ld [rHDMA5], a
	ret
DMARoutineEnd:


SECTION "Tilemap DMA Routine HRAM", HRAM

hTilemapDMA::
	ds DMARoutineEnd - DMARoutine ; Reserve space to copy the routine to

