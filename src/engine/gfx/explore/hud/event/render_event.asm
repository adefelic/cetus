INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/explore_constants.inc"
INCLUDE "src/constants/gfx_constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/macros/event.inc"

SECTION "Dialog Modal State", WRAM0
wDialogModalDirty:: db
wDialogTextRowHighlighted:: db ; index from 0 to 3. reads from the bottom 3 bits
wDialogBranchesVisibleCount:: db ; # of dialog branches that have TRUE visible flags

; these need to be contiguous in memory
wDialogBranchRendered0:: dw
wDialogBranchRendered1:: dw
wDialogBranchRendered2:: dw
wDialogBranchRendered3:: dw

SECTION "Dialog Modal Scratch", WRAM0
wDialogRootTextAreaRowsRendered:: db
wDialogBranchesIteratedOver:: db

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
	push hl ; stash DialogBranch[wDialogRootTextAreaRowsRendered] addr
	call DereferenceHlIntoHl ; load addr of flag
	ld a, [hl]
	cp FALSE ; check if flag is false.
	jp z, .checkNext
.renderDialogBranchLabel
	pop hl ; restore addr of DialogBranch[wDialogRootTextAreaRowsRendered]
	push hl ; save addr of DialogBranch[wDialogRootTextAreaRowsRendered]
	; add 2 to get the addr of the label text (DialogBranchLabel)
	inc hl
	inc hl
	ld a, [wDialogRootTextAreaRowsRendered]
	ld c, a
	call PaintDialogTextRow

	; fixme this isn't working
	; correlate addr of branch in ram to placement in menu so its frames can be pulled up if selected
	pop hl ; restore addr of DialogBranch[wDialogRootTextAreaRowsRendered]
	ld d, h ; stash hl in de
	ld e, l

	ld hl, wDialogBranchRendered0
	ld a, [wDialogRootTextAreaRowsRendered]
	; add 2 for each in a
	sla a ; a * 2
	call AddAToHl ; hl += a
	; move DialogBranch[wDialogRootTextAreaRowsRendered] into wDialogBranchRendered[wDialogRootTextAreaRowsRendered]

	ld [hl], e
	inc hl
	ld [hl], d

	ld h, d  ; put the old hl back on the stack
	ld l, e
	push hl

	; inc # of text rows drawn. this row offset is used for rendering. it will be used to draw empty lines
	ld a, [wDialogRootTextAreaRowsRendered]
	inc a
	ld [wDialogRootTextAreaRowsRendered], a

	; inc # of text rows visible. this is used to store the current size of the menu
	ld a, [wDialogBranchesVisibleCount]
	inc a
	ld [wDialogBranchesVisibleCount], a

.checkNext ; check if all options have been iterated over. get next if not
	ld a, [wDialogBranchesIteratedOver]
	inc a
	ld [wDialogBranchesIteratedOver], a

	pop hl ; restore addr of DialogBranch[wDialogRootTextAreaRowsRendered]
	ld a, [wDialogBranchesCount]
	ld b, a
	ld a, [wDialogBranchesIteratedOver]
	cp b
	jp z, .renderBlankLines
	; increment hl (addr in DialogBranches array) by sizeof_DialogBranch to get next DialogBranch
	ld a, sizeof_DialogBranch
	add a, l
	ld l, a
	ld a, h
	adc 0
	ld h, a
	jp .renderTextLoop
.renderBlankLines
	ld a, [wDialogRootTextAreaRowsRendered]
.renderBlankLinesLoop
	cp DIALOG_MODAL_TEXT_AREA_HEIGHT
	jp z, .renderBottomRow
	ld c, a
	call PaintEmptyRow ; c is an arg to this
	ld a, [wDialogRootTextAreaRowsRendered]
	inc a
	ld [wDialogRootTextAreaRowsRendered], a
	jp .renderBlankLinesLoop
.renderBottomRow
	call PaintDialogBottomRow
	ld a, FALSE
	ld [wDialogModalDirty], a
	ret

IncrementLineHighlight::
	ld a, [wDialogBranchesVisibleCount]
	ld b, a
	ld a, [wDialogTextRowHighlighted]
	inc a
	cp b
	jp z, .overflow
	ld [wDialogTextRowHighlighted], a
	jp ResetModalStateAfterHighlightChange
.overflow
	xor a
	ld [wDialogTextRowHighlighted], a
	jp ResetModalStateAfterHighlightChange

DecrementLineHighlight::
	ld a, [wDialogTextRowHighlighted]
	dec a
	cp -1
	jp z, .underflow
	ld [wDialogTextRowHighlighted], a
	jp ResetModalStateAfterHighlightChange
.underflow
	ld a, [wDialogBranchesVisibleCount]
	dec a
	ld [wDialogTextRowHighlighted], a
	jp ResetModalStateAfterHighlightChange

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
