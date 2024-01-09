
SECTION "Encounter Screen Renderer", ROMX

LoadEncounterScreen::
	ld de, Map1Encounter
	ld hl, wShadowTilemap
	ld bc, Map1EncounterEnd - Map1Encounter
	call Memcopy
