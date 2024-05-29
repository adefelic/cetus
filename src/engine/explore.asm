INCLUDE "src/constants/constants.inc"

SECTION "Explore Screen State", WRAM0
	wInExploreMenu:: db

SECTION "Explore Screen State Change Functions", ROMX

InitExploreMenuState::
	ld a, FALSE
	ld [wInExploreMenu], a
	ret
