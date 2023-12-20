INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/palette.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/map_constants.inc"

Section "Game State", WRAM0
wActiveScreen:: db
wActiveMap:: dw

Section "Player State", WRAM0
wPlayerX:: db
wPlayerY:: db
wPlayerOrientation:: db

Section "Screen Variables", WRAM0
wIsShadowTilemapDirty:: db
wHasPlayerMovedThisFrame:: db ; rotating counts
; todo rendering experiments
; wShadowTilemapTopLeftX:: db
; wShadowTilemapTopLeftY:: db

; pokemon crystal stores these in hram
SECTION "Input Variables", WRAM0
wPreviousFrameKeys: db
wCurrentFrameKeys: db
wJoypadDown: db
wJoypadNewlyPressed: db
wJoypadNewlyReleased: db

; hardware interrupts
SECTION "vblank", ROM0[$0040]
	;jp VBlank

SECTION "lcd", ROM0[$0048]
	;jp LCD

SECTION "timer", ROM0[$0050]
	;jp TimerInterruptHandler

SECTION "serial", ROM0[$0058]
	;jp Serial

SECTION "joypad", ROM0[$0060]
	;jp Joypad

SECTION "Header", ROM0[$100]

	nop
	jp EntryPoint

	; rgbfix is going to overwrite this region

	ds $150 - @, 0 ; make room for the header

EntryPoint:
	; don't turn off the lcd outside of VBlank
	call WaitVBlank
	call DisableLcd

	; Copy BG tile data into VRAM
	ld de, OWTiles              ; source in ROM
	ld hl, _VRAM9000            ; dest in VRAM
	ld bc, OWTilesEnd - OWTiles ; # of bytes (pixel data) remaining
	call Memcopy

	call InitOWColorPalettes

ClearOam:
	xor a          ; value to write to bytes
	ld b, 160      ; # of bytes to write
	ld hl, _OAMRAM ; dest
.loop:
	ld [hli], a
	dec b
	jp nz, .loop

ClearShadowTilemap:
	ld bc, TILEMAP_SIZE
	ld hl, wShadowTilemap
.loop:
	ld [hli], a
	dec bc
	jp nz, .loop

ClearShadowTilemapAttrs:
	ld bc, TILEMAP_SIZE
	ld hl, wShadowTilemapAttrs
.loop:
	ld [hli], a
	dec bc
	jp nz, .loop

InitGameState:
	ld hl, Map1Walls
	ld a, h
	ld [wActiveMap], a
	ld a, l
	ld [wActiveMap+1], a

	call InitEventState

	; init input
	xor a
	ld [wJoypadDown], a
	ld [wJoypadNewlyReleased], a
	ld [wJoypadNewlyReleased], a

	ld a, FALSE
	ld [wHasPlayerMovedThisFrame], a

	; init player state
	;call InitPlayerLocation
	ld a, 3
	ld [wPlayerX], a
	ld a, 1
	ld [wPlayerY], a
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a

	; init game state
	ld a, FP_SCREEN
	ld [wActiveScreen], a

	; init screen state
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	call DirtyFpSegments
	call UpdateShadowBGTilemap

	call InitAudio
	call EnableLcd

Main:
	ld a, FALSE
	ld [wHasPlayerMovedThisFrame], a

	; todo could move this all into the vblank handler
	call WaitVBlank ; this (sort of) ensures that we do the main loop only once per vblank
	call DrawScreen ; if dirty, draws screen, cleans. accesses vram

	call UpdateAudio
	call UpdateKeys ; gets new player input
	call CheckKeysAndUpdateGameState ; processes input, sets dirty flags
	call UpdateShadowBGTilemap ; processes game state and dirty flags, draws screen to shadow tilemap
	call CheckForNewEvents
	jp Main

; dma copy wShadowTilemap and wShadowTilemapAttrs to VRAM
DrawScreen:
	ld a, [wIsShadowTilemapDirty]
	cp CLEAN
	ret z
.drawShadowTilemap
	; select vram bank 0
	xor a
	ld [rVBK], a

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
	ld a, HDMA5F_MODE_GP + (TILEMAP_SIZE / 16) - 1 ; length (number of 16-byte blocks - 1) (63 bytes, $10 * 4)
	ld [rHDMA5], a ; begin dma transfer
	; in single speed mode this takes (4 + 32 × blocks) clocks. so, TILEMAP_SIZE * 2 + 4
	ld bc, TILEMAP_SIZE * 2 + 4
.waitforDmaToFinish: ; necessary?
    dec bc
    jr nz, .waitforDmaToFinish
.drawShadowTilemapAttrs
	; select vram bank 1
	ld a, 1
	ld [rVBK], a

	ld hl, wShadowTilemapAttrs
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld hl, _SCRN0
	ld a, h
	ldh [rHDMA3], a
	ld a, l
	ldh [rHDMA4], a
	ld a, HDMA5F_MODE_GP + (TILEMAP_SIZE / 16) - 1 ; length (number of 16-byte blocks - 1) (63 bytes, $10 * 4)
	ld [rHDMA5], a ; begin dma transfer
	ld bc, TILEMAP_SIZE * 2 + 4
.waitforDmaToFinishAgain: ; necessary?
    dec bc
    jr nz, .waitforDmaToFinishAgain
.clean ; necessary?
	; select vram bank 0.
	xor a
	ld [rVBK], a
	ld a, CLEAN
	ld [wIsShadowTilemapDirty], a
	ret

UpdateShadowBGTilemap:
	ld a, [wIsShadowTilemapDirty]
	cp CLEAN
	ret z
	ld a, [wActiveScreen]
	cp a, PAUSE_SCREEN
	jp nz, LoadFPScreen
LoadPauseScreen:
	call LoadPauseScreenShadowTilemap
	ret
LoadFPScreen:
	call LoadFPShadowTilemap
	ret

; this handles one button of input then quits
CheckKeysAndUpdateGameState:
CheckPressedStart:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_START
	jp nz, HandleStart
CheckPressedSelect:
CheckPressedA:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_A
	jp nz, HandleA
CheckPressedB:
CheckPressedUp:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_UP
	jp nz, HandleUp
CheckPressedDown:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_DOWN
	jp nz, HandleDown
CheckPressedLeft:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_LEFT
	jp nz, HandleLeft
CheckPressedRight:
	ld a, [wJoypadNewlyPressed]
	and a, PADF_RIGHT
	jp nz, HandleRight
	ret

; pause screen contains current map
LoadPauseScreenShadowTilemap:
	; todo load pause screen palette
	ld a, [wActiveMap]
	ld d, a
	ld a, [wActiveMap+1]
	ld e, a
	ld hl, wShadowTilemap
	ld bc, TILEMAP_SIZE
	call Memcopy
	ld a, PAUSE_SCREEN
	ld [wActiveScreen], a
	ret

InitOWColorPalettes:
	ld a, BCPSF_AUTOINC ; load bg color palette specification auto increment on write + addr of zero
	ld [rBCPS], a

	ld de, OWPaletteSet
	ld bc, PALETTE_SET_SIZE
	call WriteColorsToPalette
	ret

UpdateKeys:
	; poll controller buttons
	ld a, P1F_GET_BTN
	call .getBottomNibble
	ld b, a ; b3-0 are button input, b7-4 are 1s

	; poll controller dpad
	ld a, P1F_GET_DPAD
	call .getBottomNibble
	swap a ; move dpad input into the top nibble

	; a (dpad) and b (buttons are padded with 1s). xor with eachother for a byte of current keys pressed
	xor a, b
	ld b, a ; b = this frame's keys down

	; release the controller
	ld a, P1F_GET_NONE
	ldh [rP1], a

	ld a, [wJoypadDown]
	ld c, a ; c = last frame's keys down
	xor b
	ld d, a ; d = keys that changed state since last time
	and b ; a = keys that changed state to pressed since last time
	ld [wJoypadNewlyPressed], a

	ld a, d
	and c
	ld [wJoypadNewlyReleased], a

	ld a, b
	ld [wJoypadDown], a ; update keys down
	ret
.getBottomNibble ; load nibble into a
	ldh [rP1], a ; switch the key matrix.
	; wait for input to stabilize. pokemon crystal attempts 6 times
rept 6
	ldh a, [rP1]
endr
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

DisableLcd:
	xor a
	ld [rLCDC], a
	ret

EnableLcd:
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
	ld [rLCDC], a
	ret
