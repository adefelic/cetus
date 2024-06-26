; player spawn position
DEF INITIAL_PLAYER_ENCOUNTER_Y EQU TILE_HEIGHT * 9 + OAM_PADDING_Y
DEF INITIAL_PLAYER_ENCOUNTER_X EQU TILE_WIDTH  * 4 + OAM_PADDING_X

; encounter screen player facing direction
DEF DIRECTION_LEFT EQU $0
DEF DIRECTION_RIGHT EQU $1

DEF PLAYER_VELOCITY_X EQU $02
DEF PLAYER_GRAVITY_Y EQU $03
DEF JUMP_SPEED EQU $03 ; -Y pixels per frame. X speed doesn't change
DEF MAX_JUMPS EQU $02 ; # of jumps allowed before hitting ground
DEF JUMP_MAX_FRAMES EQU $07 ; # of frames that jump force lasts

; todo
; implement acceleration like
;DEF N_JUMP_FRAME_SPEEDS EQU $04
;wJumpFrameSpeeds::
;db 1 ; frame 0
;db 1 ; frame 1
;db 2 ; frame 2
;db 2 ; frame 3

; surrounding pixel offsets from top left for collision checks
; 0-------
; --------
; --------
; --------
; --------
; --------
; --------
; --------
; x      x
DEF PLAYER_SPRITE_PIXEL_OFFSET_LB_X EQU $00
DEF PLAYER_SPRITE_PIXEL_OFFSET_RB_X EQU TILE_WIDTH * 2 - 1
DEF PLAYER_SPRITE_PIXEL_OFFSET_B_Y EQU TILE_HEIGHT * 2

; x      x
; 0-------
; --------
; --------
; --------
; --------
; --------
; --------
; --------
DEF PLAYER_SPRITE_PIXEL_OFFSET_LT_X EQU $00
DEF PLAYER_SPRITE_PIXEL_OFFSET_RT_X EQU TILE_WIDTH * 2 - 1
DEF PLAYER_SPRITE_PIXEL_OFFSET_T_Y EQU $01 ; negative

; 0-------
; --------
; --------
; --------
; --------
; --------
; --------
;x--------x
DEF PLAYER_SPRITE_PIXEL_OFFSET_SIDE_LEFT_X EQU $01 ; negative
DEF PLAYER_SPRITE_PIXEL_OFFSET_SIDE_RIGHT_X EQU TILE_WIDTH * 2
DEF PLAYER_SPRITE_PIXEL_OFFSET_SIDE_Y EQU TILE_HEIGHT * 2 - 1
