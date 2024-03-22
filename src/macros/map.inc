; unused

; really it's 30 by 30 because buffer rooms
;DEF MAP_HEIGHT EQU 32 ; rooms
;DEF MAP_WIDTH  EQU 32 ; rooms

;DEF WALL_ROOM_SIZE EQU 1 ; bytes
;DEF EVENT_ROOM_SIZE EQU 1 ; bytes

;DEF WALL_MAP_SIZE EQU MAP_HEIGHT * MAP_WIDTH * WALL_ROOM_SIZE ; bytes
;DEF EVENT_MAP_SIZE EQU MAP_HEIGHT * MAP_WIDTH * EVENT_ROOM_SIZE ; bytes

;MACRO map
;	db \1                 ; initial player coords
;	db \2                 ; initial player orientation
;	ds WALL_MAP_SIZE, \3  ; wall map
;	ds EVENT_MAP_SIZE, \4 ; event map
;	db \5                 ; sizeof event_triggers
;	ds \5, \6             ; event triggers
;	db \7                 ; sizeof encounters
;	ds \7, \8             ; encounters
;ENDM

