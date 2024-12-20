a first person dungeon crawler for the gameboy color

written with rgbds

most code is in ROM0
Paint___ routines are in ROMX because they're "leaf nodes" in the call tree and the easiest to switch to without having to bank switch to the banks of routines that they call
