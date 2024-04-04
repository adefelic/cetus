INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tile_data.inc"
INCLUDE "src/assets/tiles/indices/computer_dark.inc"
INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"

SECTION "App State", WRAM0
wIsRandSeeded:: db

SECTION "Game State", WRAM0
wActiveFrameScreen:: db
wPreviousFrameScreen:: db
wActiveMap:: dw
wActiveMapEventLocations:: dw
wStepsToNextDangerLevel:: db
wCurrentDangerLevel:: db

SECTION "Explore Player State", WRAM0
wPlayerExploreX:: db
wPlayerExploreY:: db
wPlayerOrientation:: db

SECTION "Encounter Player State", WRAM0
; coords of top left pixel of sprite
wPlayerEncounterX:: db
wPlayerEncounterY:: db
wPlayerDirection:: db
wJumpsRemaining:: db
wIsJumping:: db
wJumpFramesRemaining:: db

SECTION "Frame State", WRAM0
wHasPlayerRotatedThisFrame:: db
wHasPlayerTranslatedThisFrame:: db

SECTION "Screen Variables", WRAM0
wIsShadowTilemapDirty:: db

SECTION "Input Variables", WRAM0
wPreviousFrameKeys: db
wCurrentFrameKeys: db
wJoypadDown:: db
wJoypadNewlyPressed:: db
wJoypadNewlyReleased:: db

SECTION "Event Flags", WRAM0
wAlwaysTrueEventFlag:: db
wFoundSkullFlag:: db

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
	jp EntryPoint
	; make room for the header
	; rgbfix will overwrite this region
	ds $150 - @, 0
EntryPoint:
	; don't turn off the lcd outside of VBlank
	call WaitVBlank
	call DisableLcd

; todo should make inc files for different tile aggregations?
; so i dont have to track where in tile memory to put tiles
LoadBgTiles:
.loadExploreAndEncounterTiles
	; Copy BG tile data into VRAM bank 0
	ld de, OWTiles
	ld hl, _VRAM9000
	ld bc, OWTilesEnd - OWTiles
	call Memcopy

	ld de, ModalTiles
	ld bc, ModalTilesEnd - ModalTiles
	call Memcopy

	ld de, EncounterTiles
	ld bc, EncounterTilesEnd - EncounterTiles
	call Memcopy

	ld de, FogTiles
	ld bc, FogTilesEnd - FogTiles
	call Memcopy
.loadFont
	; Copy BG tile data into VRAM bank 1
	ld a, 1
	ld [rVBK], a
	ld de, ComputerDarkTiles
	ld hl, _VRAM9000
	ld bc, ComputerDarkTilesEnd - ComputerDarkTiles
	call Memcopy
	; back to VRAM bank 0
	ld a, 0
	ld [rVBK], a

LoadObjectTiles:
.loadHudSprites
	; copy into sprite tile area, bank 0
	ld de, CompassTiles
	ld hl, _VRAM8000
	ld bc, DangerIndicatorTilesEnd - CompassTiles
	call Memcopy
.loadPlayerEncounterSprite
	ld de, ChinchillaTiles
	ld bc, ChinchillaTilesEnd - ChinchillaTiles
	call Memcopy
.loadItemSprites
	ld de, ItemTiles
	ld bc, ItemTilesEnd - ItemTiles
	call Memcopy

LoadPalettes:
	call InitColorPalettes

ClearOam:
	xor a
	ld b, sizeof_OAM_ATTRS * OAM_COUNT ; # of bytes to write
	ld hl, _OAMRAM ; dest
.loop:
	ld [hli], a
	dec b
	jp nz, .loop

; necessary?
ClearShadowOam:
	xor a
	ld bc, wShadowOamEnd - wShadowOam
	ld hl, wShadowOam
.loop:
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jp nz, .loop


; necessary?
ClearShadowTilemap:
	xor a
	ld bc, wShadowTilemapEnd - wShadowTilemap
	ld hl, wShadowTilemap
.loop:
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jp nz, .loop

; necessary?
ClearShadowTilemapAttrs:
	xor a
	ld bc, wShadowTilemapAttrsEnd - wShadowTilemapAttrs
	ld hl, wShadowTilemapAttrs
.loop:
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jp nz, .loop

; necessary?
ClearItemMap:
	ld bc, wItemMapEnd - wItemMap
	ld hl, wItemMap
.loop:
	xor a
	ld [hli], a
	dec bc
	ld a, b
	or c
	jp nz, .loop


InitGameState:
	ld hl, Map1Tiles
	ld a, h
	ld [wActiveMap], a
	ld a, l
	ld [wActiveMap+1], a

	ld hl, Map1EventLocations
	ld a, h
	ld [wActiveMapEventLocations], a
	ld a, l
	ld [wActiveMapEventLocations+1], a

	; init explore state
	call InitExploreScreenState


	call InitExploreState

	; init input
	xor a
	ld [wJoypadDown], a
	ld [wJoypadNewlyReleased], a
	ld [wJoypadNewlyReleased], a

	ld a, FALSE
	ld [wHasPlayerRotatedThisFrame], a
	ld [wHasPlayerTranslatedThisFrame], a
	ld [wIsRandSeeded], a

	; init player state
	;call InitPlayerLocation
	ld a, 1
	ld [wPlayerExploreX], a
	ld a, 29
	ld [wPlayerExploreY], a
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a
	call InitDangerLevel

	; init game state
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a
	ld a, SCREEN_NONE
	ld [wPreviousFrameScreen], a

	; init screen state
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	call DirtyFpSegments
	call UpdateShadowScreen
	call InitGroundItem ; i dont think this is right

	; init event flags
	ld a, TRUE
	ld [wAlwaysTrueEventFlag], a
	ld a, FALSE
	ld [wFoundSkullFlag], a

	; init inventory
	call InitInventory

	call InitAudio
	call EnableLcd

Main:
	;call ResetFrameState ; ResetPerFrameState?
	ld a, FALSE
	ld [wHasPlayerRotatedThisFrame], a
	ld [wHasPlayerTranslatedThisFrame], a
	; set previous frame screen to current frame screen
	ld a, [wActiveFrameScreen]
	ld [wPreviousFrameScreen], a

	call WaitVBlank ; this (sort of) ensures that we do the main loop only once per vblank
	call SetEnqueuedBgPaletteSet
	call DrawScreen ; if dirty, draws screen, cleans. accesses vram
	call UpdateAudio
	call GetKeys ; get new player input

	; update game state from player input and get ready to draw next frame
	; apply x movement in encounters
	call ProcessInput

	; ongoing effects for encounter screen
	; apply y movement in encounters
	call ApplyVerticalMotion

	; ongoing effects for explore screen. could this be attached to movement?
	call LoadVisibleEvents ; checks location for new event

	call UpdateShadowScreen ; processes game state and dirty flags, draws screen to shadow tilemaps
	jp Main

; dma copy shadow ram to VRAM
DrawScreen:
	ld a, [wIsShadowTilemapDirty]
	cp CLEAN
	ret z
.copyShadowTilemapIntoVram
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
.copyShadowTilemapAttrsIntoVram
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
.copyShadowOamIntoOam
	ld hl, wShadowOam
	call RunDma
.clean ; necessary?
	; select vram bank 0.
	xor a
	ld [rVBK], a
	ld a, CLEAN
	ld [wIsShadowTilemapDirty], a
	ret

UpdateShadowScreen:
	ld a, [wIsShadowTilemapDirty]
	cp CLEAN
	ret z
	ld a, [wActiveFrameScreen]
	cp a, SCREEN_EXPLORE
	jp z, .loadExploreScreen
	cp a, SCREEN_ENCOUNTER
	jp z, .loadEncounterScreen
.loadPauseScreen:
	call LoadPauseScreen
	ret
.loadExploreScreen:
	call LoadExploreScreen
	ret
.loadEncounterScreen:
	call LoadEncounterScreen
	ret

; this handles one button of input then returns
ProcessInput:
	ld a, [wActiveFrameScreen]
	cp SCREEN_EXPLORE
	jp z, HandleInputExploreScreen
	cp SCREEN_PAUSE
	jp z, HandleInputPauseScreen
	jp HandleInputEncounterScreen


GetKeys:
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

; copy bytes from one area to another. max 256 bytes
; @param de: source
; @param hl: destination
; @param b: length
MemcopySmall::
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	ld a, b
	jp nz, MemcopySmall
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

; @param hl, source address, zero-aligned
RunDma:
    ld a, HIGH(hl)
    ldh [$FF46], a  ; start DMA transfer (starts right after instruction)
    ld a, 40        ; delay for a total of 4×40 = 160 cycles
.wait
    dec a           ; 1 cycle
    jr nz, .wait    ; 3 cycles
    ret

