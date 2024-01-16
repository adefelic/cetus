; explore screen player orientation. values are effectively masks for collision data :)
DEF ORIENTATION_NORTH EQU $8
DEF ORIENTATION_EAST  EQU $4
DEF ORIENTATION_SOUTH EQU $2
DEF ORIENTATION_WEST  EQU $1

; wall types
DEF WALL_TYPE_NONE EQU $00
DEF WALL_TYPE_A    EQU $01
DEF WALL_TYPE_B    EQU $10
DEF WALL_TYPE_C    EQU $11

; event types
DEF EVENT_TYPE_WARP EQU $00

; event locations
DEF EVENT_NONE EQU $00 ; this isn't really a type it's an event location offset value

; 8-bit masks
DEF ROOM_MASK_NORTH_WALL EQU %11000000
DEF ROOM_MASK_EAST_WALL  EQU %00110000
DEF ROOM_MASK_SOUTH_WALL EQU %00001100
DEF ROOM_MASK_WEST_WALL  EQU %00000011

; 4-bit collision values
DEF WALLS_NONE EQU $0 ; this should be unused?
DEF WALLS_L    EQU $1
DEF WALLS_B    EQU $2
DEF WALLS_BL   EQU $3
DEF WALLS_R    EQU $4
DEF WALLS_RL   EQU $5
DEF WALLS_RB   EQU $6
DEF WALLS_RBL  EQU $7
DEF WALLS_T    EQU $8
DEF WALLS_TL   EQU $9
DEF WALLS_TB   EQU $A
DEF WALLS_TBL  EQU $B
DEF WALLS_TR   EQU $C
DEF WALLS_TRL  EQU $D
DEF WALLS_TRB  EQU $E
DEF WALLS_TRBL EQU $F

; 4-bit collision masks
DEF COLLISION_MASK_L EQU $1
DEF COLLISION_MASK_B EQU $2
DEF COLLISION_MASK_R EQU $4
DEF COLLISION_MASK_T EQU $8