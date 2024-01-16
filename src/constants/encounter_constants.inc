; encounter screen player facing direction
DEF DIRECTION_LEFT EQU $0
DEF DIRECTION_RIGHT EQU $1

DEF PLAYER_VELOCITY_X EQU $02
DEF PLAYER_GRAVITY_Y EQU $04

; offsets from x, y pixel to get bottom pixels for collision
DEF PLAYER_SPRITE_PIXEL_OFFSET_BOTTOM EQU 15 ; + wEncounterPlayerX
DEF PLAYER_SPRITE_PIXEL_OFFSET_RIGHT EQU 15 ; + wEncounterPlayerY
