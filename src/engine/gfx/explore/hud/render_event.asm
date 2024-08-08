INCLUDE "src/constants/constants.inc"
INCLUDE "src/constants/event_constants.inc"
INCLUDE "src/constants/gfx_event.inc"
INCLUDE "src/structs/event.inc"

SECTION "Dialog Modal State", WRAM0
wBottomMenuDirty:: db
wDialogTextRowHighlighted:: db ; index from 0 to 3. reads from the bottom 3 bits

; filtered list of addresses of menu item structs
; todo should probably make them generic / unions. they should all start with a 1)label field
; these need to be contiguous in memory
wMenuItems::
; the names below are never used
wMenuItemRendered0: dw
wMenuItemRendered1: dw
wMenuItemRendered2: dw
wMenuItemRendered3: dw
wMenuItemRendered4: dw
wMenuItemRendered5: dw
wMenuItemRendered6: dw
wMenuItemRendered7: dw

wMenuItemsCount:: db
wMenuItemTopVisible:: db

SECTION "Dialog Modal Scratch", WRAM0
wTextRowsRendered:: db ; formerly wDialogRootTextAreaRowsRendered
wDialogBranchesIteratedOver:: db
wCurrentMenuItem:: dw ; points to the menu item (wMenuItemRendered) being presently filled by some filtering function

SECTION "Explore Screen Event Renderer", ROMX


; todo the label should be rendered as a result of there being an interactable available, not as a first step of dialog. pls decouple

; overlay event bg tiles, reading from the active event pointers
RenderDialog::
	ld a, [wBottomMenuDirty] ; whoa this is wrong. this would only be a good check if the LABEL state also used the bottom menu.
	; fixme, make this not re-render the menus if they're up there already. or decouple LABEL from events
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
	; this is still used in the PaintLabelTopModal routine
	ld a, [wRoomEventAddr]
	add RoomEvent_EventLabelText
	ld [wCurrentLabelAddr], a
	ld a, [wRoomEventAddr + 1]
	adc 0
	ld [wCurrentLabelAddr + 1], a
	call PaintLabelTopModal
	ld a, FALSE
	ld [wBottomMenuDirty], a
	ret

; display a list of 4 options
RenderDialogRoot:
; okay so highlighting an entry just changes its palette
; when A is pressed, text is replaced with the text of the first frame ofthe highlighted entry.
; when an entry is highlighted, the _wHighlightedDialogBranch_ flag is updated, which points to the option
; when A is pressed, we switch to option rendering mode and render the first frame
.setup
	; have wCurrentMenuItem point to wMenuItems
	ld hl, wMenuItems
	ld a, l
	ld [wCurrentMenuItem], a
	ld a, h
	ld [wCurrentMenuItem + 1], a
.renderTopRow
	call PaintModalTopRowDialogRoot
.renderDialogBranchLabelsWithTrueFlag ; (gather menu items by filtering branch options)
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
	push hl ; stash DialogBranch[wTextRowsRendered] addr
	call DereferenceHlIntoHl ; load addr of flag
	ld a, [hl]
	cp FALSE ; check if flag is false.
	jp z, .checkNext
.renderDialogBranchLabel
	pop hl ; restore addr of DialogBranch[wTextRowsRendered]
	push hl ; save addr of DialogBranch[wTextRowsRendered]
	; add 2 to get the addr of the label text (DialogBranchLabel)
	inc hl
	inc hl
	ld a, [wTextRowsRendered]
	ld c, a
	call PaintModalTextRow

	; correlate addr of branch in ram to placement in menu so its frames can be pulled up if selected
	pop hl ; restore addr of DialogBranch[wTextRowsRendered]
	ld d, h ; stash hl in de
	ld e, l

	; put the current menu item pointer in hl to store the addr of the branch of the label we just drew
	ld a, [wCurrentMenuItem]
	ld l, a
	ld a, [wCurrentMenuItem + 1]
	ld h, a

	; move DialogBranch[wTextRowsRendered] (in de) into wDialogBranchRendered[wTextRowsRendered]
	ld [hl], e
	inc hl
	ld [hl], d

	inc hl ; inc once more to point to next word and store
	ld a, l
	ld [wCurrentMenuItem], a
	ld a, h
	ld [wCurrentMenuItem + 1], a

	ld h, d  ; put the old hl back on the stack
	ld l, e
	push hl

	; inc # of text rows drawn. this row offset is used for rendering. it will be used to draw empty lines
	ld a, [wTextRowsRendered]
	inc a
	ld [wTextRowsRendered], a

	; inc # of text rows visible. this is used to store the current size of the menu
	ld a, [wMenuItemsCount]
	inc a
	ld [wMenuItemsCount], a

.checkNext ; check if all options have been iterated over. get next if not
	ld a, [wDialogBranchesIteratedOver]
	inc a
	ld [wDialogBranchesIteratedOver], a

	pop hl ; restore addr of DialogBranch[wTextRowsRendered]
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
	ld a, [wTextRowsRendered]
.renderBlankLinesLoop
	cp MODAL_TEXT_AREA_HEIGHT
	jp z, .renderBottomRow
	ld c, a
	call PaintModalEmptyRow ; c is an arg to this
	ld a, [wTextRowsRendered]
	inc a
	ld [wTextRowsRendered], a
	jp .renderBlankLinesLoop
.renderBottomRow
	call PaintModalBottomRowCheckX
	ld a, FALSE
	ld [wBottomMenuDirty], a
	ret

IncrementLineHighlight::
	ld a, [wMenuItemsCount]
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
	ld a, [wMenuItemsCount]
	dec a
	ld [wDialogTextRowHighlighted], a
	jp ResetModalStateAfterHighlightChange

; step through and render branch pages sequentially
RenderDialogBranch:
.disableTextHighlight
	ld a, $FF ; this is a goofy hack. tells the text painter to highlight line 255 out of 3
	ld [wDialogTextRowHighlighted], a
.renderTopRow
	call PaintModalTopRow
.updateAddressOfCurrentFrame
	; load current frame into hl
	ld a, [wCurrentDialogBranchFrameAddr]
	ld l, a
	ld a, [wCurrentDialogBranchFrameAddr + 1]
	ld h, a

	ld a, [wDialogBranchFramesIndex]
	cp 0
	; go straight to rendering text if the index is 0, as there is no array offset to add
	jp z, .addTextLine0Offset

	; update wCurrentDialogBranchFrameAddr to point to new frame
	ld a, sizeof_DialogBranchFrame
	call AddAToHl
	ld a, l
	ld [wCurrentDialogBranchFrameAddr], a
	ld a, h
	ld [wCurrentDialogBranchFrameAddr + 1], a

	; if wCurrentDialogBranchFrameAddr had to be updated, then wTextRowsRendered should be reset too
	xor a
	ld [wTextRowsRendered], a
.addTextLine0Offset
	ld a, DialogBranchFrame_TextLine0
	call AddAToHl
.renderTextLine
	push hl ; stash addr of text line to draw
	ld a, [wTextRowsRendered]
	ld c, a
	call PaintModalTextRow
	; inc # of text rows drawn. this row offset is used for rendering. it will be used to draw empty lines
	ld a, [wTextRowsRendered]
	inc a
	ld [wTextRowsRendered], a
	pop hl ; restore addr of text line (the one just drawn)
.checkNextLine
	cp MODAL_TEXT_AREA_HEIGHT
	jp z, .renderBottomRow
	ld a, BYTES_IN_DIALOG_STRING
	call AddAToHl ; add offset to get next text line addr
	jp .renderTextLine
.renderBottomRow
	call PaintModalBottomRowDialogBranch
	ld a, FALSE
	ld [wBottomMenuDirty], a
	ret

; @return hl, address of menu item
GetHighlightedMenuItemAddr::
	; todo this will need to be updated when scrolling is implemented
	ld a, [wDialogTextRowHighlighted]
	sla a ; x2 to go from index to address offset
	ld hl, wMenuItems
	call AddAToHl
	call DereferenceHlIntoHl
	ret
