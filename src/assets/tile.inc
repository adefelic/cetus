;;;; ow-simple tile indices

; room type tiles / pausemap gfx tiles
; deprecated for use as collision map
; these tiles are both graphical tiles and the source of truth for the room map itself
; todo decouple these? nah the pausemap is a debug feature not a feature feature

DEF PAUSEMAP_TILE_NONE EQU $00
DEF PAUSEMAP_TILE_L    EQU $01
DEF PAUSEMAP_TILE_B    EQU $02
DEF PAUSEMAP_TILE_BL   EQU $03
DEF PAUSEMAP_TILE_R    EQU $04
DEF PAUSEMAP_TILE_RL   EQU $05
DEF PAUSEMAP_TILE_RB   EQU $06
DEF PAUSEMAP_TILE_RBL  EQU $07
DEF PAUSEMAP_TILE_T    EQU $08
DEF PAUSEMAP_TILE_TL   EQU $09
DEF PAUSEMAP_TILE_TB   EQU $0A
DEF PAUSEMAP_TILE_TBL  EQU $0B
DEF PAUSEMAP_TILE_TR   EQU $0C
DEF PAUSEMAP_TILE_TRL  EQU $0D
DEF PAUSEMAP_TILE_TRB  EQU $0E
DEF PAUSEMAP_TILE_TRBL EQU $0F
DEF FP_TILE_DARK       EQU $10
DEF FP_TILE_GROUND     EQU $11
DEF FP_TILE_WALL_SIDE  EQU $12
DEF FP_TILE_WALL_FRONT EQU $13
DEF FP_TILE_DIAG_R     EQU $14
DEF FP_TILE_DIAG_L     EQU $15
DEF MODAL_TILE_EMPTY              EQU $16
DEF MODAL_TILE_TOP_LEFT_CORNER    EQU $17
DEF MODAL_TILE_HORIZONTAL         EQU $18
DEF MODAL_TILE_BOTTOM_LEFT_CORNER EQU $19
DEF MODAL_TILE_VERTICAL           EQU $1A


; computer-dark tile indices

;NEWCHARMAP computer-dark
charmap "!",  $01
charmap "\"", $02
charmap "#",  $03
charmap "$",  $04
charmap "%",  $05
charmap "&",  $06
charmap "'",  $07
charmap "(",  $08
charmap ")",  $09
charmap "*",  $0A
charmap "+",  $0B
charmap ",",  $0C
charmap "-",  $0D
charmap ".",  $0E
charmap "/",  $0F
charmap "0",  $10
charmap "1",  $11
charmap "2",  $12
charmap "3",  $13
charmap "4",  $14
charmap "5",  $15
charmap "6",  $16
charmap "7",  $17
charmap "8",  $18
charmap "9",  $19
charmap ":",  $1A
charmap ";",  $1B
charmap "<",  $1C
charmap "=",  $1D
charmap ">",  $1E
charmap "?",  $1F
charmap "@",  $20
charmap "A",  $21
charmap "B",  $22
charmap "C",  $23
charmap "D",  $24
charmap "E",  $25
charmap "F",  $26
charmap "G",  $27
charmap "H",  $28
charmap "I",  $29
charmap "J",  $2A
charmap "K",  $2B
charmap "L",  $2C
charmap "M",  $2D
charmap "N",  $2E
charmap "O",  $2F
charmap "P",  $30
charmap "Q",  $31
charmap "R",  $32
charmap "S",  $33
charmap "T",  $34
charmap "U",  $35
charmap "V",  $36
charmap "W",  $37
charmap "X",  $38
charmap "Y",  $39
charmap "Z",  $3A
charmap "[",  $3B
charmap "\\", $3C
charmap "]",  $3D
charmap "^",  $3E
charmap "_",  $3F
charmap " ",  $40
charmap "a",  $41
charmap "b",  $42
charmap "c",  $43
charmap "d",  $44
charmap "e",  $45
charmap "f",  $46
charmap "g",  $47
charmap "h",  $48
charmap "i",  $49
charmap "j",  $4A
charmap "k",  $4B
charmap "l",  $4C
charmap "m",  $4D
charmap "n",  $4E
charmap "o",  $4F
charmap "p",  $50
charmap "q",  $51
charmap "r",  $52
charmap "s",  $53
charmap "t",  $54
charmap "u",  $55
charmap "v",  $56
charmap "w",  $57
charmap "x",  $58
charmap "y",  $59
charmap "z",  $5A
charmap "\{", $5B
charmap "|",  $5C
charmap "\}", $5D
charmap "~",  $5E
