INCLUDE "src/constants/explore_constants.inc"

SECTION "Explore Screen State", WRAM0
	wExploreState:: db

SECTION "Explore Screen State Change Functions", ROMX

InitExploreMenuState::
	ld a, EXPLORE_STATE_NORMAL
	ld [wExploreState], a
	ret
