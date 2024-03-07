INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/macros/event.inc"

; todo move this
DEF DIALOG_MODAL_HEIGHT EQU 6 ; fixme this is a redefinition ...

SECTION "Dialog Modal State", WRAM0
wDialogModalState:: db ;should the game render the dialog root or a dialog option
wDialogHighlightedOption:: dw  ; addr of the dialog option that is currently highlighted if in the DIALOG_STATE_ROOT state
wCurrentDialogFrame:: dw ; addr of the dialog option frame is currently rendered if in the DIALOG_STATE_OPTION state
wCurrentLabelAddr:: dw ; addr of the label to paint if the dialog state is DIALOG_STATE_LABEL

SECTION "Dialog Rendering State", WRAM0
wTextRowsDrawnCount:: db

SECTION "Explore Screen Event Renderer", ROMX

; overlay event bg tiles, reading from the active event pointers
RenderDialog::
	; check if we are rendering the dialog option tree or a specific dialog option
	ld a, [wDialogModalState]
	cp DIALOG_STATE_LABEL
	jp z, RenderLabel
	cp DIALOG_STATE_ROOT
	jp z, RenderDialogRoot
	cp DIALOG_STATE_OPTION
	jp z, RenderDialogOption
	; control shouldn't reach here
	ret

RenderLabel:
	; load wRoomEventAddr, add EventLabelText offset, store in wCurrentLabelAddr
	ld a, [wRoomEventAddr]
	add RoomEvent_EventLabelText
	ld [wCurrentLabelAddr], a
	ld a, [wRoomEventAddr + 1]
	adc 0
	ld [wCurrentLabelAddr + 1], a
	call PaintLabelModel
	ret

RenderDialogRoot:
; okay so highlighting an entry just changes its palette
; when A is pressed, text is replaced with the text of the first frame ofthe highlighted entry.
; when an entry is highlighted, the _wHighlightedDialogOption_ flag is updated, which points to the option
; when A is pressed, we switch to option rendering mode and render the first frame
.renderTopRow
	call PaintDialogTopRow
.renderDialogOptionLabelsWithTrueFlag
	; iterate over DialogOptions array @ wDialogOptionsAddr w wDialogOptionsSize and wDialogOptionsIndex
	; load counter
	ld a, [wDialogOptionsSize]
	ld b, a ; b is the # of times we can loop
	; load 0th array element addr into hl
	ld a, [wDialogOptionsAddr]
	ld l, a
	ld a, [wDialogOptionsAddr + 1]
	ld h, a
.loop
	; the word at offset 0 of a DialogOption is the address of the flag that determines if it should be displayed
	push hl ; stash DialogOption[b] addr
	call DereferenceHlIntoHl ; load addr of flag
	ld a, [hl]
	cp FALSE
	jp z, .checkIfAllDialogOptionsHaveBeenIteratedOver
.renderDialogOptionLabel
	pop hl ; restore addr of DialogOption[b]
	push hl ; save addr of DialogOption[b]
	; add 2 to get the addr of the label text (DialogOptionLabel)
	inc hl
	inc hl
	ld a, [wTextRowsDrawnCount]
	ld c, a
	call PaintDialogTextRow
	; inc # of text rows drawn
	ld a, [wTextRowsDrawnCount]
	inc a
	ld [wTextRowsDrawnCount], a
.checkIfAllDialogOptionsHaveBeenIteratedOver
	pop hl ; restore addr of DialogOption[b]
	ld a, b
	dec a
	ld b, a
	cp 0
	jp z, .finishRenderingDialogRoot
	; get the next
	ld a, sizeof_DialogOption
	add a, l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	jp .loop
.finishRenderingDialogRoot
.fillWithEmptyRows
	; draw blank rows until (wTextRowsDrawnCount == DIALOG_MODAL_TEXT_AREA_HEIGHT)
	ld a, [wTextRowsDrawnCount]
.fillLoop
	cp DIALOG_MODAL_HEIGHT - 2
	jp z, .renderBottomRow
	call PaintEmptyRow
	inc a
	ld [wTextRowsDrawnCount], a ; saving this value to ram might be unnecessary
	jp .fillLoop
.renderBottomRow
	call PaintDialogBottomRow
	ret

RenderDialogOption:
	ret
