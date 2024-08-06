INCLUDE "src/lib/structs.inc"

; Palette animation structs

	struct PaletteAnimation
		bytes 1, TotalFrameCount
		bytes 1, KeyFramesCount
		words 1, KeyFramesAddr
	end_struct

	struct PaletteAnimationKeyFrame
		bytes 1, FrameNumber ; descending to 0
		bytes 1, NewPaletteId
	end_struct


; basic algo
; when drawing sprite, check current palette anim
; if there's an active anim, check current frame
; if this frame has a changed palette, apply the change
