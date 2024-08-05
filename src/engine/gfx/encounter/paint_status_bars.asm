INCLUDE "src/assets/tiles/indices/scrib.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/palette_constants.inc"

DEF PLAYER_STATUS_HP_LINE EQU rows 10 + cols 9
DEF PLAYER_STATUS_MP_LINE EQU PLAYER_STATUS_HP_LINE + rows 1

DEF NPC_STATUS_HP_LINE EQU cols 5

DEF STATUS_LINE_STRING_LEN EQU 11

SECTION "Player Status Buffers", WRAM0
wStatusStringBuffer:: ds STATUS_LINE_STRING_LEN

SECTION "Player Status Rendering", ROMX

PaintPlayerStatus::
PaintHpStatusLine:
	ld hl, wStatusStringBuffer
	ld a, "h"
	ld [hli], a
	ld a, "p"
	ld [hli], a
	ld a, " "
	ld [hli], a
.HpCurrent
	ld a, [wHpCurrent]
	call ConvertBinaryNumberToThreeDigitDecimalNumber
	ld a, b ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, d ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, e
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
.slash
	ld a, "/"
	ld [hli], a
.HpMax
	ld a, [wHpMax]
	call ConvertBinaryNumberToThreeDigitDecimalNumber
	ld a, b ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, d ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, e
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
.memcopy
	; tilemap
	ld de, wStatusStringBuffer
	ld hl, wShadowBackgroundTilemap + PLAYER_STATUS_HP_LINE
	ld b, STATUS_LINE_STRING_LEN
	call MemcopySmall
	; attrs
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + PLAYER_STATUS_HP_LINE
	ld b, STATUS_LINE_STRING_LEN
	call CopyByteInEToRange

PaintMpStatusLine:
	ld hl, wStatusStringBuffer
	ld a, "m"
	ld [hli], a
	ld a, "p"
	ld [hli], a
	ld a, " "
	ld [hli], a
.MpCurrent
	ld a, [wMpCurrent]
	call ConvertBinaryNumberToThreeDigitDecimalNumber
	ld a, b ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, d ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, e
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
.slash
	ld a, "/"
	ld [hli], a
.MpMax
	ld a, [wMpMax]
	call ConvertBinaryNumberToThreeDigitDecimalNumber
	ld a, b ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, d ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, e
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
.memcopy
	; tilemap
	ld de, wStatusStringBuffer
	ld hl, wShadowBackgroundTilemap + PLAYER_STATUS_MP_LINE
	ld b, STATUS_LINE_STRING_LEN
	call MemcopySmall
	; attrs
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + PLAYER_STATUS_MP_LINE
	ld b, STATUS_LINE_STRING_LEN
	call CopyByteInEToRange
	ret

PaintNPCStatus::
	ld hl, wStatusStringBuffer
	ld a, "h"
	ld [hli], a
	ld a, "p"
	ld [hli], a
	ld a, " "
	ld [hli], a
.HpCurrent
	ld a, [wNpcCurrentHp]
	call ConvertBinaryNumberToThreeDigitDecimalNumber
	ld a, b ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, d ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, e
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
.slash
	ld a, "/"
	ld [hli], a
.HpMax
	ld a, [wNpcMaxHp]
	call ConvertBinaryNumberToThreeDigitDecimalNumber
	ld a, b ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, d ; todo if 0, paint blank
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
	ld a, e
	add NUMBER_CHARACTER_OFFSET
	ld [hli], a
.memcopy
	; tilemap
	ld de, wStatusStringBuffer
	ld hl, wShadowBackgroundTilemap + NPC_STATUS_HP_LINE
	ld b, STATUS_LINE_STRING_LEN
	call MemcopySmall
	; attrs
	ld e, BG_PALETTE_UI + OAMF_BANK1
	ld hl, wShadowBackgroundTilemapAttrs + NPC_STATUS_HP_LINE
	ld b, STATUS_LINE_STRING_LEN
	call CopyByteInEToRange
	ret
