INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/macros/event.inc"

SECTION "Dialog Rendering Scratch", WRAM0
wDialogBranchLinesRendered:: db
wDialogModalDirty:: db

SECTION "Explore Screen Event Renderer", ROMX

; overlay event bg tiles, reading from the active event pointers
RenderDialog::
	ld a, [wDialogModalDirty]
	cp TRUE
	ret nz
	ld a, [wDialogState]
	cp DIALOG_STATE_LABEL
	jp z, RenderLabel
	cp DIALOG_STATE_ROOT
	jp z, RenderDialogRoot
	cp DIALOG_STATE_BRANCH
	jp z, RenderDialogBranch
	; control shouldn't reach here
	ret

RenderLabel:
	; load wRoomEventAddr, add EventLabelText offset, store in wCurrentLabelAddr
	; this is still used in the PaintLabelModel routine
	ld a, [wRoomEventAddr]
	add RoomEvent_EventLabelText
	ld [wCurrentLabelAddr], a
	ld a, [wRoomEventAddr + 1]
	adc 0
	ld [wCurrentLabelAddr + 1], a
	call PaintLabelModel
	ld a, FALSE
	ld [wDialogModalDirty], a
	ret

RenderDialogRoot:
; okay so highlighting an entry just changes its palette
; when A is pressed, text is replaced with the text of the first frame ofthe highlighted entry.
; when an entry is highlighted, the _wHighlightedDialogBranch_ flag is updated, which points to the option
; when A is pressed, we switch to option rendering mode and render the first frame
.renderTopRow
	call PaintDialogTopRow
.renderDialogBranchLabelsWithTrueFlag
	; iterate over DialogBranches array @ wDialogBranchesAddr w wDialogBranchesCount
	; load counter
	ld a, [wDialogBranchesCount]
	ld b, a ; b is the # of times we can loop
	; load 0th array element addr into hl
	ld a, [wDialogBranchesAddr]
	ld l, a
	ld a, [wDialogBranchesAddr + 1]
	ld h, a
.renderTextLoop
	; the word at offset 0 of a DialogBranch is the address of the flag that determines whether it should be displayed
	push hl ; stash DialogBranch[wDialogBranchLinesRendered] addr
	call DereferenceHlIntoHl ; load addr of flag
	ld a, [hl]
	cp FALSE ; check if flag is false.
	jp z, .checkNext
.renderDialogBranchLabel
	pop hl ; restore addr of DialogBranch[wDialogBranchLinesRendered]
	push hl ; save addr of DialogBranch[wDialogBranchLinesRendered]
	; add 2 to get the addr of the label text (DialogBranchLabel)
	inc hl
	inc hl
	ld a, [wDialogBranchLinesRendered]
	ld c, a
	call PaintDialogTextRow
	; inc # of text rows drawn
	ld a, [wDialogBranchLinesRendered]
	inc a
	ld [wDialogBranchLinesRendered], a
.checkNext ; check if all options have been iterated over. get next if not
	pop hl ; restore addr of DialogBranch[wDialogBranchLinesRendered]
	ld a, [wDialogBranchesCount]
	ld b, a
	ld a, [wDialogBranchLinesRendered]
	cp b
	jp z, .finishRenderingDialogRoot
	; increment hl (addr in DialogBranches array) by sizeof_DialogBranch
	ld a, sizeof_DialogBranch
	add a, l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	jp .renderTextLoop
.finishRenderingDialogRoot
	ld [wDialogBranchLinesRendered], a
.fillWithEmptyRowsLoop
	cp DIALOG_MODAL_TEXT_AREA_HEIGHT + 1
	jp z, .renderBottomRow
	ld c, a
	call PaintEmptyRow ; c is an arg to this
	ld a, [wDialogBranchLinesRendered]
	inc a
	ld [wDialogBranchLinesRendered], a
	jp .fillWithEmptyRowsLoop
.renderBottomRow
	call PaintDialogBottomRow
	ld a, FALSE
	ld [wDialogModalDirty], a
	ret

RenderDialogBranch:
; old, saving for later in case useful
;.incrementEventFrameAddress
;	; todo with new dialog system, maybe it would make more sense to increment an abstract frame(page) count here
;	; inc frame address by frame size
;	ld a, [wEventFrameAddr]
;	ld l, a
;	ld a, [wEventFrameAddr + 1]
;	ld h, a
;	ld a, EVENT_FRAME_SIMPLE_SIZE
;	call AddAToHl ; this might be silly and inefficient
;	ld a, l
;	ld [wEventFrameAddr], a
;	ld a, h
;	ld [wEventFrameAddr + 1], a
;.incrementEventFrameIndex
;	ld a, [wEventFrameIndex]
;	inc a
;	ld [wEventFrameIndex], a
	ret
