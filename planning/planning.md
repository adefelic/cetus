new planning doc for short, dark, coastal drpg. roguelike elements, soulslike structure

aesthetics:
- coastal
- gale winds
- seaweed
- humidity
- salt
- driftwood
- skeletons
- driving rain, storms and stillness
- rotting
- stillness, stagnation
	- you can do destruction but also nothing ever changes really? 
	  the world is big and imposing and cannot be changed by an individual
- sinking, but also never changing


rules:
- damage is done to the respective health pool until that pool is depleted. then it does 1.5x damage to the other one. this shows your character being past their limit -- their strength is done. the same goes for move cost. you can kill yourself with your own moves
- your overall str/wk makeup is your character + your worn items
- you aren't necessarily killing things, mostly making them go away enough that you feel the threat is gone
- when you die you reawaken at the start. lose xp not banked. do not lose levels or equipment.
- meditate on experience to bank experience. if you hit a level threshold, you level up.


armor slots:
shroud (over all)
wrists
neck
body
legs
feet
head
hands ?


materials:
- bone
- drift wood
- flint (spark / fire / gunpowder flash)
- linen
	- no phys resistance
- cord / rope
- shell
- carapace / chitin
- fish scale?
- mud - maybe some classes start with mud armor


combat:
- enemies verb for leaving is based off of the damage type of the final blow? kindof like smt4 death animations. or have some enemies override (you cant drown the sun (fuck that's so cool))
- maybe don't show enemy hit points
- attacks do multiple damage types-- 1 physical element and 1 mental
physical damage types: all do damage to hp
- maybe have some damage types be mundane and do less numerically, while some are exotic and do more or are less blockable. make everything weak to blaze for example
	- cut
	- pierce
	- crush
	- drown
	- sting / envenom / poison
	- bind
		- from vines
	- burn (late game?)
		- from burning resin
	- flare / glare / gleam / blaze / blind / obscure
	- pollute / dirty / sully / begrime

mental damage types: all do damage to mp
	- stress / anxiety / fear (feeling)
	- confuse / overwhelm / fog / obscure (cognition)
	- enrages
	- exhaust
	- distract


	- give moves speeds? like bb bg player speed doesn't make sense because there's only one player. move speed is more interesting
	- could also do the pokemon thing where you have a large palette of moves but only get to pick 4. probably too boring when there's only one player unit
	- all this shit can wait 

encounter flow:
	enemy is revealed
	coin flip for who goes first, 50/50
	enemy moves if tails
	then go into turn cycles -- 
		player select
		player move
		if enemy defeated, rewards screen -> get xp
		enemy move
		if player defeated, defeat screen -> go to last bonfire
		loop

status moves: ? ignore statuses for now
rush - puts off balance or scares away
stance? having an aggressive or defensive posture may change combat


stats:
	- endurance
	- willpower
	hp = endurance * 10
	mp = willpower * 10


characters:
	- characters have
		- skill progression
		- equipment progression
		- a resistance sheet (skip for now)
		- a portrait (skip for now)


character list:
	- scarecrow / effigy
		- actions:
			- sway (stress). costs 5% hp
			- deceive (distract) heals 5% hp
			- crow peck (stab) costs 5% mp
			- crow scatter (confuse) costs 10% mp
			- pole strike (bludgeon) costs 10% hp
			- lantern eyes (stress, obscure) costs 5% hp
		- passive abilities:
			"crows appear"
				- every turn has a chance of crows helping?
		- str/wk:
			weaknesses:
				crush
				burn
			strengths:
				sick
				sting
		- initial stats
			- toughness : 10
			- volition : 20
		- weapon progression: - staves both for whacking and for commanding crows
			- rotten stake
			- cedar stave
			- oaken pole
			- iron fork
	- reed tender / dirt farmer / grass warden / keeper
		tool based attacks, vines. plants
		actions:
			sow (heal hp, distract)
			harvest (pierce)
			sweat (trade hp for mp)
			douse (drown)
			tangle (bind)
			graft (trade mp for hp)
			reap (pierce)
		weapon progression:
			- hand scythe
			- great scythe
			- wicked scythe
	- prey
		sneaky and quick like a prey animal
		camouflage
		human / animal (unclear)
		actions:
			hide
			cower
			throw
		initial: "prey is wary" - 75% to move first
		weapon progression:
			- stone
			- sling
			- javelin
			- atlatl
	- hermit
		less weaknesses, more hp
		mental attacks? endurance based?
		blue mage
		human
	- herald
		physically strong
		delusional
		desperate
		good gear that rusts over time?
	- rain caller (appropriation? i think this is fine)
		can make storms happen



encounters can be non-human beings, the land anthropomorphosed, weather, the past
encounters can be helpful, but usually aren't

region encounters
field:
	- scare crow
	- knotted grass
	- vultures
	- thorns
	- vines
	- snake
	- walking bones
		- distress
	- the patriarch (sun)
		- blaze
forest:
	- web
	- spider
	- roots
	- stones
	- memory of fire / invitation of fire
		- blaze
	- sap
	- rabid dog
		- cut
		- gouge
		- distress
		- infect
swamp:
	- flies
		- frustrate
	- still fog
	- will o wisp
	- walking bones
	- rotting creature
	- heaving bog
	- spore bat - like the mold that kills bats making them into mold zombies instead of dead
coast:
	- drifting fog
	- bleached bones
	- beached creature
	- keen/avid gull 
	- sea glass
	- horseshoe crab
	- dying shark
underwater:
	- seaweed dragon
	- green crab
	- old crab
	- anemone
	- jellyfish

smt combat and eo combat both work because you have a lot of moves to use. maybe there should be some roguelike elements where you "remember" the moves from encounters sometimes. maybe it happens when you are hit by something that is strong against you?

combat menus
- skill
	- skill 1
	- skill 2
- item
- leave

- ugh need to find a place to put player hp / mp
	- should really just copy pokemon or something

dungeon crawling, in practice
- hp is like, how am i doing in this fight
- mp is like, how much supplies to i have left
- mp doesn't matter as much to npcs because they only exist for individual encounters

in this system, they are both more like supplies? that doesn't make a lot of sense ...

maybe make it so that MP is a lower pool than HP in general? 

hmm. usually you use mp to restore hp, but not hp to restore mp. is there a way to use both of them as crawling resources without diminishing their importance as encounter resources.
- third resource: aggression? adrenaline? reaction energy. 
	- reaction energy is used to pay for the first N actions. 
		- maybe you get 10 mental and 10 health
			- this is actually creates interesting choices because say on turn 2 you have to choose if you want to use a cheap, weak move or an expensive strong one. cheap move might also mean you get hit again

combat system goals
- show how mind and body are kind of the same thing. they are both the "internal" mind-body as opposed to the "external"
- show how the body can make up for its own deficiencies
	- it is risky and exciting to use a resource you might not have, like when you are out of mp and need to spend hp
	- it feels good to optimize moves



