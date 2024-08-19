; room wall definitions

; 00 00 00 00 = wall definition, in n e s w order.
; 00 = open, 01 = wallA, 10 = wallB, 11 = wallC

; todo use a macro to define rooms with wall types instead of constants

DEF ROOM_NONE EQU %00000000
DEF ROOM_L    EQU %00000001
DEF ROOM_B    EQU %00000100
DEF ROOM_BL   EQU %00000101
DEF ROOM_R    EQU %00010000
DEF ROOM_RL   EQU %00010001
DEF ROOM_RB   EQU %00010100
DEF ROOM_RBL  EQU %00010101
DEF ROOM_T    EQU %01000000
DEF ROOM_TL   EQU %01000001
DEF ROOM_TB   EQU %01000100
DEF ROOM_TBL  EQU %01000101
DEF ROOM_TR   EQU %01010000
DEF ROOM_TRL  EQU %01010001
DEF ROOM_TRB  EQU %01010100
DEF ROOM_TRBL EQU %01010100

; wall types
DEF WALL_TYPE_NONE EQU %00
DEF WALL_TYPE_A    EQU %01
DEF WALL_TYPE_WALL EQU WALL_TYPE_A
DEF WALL_TYPE_B    EQU %10
DEF WALL_TYPE_DOOR EQU WALL_TYPE_B
DEF WALL_TYPE_C    EQU %11

; 8-bit masks for individual walls
DEF ROOM_MASK_NORTH_WALL EQU %11000000
DEF ROOM_MASK_EAST_WALL  EQU %00110000
DEF ROOM_MASK_SOUTH_WALL EQU %00001100
DEF ROOM_MASK_WEST_WALL  EQU %00000011