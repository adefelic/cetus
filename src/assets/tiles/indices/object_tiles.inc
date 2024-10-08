INCLUDE "src/lib/hardware.inc"

;; tile indices
; compass tiles
DEF TILE_COMPASS_ARROW_UP    EQU 0
DEF TILE_COMPASS_ARROW_RIGHT EQU 1
DEF TILE_COMPASS_CHAR_N      EQU 2
DEF TILE_COMPASS_CHAR_S      EQU 3
DEF TILE_COMPASS_CHAR_E      EQU 4
DEF TILE_COMPASS_CHAR_W      EQU 5

; danger indicator tiles
DEF TILE_DANGER_NONE         EQU 6
DEF TILE_DANGER_TALL_RED     EQU 7
DEF TILE_DANGER_MED_RED      EQU 8
DEF TILE_DANGER_SHORT_RED    EQU 9
DEF TILE_DANGER_TALL_YELLOW  EQU 10
DEF TILE_DANGER_MED_YELLOW   EQU 11
DEF TILE_DANGER_SHORT_YELLOW EQU 12
DEF TILE_DANGER_MED_GREY     EQU 13

; item tiles
DEF TILE_ROCK_A    EQU 14
DEF TILE_ROCK_B    EQU 15
DEF TILE_LAMP_TOP    EQU 16
DEF TILE_LAMP_BOTTOM EQU 17

;; OAM addresses
; compass
DEF OAM_HUD_COMPASS_ARROW EQU $00 * sizeof_OAM_ATTRS
DEF OAM_HUD_COMPASS_CHAR  EQU $01 * sizeof_OAM_ATTRS

; danger indicator
DEF OAM_HUD_DANGER_0 EQU $02 * sizeof_OAM_ATTRS ; short ; ~     ; ~
DEF OAM_HUD_DANGER_1 EQU $03 * sizeof_OAM_ATTRS ; med   ; short ; ~
DEF OAM_HUD_DANGER_2 EQU $04 * sizeof_OAM_ATTRS ; tall  ; med   ; ~
DEF OAM_HUD_DANGER_3 EQU $05 * sizeof_OAM_ATTRS ; tall  ; tall  ; med
DEF OAM_HUD_DANGER_4 EQU $06 * sizeof_OAM_ATTRS ; tall  ; tall  ; med
DEF OAM_HUD_DANGER_5 EQU $07 * sizeof_OAM_ATTRS ; tall  ; med   ; ~
DEF OAM_HUD_DANGER_6 EQU $08 * sizeof_OAM_ATTRS ; med   ; short ; ~
DEF OAM_HUD_DANGER_7 EQU $09 * sizeof_OAM_ATTRS ; short ; ~     ; ~

DEF OAM_ROCK_A    EQU $0E * sizeof_OAM_ATTRS
DEF OAM_ROCK_B    EQU $0F * sizeof_OAM_ATTRS
DEF OAM_LAMP_TOP_L    EQU $10 * sizeof_OAM_ATTRS
DEF OAM_LAMP_TOP_R    EQU $11 * sizeof_OAM_ATTRS
DEF OAM_LAMP_BOTTOM_L EQU $12 * sizeof_OAM_ATTRS
DEF OAM_LAMP_BOTTOM_R EQU $13 * sizeof_OAM_ATTRS
