INCLUDE "src/lib/hardware.inc"
INCLUDE "src/assets/tile_data.inc"
INCLUDE "src/assets/tiles/indices/scrib.inc"
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

; todo these feel like an antipattern
SECTION "Update Loop State", WRAM0
wHasPlayerRotated:: db
wHasPlayerTranslated:: db

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

; unused hardware interrupts
SECTION "timer", ROM0[$0050]
	;jp TimerInterruptHandler

SECTION "serial", ROM0[$0058]
	;jp Serial

SECTION "joypad", ROM0[$0060]
	;jp Joypad

SECTION "Header", ROM0[$100]
	jp EntryPoint
	; make room for the header. rgbfix will overwrite this region
	ds $150 - @, 0
EntryPoint:
	di

	; from gb-starter-kit
	;; Kill sound
	;xor a
	;ldh [rNR52], a
	; i wonder if this will get rid of the boot pop

.waitVBlank:
	ldh a, [rLY]
	cp SCRN_Y
	jr c, .waitVBlank
.disableLcd
	xor a
	ld [rLCDC], a

.enableInterrupts
	; arbitrary line, 0-153
	ld a, 50
	ldh [rLYC], a

	; set lcd interrupt to be fired when LY == LCY
	ld a, STATF_LYC
	ldh [rSTAT], a

	; enable vblank and lcd interrupts
	ld a, IEF_VBLANK + IEF_STAT
	ldh [rIE], a

	ei ; Only takes effect after the following instruction
	xor a
	ldh [rIF], a ; Clears "accumulated" interrupts

; todo should make inc files for different tile aggregations?
; so i dont have to track where in tile memory to put tiles
LoadBgTilesIntoVram:
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

	ld de, DistanceFogTiles
	ld bc, DistanceFogTilesEnd - DistanceFogTiles
	call Memcopy
.loadFont
	; Copy BG tile data into VRAM bank 1
	ld a, 1
	ld [rVBK], a
	ld de, ScribTiles
	ld hl, _VRAM9000
	ld bc, ScribTilesEnd - ScribTiles
	call Memcopy
	; back to VRAM bank 0
	ld a, 0
	ld [rVBK], a

LoadObjectTilesIntoVram:
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

InitGame:
	call SetMap

	; init input
	xor a
	ld [wJoypadDown], a
	ld [wJoypadNewlyReleased], a
	ld [wJoypadNewlyReleased], a

	ld a, FALSE
	ld [wHasPlayerRotated], a
	ld [wHasPlayerTranslated], a
	ld [wIsRandSeeded], a

	; init player state
	ld a, 1
	ld [wPlayerExploreX], a
	ld a, 29
	ld [wPlayerExploreY], a
	ld a, ORIENTATION_EAST
	ld [wPlayerOrientation], a
	call InitDangerLevel

	; init game screen state
	ld a, SCREEN_EXPLORE
	ld [wActiveFrameScreen], a
	ld a, SCREEN_NONE
	ld [wPreviousFrameScreen], a

	; init explore state
	call InitExploreMenuState
	call InitExploreEventState

	; init screen rendering state
	ld a, DIRTY
	ld [wIsShadowTilemapDirty], a
	call DirtyFpSegments
	call UpdateShadowVram

	; todo move this to sram code
	; init event flags
	ld a, TRUE
	ld [wAlwaysTrueEventFlag], a
	ld a, FALSE
	ld [wFoundSkullFlag], a
	call InitInventory

	call InitAudio
	call EnableLcd
Main:
	call ProcessInput
	call LoadVisibleEvents ; checks location for new event. todo this should be executed after movement/rotation. rotation could be made to just "rotate" a cached version of the current event walls for the current room
	call UpdateShadowVram ; processes game state and dirty flags, draws screen to shadow maps
	jr Main

; dma copy shadow ram to VRAM
CopyShadowsToVram::
.copyShadowTilemapIntoVram
	; select vram bank 0
	xor a
	ld [rVBK], a
	ld hl, wShadowTilemap
	call DmaShadowTilemapToVram
.copyShadowTilemapAttrsIntoVram
	; select vram bank 1
	ld a, 1
	ld [rVBK], a
	ld hl, wShadowTilemapAttrs
	call DmaShadowTilemapToVram
	; select vram bank 0.
	xor a
	ld [rVBK], a
.copyShadowOamIntoOam ; this isn't working ?
	ld hl, wShadowOam
	call RunDma
.clean ; necessary?
	ld a, CLEAN
	ld [wIsShadowTilemapDirty], a
	ret

; @param hl, src shadow tilemap to copy
DmaShadowTilemapToVram:
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld hl, _SCRN0
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

; todo there are some problems here
UpdateShadowVram::
	ld a, [wIsShadowTilemapDirty]
	cp CLEAN
	ret z
	ld a, [wActiveFrameScreen]
	cp SCREEN_EXPLORE
	jp z, .updateShadowTilemapExploreScreen
	cp SCREEN_ENCOUNTER
	jp z, .updateShadowTilemapEncounterScreen
	cp SCREEN_PAUSE
	jp z, .updateShadowTilemapPauseScreen
	ret
.updateShadowTilemapExploreScreen:
	call UpdateShadowTilemapExploreScreen
	jp .cleanup
.updateShadowTilemapEncounterScreen:
	;call UpdateShadowTilemapEncounterScreen
	call UpdateShadowTilemapPauseScreen
	jp .cleanup
.updateShadowTilemapPauseScreen:
	call UpdateShadowTilemapPauseScreen
	jp .cleanup
.cleanup
	ld a, FALSE
	ld [wHasPlayerRotated], a
	ld [wHasPlayerTranslated], a
	ret

; this handles one button of input then returns
ProcessInput::
	ld a, [wActiveFrameScreen]
	cp SCREEN_EXPLORE
	jp z, HandleInputExploreScreen
	cp SCREEN_ENCOUNTER
	jp z, HandleInputEncounterScreen
	cp SCREEN_PAUSE
	jp z, HandleInputPauseScreen
	ret

GetKeys::
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
