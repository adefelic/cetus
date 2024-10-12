INCLUDE "src/lib/hUGEDriver/hUGE.inc"

SECTION "town Song Data", ROMX

xMusicTown::
db 8
dw order_cnt
dw order1, order2, order3, order4
dw duty_instruments, wave_instruments, noise_instruments
dw routines
dw waves

order_cnt: db 8
order1: dw P0,P0,P4,P4
order2: dw P1,P1,P5,P5
order3: dw P2,P2,P2,P2
order4: dw P2,P2,P2,P2

P0:
 dn D_4,7,$000
 dn ___,0,$000
 dn E_4,7,$000
 dn ___,0,$000
 dn F#4,7,$000
 dn ___,0,$000
 dn A_4,7,$000
 dn ___,0,$000
 dn B_4,7,$000
 dn ___,0,$000
 dn D_5,7,$000
 dn ___,0,$000
 dn B_4,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn D_5,7,$000
 dn ___,0,$000
 dn B_4,7,$000
 dn ___,0,$000
 dn F#4,7,$000
 dn ___,0,$000
 dn A_4,7,$000
 dn ___,0,$000
 dn D_4,7,$000
 dn ___,0,$000
 dn E_4,7,$000
 dn ___,0,$000
 dn F#4,7,$000
 dn ___,0,$000
 dn A_4,7,$000
 dn ___,0,$000
 dn B_4,7,$000
 dn ___,0,$000
 dn D_5,7,$000
 dn ___,0,$000
 dn E_5,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_5,7,$000
 dn ___,0,$000
 dn F#5,7,$000
 dn ___,0,$000
 dn D_5,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$B00
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

P1:
 dn D_4,3,$000
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
 dn D_4,3,$000
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
 dn A_4,3,$000
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

P2:
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
 dn ___,0,$000
 dn ___,0,$000

P4:
 dn E_5,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_5,3,$000
 dn ___,0,$000
 dn F#5,3,$000
 dn ___,0,$000
 dn D_5,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_5,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_5,3,$000
 dn ___,0,$000
 dn F#5,3,$000
 dn ___,0,$000
 dn D_5,3,$000
 dn ___,0,$000
 dn F#5,3,$000
 dn ___,0,$000
 dn E_5,7,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn E_5,3,$000
 dn ___,0,$000
 dn F#5,3,$000
 dn ___,0,$000
 dn D_5,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,3,$000
 dn ___,0,$000
 dn D_5,3,$000
 dn ___,0,$000
 dn B_4,3,$000
 dn ___,0,$000
 dn G_4,3,$000
 dn ___,0,$000
 dn B_4,3,$000
 dn ___,0,$000
 dn D_5,3,$000
 dn ___,0,$B00
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

P5:
 dn A_4,3,$000
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
 dn A_4,3,$000
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
 dn D_4,3,$000
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

duty_instruments:
itSquareinst1:
db 8
db 0
db 240
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
db 199
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
db 242
dw 0
db 128



wave_instruments:


noise_instruments:


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

