INCLUDE "src/utils/hardware.inc"
INCLUDE "src/assets/map_data.inc"
;DEF ROOM_NONE EQU $0000
;DEF ROOM_L    EQU $0001
;DEF ROOM_B    EQU $0004
;DEF ROOM_BL   EQU $0005
;DEF ROOM_RL   EQU $0011
;DEF ROOM_RB   EQU $0014
;DEF ROOM_T    EQU $0040
;DEF ROOM_TB   EQU $0044
;DEF ROOM_TBL  EQU $0045
;DEF ROOM_TR   EQU $0050
;DEF ROOM_TRL  EQU $0051
;DEF ROOM_TRB  EQU $0054

DEF GAME_UNPAUSED EQU $00
DEF GAME_PAUSED EQU $01

DEF SCREEN_CLEAN EQU $00
DEF SCREEN_DIRTY EQU $01

DEF ROOM_TILE_NONE EQU $00
DEF ROOM_TILE_L    EQU $01
DEF ROOM_TILE_B    EQU $02
DEF ROOM_TILE_BL   EQU $03
DEF ROOM_TILE_RL   EQU $04
DEF ROOM_TILE_RB   EQU $05
DEF ROOM_TILE_T    EQU $06
DEF ROOM_TILE_TB   EQU $07
DEF ROOM_TILE_TBL  EQU $08
DEF ROOM_TILE_TR   EQU $09
DEF ROOM_TILE_TRL  EQU $0A
DEF ROOM_TILE_TRB  EQU $0B

Section "Game State", WRAM0
wPlayerX: db
wPlayerY: db
wGameState: db ; this could be a single bit
wScreenDirty: db

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

	ld a, 0        ; value to write to bytes
	ld b, 160      ; # of bytes to write
	ld hl, _OAMRAM ; dest
ClearOam:
	ld [hli], a
	dec b
	jp nz, ClearOam

	; init game state
	ld a, 0
	ld [wPlayerX], a
	ld [wPlayerY], a
	ld a, GAME_PAUSED ; start the game paused
	ld [wGameState], a
	ld a, SCREEN_DIRTY
	ld a, [wScreenDirty]
	call EnableLcd

Main:
	call WaitVBlank
	call UpdateScreen
	call UpdateKeys
CheckStart:
	ld a, [wCurKeys]
	and a, PADF_START
	jp z, Main
HandleStart:
	ld a, [wGameState]
	cp GAME_PAUSED
	jp z, UnpauseGame
PauseGame:
	ld a, GAME_PAUSED
	ld [wGameState], a
	ld a, SCREEN_DIRTY
	ld [wScreenDirty], a
	jp Main
UnpauseGame:
	ld a, GAME_UNPAUSED
	ld [wGameState], a
	ld a, SCREEN_DIRTY
	ld [wScreenDirty], a
	jp Main

UpdateScreen:
	ld a, [wScreenDirty]
	cp SCREEN_DIRTY
	ret nz
	ld a, [wGameState]
	cp a, GAME_PAUSED
	jp nz, DrawFPScreen
DrawPauseScreen:
	call LoadPauseScreenTilemap
	jp CleanScreen
DrawFPScreen:
	; here
	call UpdateFPTilemap
	call LoadFPTilemap
CleanScreen:
	ld a, SCREEN_CLEAN
	ld [wScreenDirty], a
	ret

LoadPauseScreenTilemap:
	call DisableLcd
	ld de, MapTilemap ; source in ROM
	ld hl, _SCRN0     ; dest in VRAM
	ld bc, MapTilemapEnd - MapTilemap ; # of bytes (tile indices) remaining
	call Memcopy
	ld a, GAME_PAUSED
	ld [wGameState], a
	call EnableLcd
	ret
LoadFPTilemap:
	call DisableLcd
	ld de, FPTilemap ; source in ROM
	ld hl, _SCRN0    ; dest in VRAM
	ld bc, FPTilemapEnd - FPTilemap ; # of bytes (tile indices) remaining
	call Memcopy
	ld a, GAME_UNPAUSED
	ld [wGameState], a
	call EnableLcd
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
Memcopy:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or c
	jp nz, Memcopy
	ret

WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank
	ret

DisableLcd:
	ld a, 0
	ld [rLCDC], a
	ret

EnableLcd:
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
	ld [rLCDC], a
	ret
