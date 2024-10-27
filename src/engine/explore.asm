INCLUDE "src/constants/constants.inc"

SECTION "Explore Screen State", WRAM0
	wInExploreMenu:: db

SECTION "Explore Screen State Change Functions", ROM0

InitExploreMenuState::
	ld a, FALSE
	ld [wInExploreMenu], a
	ret
