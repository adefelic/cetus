new planning doc for short, dark, coastal drpg. roguelike elements, soulslike structure
	- roguelike because you play in short bursts and it makes experimentation more easy



- when in doubt, lean on genre convention


- inspirations
	- smt1, strange journey
		- exploration
		- feeling of being lost
	- buriedbornes
		- roguelike nature
		- growable, interesting character
		- non-combat encounters
		- speed of play
	- pokemon / dragon quest gbc
		- lightweight jrpg systems
		- great menus and legibility
	- vermis
		- art direction
		- feeling of trespass
	- lotr
		- nature, mystery, melancholy
	- dark/demon's souls
	- 


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

### death

- when you run out of mp, spells start costing hp
	- this is good and cool i think
- if you run out of hp, attacks start hurting your mp
- mp is ... energy?
- should there be a mental/physical split
- possible meters
	- hp
		- combat timer / complicator
	- stress
		- stress is like an inverse mana bar. it fills up as your "slog" timer
	- grime / purity / readiness / supplies
		- how dirty are you, is it a problem. slows down your move speed? also essentially a slog timer
		- compounding negative effects?
			- in darkest dungeon, you cant get lost so supplies are a 
	- breadcrumb items on the map
		- things that restore health or mp or energy
		- rocks do nothing
		- lanterns reduce stress maybe once per exploration, or make you not gain stress?
		- 


## moves 

### damage types: (all verbs)
- wound
	- cut / lacerate
	- crush / break
	- sting / envenom (poison)
- inhibit 
	- bind / trap / obstruct (legs? arms?)
	- drown / cant breathe
	- soil / encumber / burden
	- blaze / dazzle (heat / bright)
- mental
	- pressure / stress
	- confuse / distract
	- exhaust / tire
	- lull / trick
	- menace / threaten
	- calm / soothe / appease
	- yield / submit
	- befriend / support / protect / advice
	- respect
		- hell yes
	- welcome

	- animations
		- __name__ CONFUSES __enemy__ . i dont actually like this, it would better to just use the move name? but Move Names are goofy. but useful

	- give moves speeds? like bb bg player speed doesn't make sense because there's only one player. move speed is more interesting
	- could also do the pokemon thing where you have a large palette of moves but only get to pick 4. probably too boring when there's only one player unit
	- all this shit can wait 

### encounter flow:
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


## player classes
characters:
	- characters have
		- skill progression
		- equipment progression
		- a resistance sheet (skip for now)
		- a portrait (skip for now)

character list:
	- scarecrow / effigy
		- actions:
			- sway. stress x multiple. restores mp
			- deceive. confuse x multiple
			- crow peck. stab xx single
			- crow flock. confuse xx single 
			- pole strike. crush xx single
			- spear. cut xxx single
			- lantern eyes. stress xxx multiple
			- wisp / ignite. blaze xxx single
		- passive abilities:
			"crows appear"
				- every turn has a chance of crows helping?
			"sway"
				- passive weak mp regen
				- passive weak stress
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
	- reed keeper
		tool based attacks, vines. plants
		actions:
			sow (heal hp, distract)
			harvest (pierce)
			sweat (trade hp for mp)
			douse (drown)
			tangle (bind)
			weave
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
	- rain caller (appropriation? i think this is fine) / storm witch
		weather magic
		actions:
			- driving rain
			- wind
			- thunder (sound)
			- stillness
			- calm before the storm
			- darken skies


### player stats:
	- endurance
	- willpower
	hp = endurance * 10
	mp = willpower * 10

## enemies
encounters can be non-human beings, the land anthropomorphosed, weather, the past
encounters can be helpful, but usually aren't
field:
	- scare crow (blue / )
		- sway
		- watch
	- knotted grass / vines (green)
		- entangle. * bind multi
		- trip. xx mud single
		- snare
	- marsh hawk (day)
		- watch. pressure xx single
		- harry. confuse xx multi
		- gouge. cut xxx single
	- great owl (night)
		- watch
		- swoop / graze (high damage)
	- green briars (more grabbing)
		- needle. x cut multi
		- entangle. * bind multi
		- trip. xx mud single
		- grasp
		- snare
	- red briars (more cutting)
		- 
	- snake
		- coil. bind xx single
		- fangs. sting xxx single
		- vanish. confuse x multi
	- old bones (skull + ribs + an arm)
		- unnerve. pressure x single
		- grab. bind xxx single
	- the patriarch (sun)
		- glare. blaze xx multi
		- judge. blaze xxxx single
		- wither.
	- prairie chicken
	- blue/red butterfly (Karner Blue Butterfly)
		- stardust
		- starlight
	- sunflower (day) / moonflower (night)
		- sun ray
		- moon ray
	- i want more that arent animals. what are things that can happen
		- recurring text npcs whose quests are advanced whenever you see them (or give them something?)
	- plank bridge
		- break
	- 
forest:
	- spider web
		- tangle. * bind multi
		- become spider. ends encounter and becomes spider encounter
	- spider
		- fangs. sting xxx single
	- roots (piled)
		- tangle. * bind multi
		- trip. xx mud single
	- stone cairn
		- heals mp?
	- memory of fire (sprite, will o wisp)
		- tempt. lull, xx, single
	- ghost of fire (forest fire, the past)
		-
	- old cedar 
		- ooze sap. soil xx single
		- creak
	- foaming creature
		- snap
			- distress, xxx, single
		- stalk
			- distress, xx, multi
		- bite
			- crush, xxx, single
	- wood turtle
	- crow
	- briar puppet / thorn doll (skeleton with briar marionette-ing)

swamp:
	- flies
		- cloud
	- still fog
	- will o wisp
	- walking bones
	- rotting creature
	- heaving bog
	- spore bat - like the mold that kills bats making them into mold zombies instead of dead
	- bog turtle
	- ritual flame

coast:
	- drifting fog
		- confuse. 
	- bleached bones
		- sea water
	- beached creature
		- eject sea water
	- keen gull 
	- sea glass
		- glitter, lull
	- horseshoe crab
		- wait
	- dying shark
		- gasp
		- lurch
	- osprey
	- crawling turtle
underwater:
	- seaweed dragon
	- green crab
	- old crab
	- anemone
	- jellyfish
	- winter skate
	- black grouper
	- greenland shark
	- stranded meteorite
beyond:
	- lost star
	- wild starlike
	- wanderer (comet)
	- starlike abandoned
	- eye
	- ovum
	- void
	- *
	- black hole
	- wave \/\/\/\
	- particle .

# COMBAT

- option 1: simple combat. player does move, enemy does move, repeat until someone is dead. hp only
- option 2: complicated combat


today's combat thoughts:

- attack speed? this could make using a single character more interesting.

- can you cancel an enemy attack by depleting their poise before they can attack? 
	or attacking at a faster speed with a harder hitting move?
	or attacking at the same speed. moves that are aggressive can stagger the enemy to cancel their slower attacks. only some moves stagger

** okay some resolution **
i think that the target complexity should be roughly DRAGON QUEST. you choose a character to give you some flavor, some combat skills and spells, and you mostly are trying to burn as little resources as possible so that you can continue your slog.


smt combat and eo combat both work because you have a lot of moves to use. maybe there should be some roguelike elements where you "remember" the moves from encounters sometimes. maybe it happens when you are hit by something that is strong against you?


- skills have a combat function and a non combat function

## FAVOR / REPUTATION
- favor within an individual encounter
	- "i like you ;)"
- favor with a certain type of npc
	- "my people know you"
- favor with a certain blood
	- "i see we are of a kind"

this could work kind of like world tendency

combat menus
- communicate (you give them something. they give you something or they choose they don't like it. what they like is based on species)
	- use skill
		- you can teach them your skills to make them like you ...
			- some enemies have a chance to help you, sometimes they will use a skill you taught them. very cool amirite
		- you can heal them
		- you can protect them
	- give gift (item)
	- talk (complicated ....)
		- they leave, or
		- they say something?
- defend (wait to see what they do) (could this be functionally the same as leaving?)
	- they will attack or leave

- assault (begin attacking back and forth)
	- skills menu. (combat goes back and forth)


## CURRENCIES

- hp - health points
	- when these are drained, you game over.
	- easy to replenish
	- split into physical and mental ?
- mp - supplies. energy for doing things (rename to en? energy)
	- when these are drained, you are in a pickle
	- hard to replenish
- stress, accrued through:
	- losing too much health (is double jeopardy fun)
	- using magic (?) (that isnt in your affinity?)
	- when these are drained, stress attacks begin to deal double to your hp. sort of a timer before your hp depletes very fast? not sure how that will feel
	- what should be the _feeling_ of dungeon crawling
		- the game should be more toylike than complicated
		- 

- blood
- secrets
	- gained rarely. secrets are associate with 
- objects (items)


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

- multitype moves

- items can be giftable? use shiny items on a crow and they will eventually help you. maybe they will do an extra attack for you if you are in their woods


### case study: pokemon
-  combat incentivizes switching
	- pp (dungeon crawl longetivity resource) is per pokemon
		- not the same as mp. you cant use moves (healing) for pp outside of combat like roost
	- hp (combat resource) is per pokemon
	- only 4 moves per pokemon
- pokemon combat is information dense to display well on a small screen
	- types mean you don't need to display the resistance matrix like in smt
		- the opposing pokemon's type should be intuitive. if it's not, you have a pokedex
	- 4 moves per guy means you dont need to scroll and everything is visible at once


what are interesting choices in rpgs
- short term need vs long term benefit. hp vs mp
- making choices that will minimize harm to your team

how do i make interesting choices. unique class skills are evocative and rad but not interesting enough as gameplay. you just pick rock when you see scissors, or you dont have a rock and pick something else.

how do you create variety in a turn based rpg. dimensions:
0 dimensions:
	- 1 move, 1 resistance
1 dimension:
	- multiple moves, multiple resistances. different enemies are weak to different moves
2 dimensions:
	- multiple party members with different moves / resistances
	- multiple enemies with different moves / resistances

pokemon is essentially always 1 on 1 with switching
smt is 4 on 1-4ish with switching
ff is 4 on 1-4ish without switching
	- different characters still have different moves and resistances
	- in ff4 they arent even all that different beyond different specializations


- you could gain a party member after certain events? but multiple party members makes it feel less lonely
- you could get monsters but maybe they are temporary?

## GRAPHICS

graphics thoughts
- maybe first person combat could be overlaid over the background w/ enemy sprites on top and the Window from the bottom
- maybe walls could be replaced with scribbles + negative space

- move hp/mp and other stats (weather: temperature, humidity, wind, cold fog) should move to the WINDOW at the top of the screen, so you can always see your condition

- leveling up
	- surgically alter stats? insert totems from the environment?
	- slowly transforming your body into gold or other material
		- blood
		- bones
		- skin
		- muscle
	- xp? souls? 


# CHARACTER CREATION

- starting gift for sure
	- if weapons have different skills on them or if i end up making weapons more of a lateral power level that gives moves with speeds ala BBG, weapons you found should become selectable on new characters

## AFFINITIES / IDEALS / COMMUNITIES / ASSOCIATIONS
- maybe your build changes your blood color, that could be a cool representation. 
	our thoughts are as biological as our bones. 
	our subjective reality can be as affecting as objective reality. 
	pick one or two or three
	- are these things that i think are cool? are they ways of being? i think i want them to be ways of being
	- more gold - fundamental - technology
		- creation from nothing, physics, the universe, the future, gravity. the big picture? that sounds too much like mystery or tools
		- border: nebula, stars
		- creation is always moving towards us, blue shifting?
	- more indigo/violet - obscure - mystery / spirituality / psychedelia
		- mystery, the deep sea, dreams
		- border: waves?
	- more green - collective (?)- plant
		- gatherer, staying, spreading, growing
		- border: vines
	- more red - rampant - animal
		- hunter, beasthood, warmth, fur, moving
		- border: bloody teeth
	- more black - dissolute - death
		- death, the past, ghosts, usage, ephemerality, entropy, judgment
		- border: solid black? smoke? creeping dark fog
		- the past is always moving away from us -- red shifting?

	- oppositions
		- the self (knowledge, muscle) / tools (writing, technology)
		- hunting / gathering
		- thinking / feeling
		- internal (consciousness is here) / external (consciousness is not here)
		- hiding / aggression / 

	- from games do int/faith, str/dex, and then the "weird" one
	- i'm not sure if i like plant/animal as a split
	- i don't think i like biome splits either, like terrestrial/aquatic


	- maybe these shouldn't be associated with mechanics. different encounters have different amounts of each stat and their relation to your stats changes how encounters go. kind of like talking in smt?
		- talkable npcs should do eye flashes like in smt1 to show "intelligence"
	- maybe there are rewards you get for hitting certain thresholds of each of these "stats", like new moves or secrets or items

	- maybe you have to give something up to be part of a community. you gradually soften 1/5 or 2/5 of encounters? or they give you stats that are better than straight stat boosts. or your own stat boosts begin to become worthless and their stat boosts benefit you in ways that are helpful



- blood appears around the screen borders, like call of duty red eye but nice looking instead of dumb
	- changes as you get more damaged. two stats, body and mind. mind top of screen, body bottom
	- maybe the border is the thing you put in you reclaiming you. maybe the border gets bigger as you are more hurt


