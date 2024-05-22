INCLUDE "src/lib/hUGEDriver/hUGE.inc"

SECTION "pokemoncenter Song Data", ROMX

pokemoncenter::
db 7
dw order_cnt
dw order1, order2, order3, order4
dw duty_instruments, wave_instruments, noise_instruments
dw routines
dw waves

order_cnt: db 8
order1: dw P0,P4,P8,P12
order2: dw P1,P5,P9,P13
order3: dw P2,P6,P10,P14
order4: dw P3,P3,P3,P3

P0:
 dn F#5,1,$C07
 dn ___,0,$000
 dn F_5,1,$C07
 dn ___,0,$000
 dn F#5,1,$C07
 dn ___,0,$000
 dn D_6,1,$C07
 dn ___,0,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn C#6,1,$C07
 dn ___,0,$000
 dn B_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn B_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn G_5,1,$C07
 dn ___,0,$000
 dn F#5,1,$C07
 dn ___,0,$000
 dn E_5,1,$C07
 dn ___,0,$000
 dn F#5,1,$C07
 dn ___,0,$000
 dn G_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn E_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn C#6,1,$C07
 dn ___,0,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn B_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn G_5,1,$C07
 dn ___,0,$000
 dn F#5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn B_5,1,$C07
 dn ___,0,$000
 dn C#6,1,$C07
 dn ___,0,$000
 dn D_6,1,$C07
 dn ___,0,$000
 dn C#6,1,$C07
 dn ___,0,$000
 dn B_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000

P1:
 dn D_6,2,$C0F
 dn ___,0,$000
 dn A_5,2,$C0F
 dn ___,0,$000
 dn D_6,2,$C0F
 dn ___,0,$000
 dn A_6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn G_6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn F#6,2,$C0F
 dn ___,0,$000
 dn E_6,2,$C0F
 dn ___,0,$000
 dn C#6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn ___,0,$C05
 dn ___,0,$C02
 dn A_5,2,$C0B
 dn ___,0,$000
 dn ___,0,$C0A
 dn ___,0,$C08
 dn E_5,2,$C0B
 dn ___,0,$000
 dn ___,0,$C0A
 dn ___,0,$C08
 dn C#6,2,$C0F
 dn ___,0,$000
 dn A_5,2,$C0F
 dn ___,0,$000
 dn C#6,2,$C0F
 dn ___,0,$000
 dn F#6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn E_6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn C#6,2,$C0F
 dn ___,0,$000
 dn D_6,2,$C0F
 dn ___,0,$000
 dn F#6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn ___,0,$C05
 dn ___,0,$C02
 dn A_5,2,$C0B
 dn ___,0,$000
 dn ___,0,$C0A
 dn ___,0,$C08
 dn E_5,2,$C0B
 dn ___,0,$000
 dn ___,0,$C0A
 dn ___,0,$C08

P2:
 dn D_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F#4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn F#4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00
 dn F#4,2,$000
 dn ___,0,$E00
 dn E_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn E_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00
 dn A_4,2,$000
 dn ___,0,$E00
 dn F#4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00
 dn A_4,2,$000
 dn ___,0,$E00

P3:
 dn C_8,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000
 dn C_8,3,$000
 dn ___,0,$000

P4:
 dn F#5,1,$C07
 dn ___,0,$000
 dn F_5,1,$C07
 dn ___,0,$000
 dn F#5,1,$C07
 dn ___,0,$000
 dn D_6,1,$C07
 dn ___,0,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn C#6,1,$C07
 dn ___,0,$000
 dn B_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn B_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn G_5,1,$C07
 dn ___,0,$000
 dn F#5,1,$C07
 dn ___,0,$000
 dn E_5,1,$C07
 dn ___,0,$000
 dn F#5,1,$C07
 dn ___,0,$000
 dn G_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn E_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn C#6,1,$C07
 dn ___,0,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn B_5,1,$C07
 dn ___,0,$000
 dn A_5,1,$C07
 dn ___,0,$000
 dn G_5,1,$C07
 dn ___,0,$000
 dn F#5,1,$C0D
 dn ___,0,$000
 dn E_5,1,$C0D
 dn ___,0,$000
 dn D_5,1,$C0D
 dn ___,0,$000
 dn E_5,1,$C0D
 dn ___,0,$000
 dn F#5,1,$C0D
 dn ___,0,$000
 dn G_5,1,$C0D
 dn ___,0,$000
 dn A_5,1,$C0D
 dn ___,0,$000
 dn B_5,1,$C0D
 dn ___,0,$000

P5:
 dn D_6,2,$C0F
 dn ___,0,$000
 dn A_5,2,$C0F
 dn ___,0,$000
 dn D_6,2,$C0F
 dn ___,0,$000
 dn A_6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn G_6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn F#6,2,$C0F
 dn ___,0,$000
 dn E_6,2,$C0F
 dn ___,0,$000
 dn C#6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn ___,0,$C05
 dn ___,0,$C02
 dn A_5,2,$C0B
 dn ___,0,$000
 dn ___,0,$C0A
 dn ___,0,$C08
 dn E_5,2,$C0B
 dn ___,0,$000
 dn ___,0,$C0A
 dn ___,0,$C08
 dn C#6,2,$C0F
 dn ___,0,$000
 dn A_5,2,$C0F
 dn ___,0,$000
 dn C#6,2,$C0F
 dn ___,0,$000
 dn F#6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn E_6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn C#6,2,$C0F
 dn ___,0,$000
 dn D_6,2,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0B
 dn ___,0,$C08
 dn ___,0,$C05
 dn ___,0,$C02
 dn ___,0,$000
 dn ___,0,$000
 dn D_5,2,$C0B
 dn ___,0,$000
 dn ___,0,$C0A
 dn ___,0,$C08
 dn E_5,2,$C0B
 dn ___,0,$000
 dn ___,0,$C0A
 dn ___,0,$C08

P6:
 dn D_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F#4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn F#4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00
 dn F#4,2,$000
 dn ___,0,$E00
 dn E_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn E_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00
 dn A_4,2,$000
 dn ___,0,$E00
 dn D_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn F#4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn F#4,2,$000
 dn ___,0,$E00
 dn D_4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00

P8:
 dn F#5,1,$C0E
 dn ___,0,$000
 dn E_5,1,$C0E
 dn ___,0,$000
 dn D_5,1,$C0E
 dn ___,0,$C0B
 dn ___,0,$C09
 dn ___,0,$C07
 dn E_5,1,$C0E
 dn ___,0,$000
 dn F#5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$000
 dn A_5,1,$C0E
 dn ___,0,$000
 dn B_5,1,$C0E
 dn ___,0,$000
 dn A_5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$C0B
 dn ___,0,$C09
 dn ___,0,$C07
 dn E_5,1,$C0E
 dn ___,0,$000
 dn F#5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$000
 dn A_5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$000
 dn F#5,1,$C0E
 dn ___,0,$000
 dn E_5,1,$C0E
 dn ___,0,$C0B
 dn ___,0,$C09
 dn ___,0,$C07
 dn C#5,1,$C0E
 dn ___,0,$000
 dn D_5,1,$C0E
 dn ___,0,$000
 dn E_5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$000
 dn F#5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$000
 dn A_5,1,$C0E
 dn ___,0,$000
 dn B_5,1,$C0E
 dn ___,0,$000
 dn A_5,1,$C0E
 dn ___,0,$C0B
 dn ___,0,$C09
 dn ___,0,$C07
 dn ___,0,$C05
 dn ___,0,$C04
 dn ___,0,$C03
 dn ___,0,$C02

P9:
 dn F#6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn A_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn G_6,3,$C0F
 dn ___,0,$000
 dn A_6,3,$C0F
 dn ___,0,$000
 dn G_6,3,$C0F
 dn ___,0,$000
 dn F#6,3,$C0F
 dn ___,0,$000
 dn E_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn C#6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn E_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn F#6,3,$C0F
 dn ___,0,$000
 dn G_6,3,$C0F
 dn ___,0,$000
 dn F#6,3,$C0F
 dn ___,0,$000
 dn E_6,3,$C0F
 dn ___,0,$000
 dn D_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08

P10:
 dn F#4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn G_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00
 dn B_4,2,$000
 dn ___,0,$E00
 dn E_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,2,$000
 dn ___,0,$E00
 dn F#4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn G#4,2,$000
 dn ___,0,$E00
 dn A_4,2,$000
 dn ___,0,$E00

P12:
 dn D_6,1,$C0E
 dn ___,0,$000
 dn C#6,1,$C0E
 dn ___,0,$000
 dn B_5,1,$C0E
 dn ___,0,$C0B
 dn ___,0,$C09
 dn ___,0,$C07
 dn A_5,1,$C0E
 dn ___,0,$000
 dn B_5,1,$C0E
 dn ___,0,$000
 dn C#6,1,$C0E
 dn ___,0,$000
 dn D_6,1,$C0E
 dn ___,0,$000
 dn E_6,1,$C0E
 dn ___,0,$000
 dn D_6,1,$C0E
 dn ___,0,$000
 dn C#6,1,$C0E
 dn ___,0,$C0B
 dn ___,0,$C09
 dn ___,0,$C07
 dn B_5,1,$C0E
 dn ___,0,$000
 dn C#6,1,$C0E
 dn ___,0,$000
 dn D_6,1,$C0E
 dn ___,0,$000
 dn E_6,1,$C0E
 dn ___,0,$000
 dn C#6,1,$C0E
 dn ___,0,$000
 dn B_5,1,$C0E
 dn ___,0,$000
 dn A_5,1,$C0E
 dn ___,0,$C0B
 dn ___,0,$C09
 dn ___,0,$C07
 dn G_5,1,$C0E
 dn ___,0,$000
 dn A_5,1,$C0E
 dn ___,0,$000
 dn B_5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$000
 dn A_5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$000
 dn F#5,1,$C0E
 dn ___,0,$000
 dn E_5,1,$C0E
 dn ___,0,$000
 dn D_5,1,$C0E
 dn ___,0,$000
 dn E_5,1,$C0E
 dn ___,0,$000
 dn F#5,1,$C0E
 dn ___,0,$000
 dn G_5,1,$C0E
 dn ___,0,$000

P13:
 dn F#6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn A_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn G_6,3,$C0F
 dn ___,0,$000
 dn F#6,3,$C0F
 dn ___,0,$000
 dn G_6,3,$C0F
 dn ___,0,$000
 dn A_6,3,$C0F
 dn ___,0,$000
 dn B_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn A_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn G_6,3,$C0F
 dn ___,0,$000
 dn F#6,3,$C0F
 dn ___,0,$000
 dn G_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08
 dn F#6,3,$C0F
 dn ___,0,$000
 dn G_6,3,$C0F
 dn ___,0,$000
 dn F#6,3,$C0F
 dn ___,0,$000
 dn E_6,3,$C0F
 dn ___,0,$000
 dn D_6,3,$C0F
 dn ___,0,$000
 dn ___,0,$C0F
 dn ___,0,$C0E
 dn ___,0,$C0C
 dn ___,0,$C0B
 dn ___,0,$C0A
 dn ___,0,$C08

P14:
 dn F#4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn B_4,2,$000
 dn ___,0,$E00
 dn E_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn G_4,2,$000
 dn ___,0,$E00
 dn F#4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn ___,0,$000
 dn ___,0,$000
 dn A_4,2,$000
 dn ___,0,$E00
 dn G_4,2,$000
 dn ___,0,$E00
 dn E_4,2,$000
 dn ___,0,$E00

duty_instruments:
itSquareinst1:
db 8
db 128
db 240
dw 0
db 128

itSquareinst2:
db 8
db 128
db 243
dw 0
db 128

itSquareinst3:
db 8
db 128
db 245
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
db 4
dw 0
db 128



noise_instruments:
itNoiseinst1:
db 240
dw 0
db 0
ds 2

itNoiseinst2:
db 242
dw 0
db 0
ds 2

itNoiseinst3:
db 241
dw 0
db 116
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

