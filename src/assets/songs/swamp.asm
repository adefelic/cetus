INCLUDE "src/lib/hUGEDriver/hUGE.inc"

SECTION "swamp Song Data", ROMX

swamp::
db 18
dw order_cnt
dw order1, order2, order3, order4
dw duty_instruments, wave_instruments, noise_instruments
dw routines
dw waves

order_cnt: db 2
order1: dw P0
order2: dw P1
order3: dw P2
order4: dw P3

P0:
 dn C#4,9,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn C_4,9,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn D#4,9,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_4,9,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C#4,10,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_4,10,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

P1:
 dn ___,0,$E01
 dn E_5,10,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$E01
 dn ___,0,$000
 dn D#5,10,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$E01
 dn F#5,10,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$E01
 dn F#5,10,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$A01
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

P2:
 dn C#6,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_6,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D#6,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_6,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C#6,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

P3:
 dn D_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,1,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_6,2,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000

itSquareSP9:
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,1,$000

duty_instruments:
itSquareinst1:
db 8
db 32
db 28
dw 0
db 128

itSquareinst2:
db 8
db 64
db 240
dw 0
db 128

itSquareinst3:
db 8
db 128
db 240
dw 0
db 128

itSquareinst4:
db 8
db 192
db 240
dw 0
db 128

itSquareinst5:
db 8
db 0
db 241
dw 0
db 128

itSquareinst6:
db 8
db 64
db 241
dw 0
db 128

itSquareinst7:
db 8
db 128
db 241
dw 0
db 128

itSquareinst8:
db 8
db 192
db 241
dw 0
db 128

itSquareinst9:
db 8
db 128
db 45
dw itSquareSP9
db 128

itSquareinst10:
db 4
db 146
db 43
dw 0
db 128



wave_instruments:
itWaveinst1:
db 0
db 32
db 0
dw 0
db 128

itWaveinst2:
db 0
db 32
db 1
dw 0
db 128

itWaveinst3:
db 0
db 32
db 2
dw 0
db 128

itWaveinst4:
db 0
db 32
db 3
dw 0
db 128

itWaveinst5:
db 0
db 32
db 4
dw 0
db 128

itWaveinst6:
db 0
db 32
db 5
dw 0
db 128

itWaveinst7:
db 0
db 64
db 6
dw 0
db 128



noise_instruments:
itNoiseinst1:
db 210
dw 0
db 0
ds 2

itNoiseinst2:
db 163
dw 0
db 71
ds 2



routines:
__hUGE_Routine_0:

__end_hUGE_Routine_0:
ret

__hUGE_Routine_1:

__end_hUGE_Routine_1:
ret

__hUGE_Routine_2:

__end_hUGE_Routine_2:
ret

__hUGE_Routine_3:

__end_hUGE_Routine_3:
ret

__hUGE_Routine_4:

__end_hUGE_Routine_4:
ret

__hUGE_Routine_5:

__end_hUGE_Routine_5:
ret

__hUGE_Routine_6:

__end_hUGE_Routine_6:
ret

__hUGE_Routine_7:

__end_hUGE_Routine_7:
ret

__hUGE_Routine_8:

__end_hUGE_Routine_8:
ret

__hUGE_Routine_9:

__end_hUGE_Routine_9:
ret

__hUGE_Routine_10:

__end_hUGE_Routine_10:
ret

__hUGE_Routine_11:

__end_hUGE_Routine_11:
ret

__hUGE_Routine_12:

__end_hUGE_Routine_12:
ret

__hUGE_Routine_13:

__end_hUGE_Routine_13:
ret

__hUGE_Routine_14:

__end_hUGE_Routine_14:
ret

__hUGE_Routine_15:

__end_hUGE_Routine_15:
ret

waves:
wave0: db 0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255
wave1: db 0,0,0,0,255,255,255,255,255,255,255,255,255,255,255,255
wave2: db 0,0,0,0,0,0,0,0,255,255,255,255,255,255,255,255
wave3: db 0,0,0,0,0,0,0,0,0,0,0,0,255,255,255,255
wave4: db 0,1,18,35,52,69,86,103,120,137,154,171,188,205,222,239
wave5: db 254,220,186,152,118,84,50,16,18,52,86,120,154,188,222,255
wave6: db 122,205,219,117,33,19,104,189,220,151,65,1,71,156,221,184

