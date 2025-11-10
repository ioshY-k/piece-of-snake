class_name UpgradeCard extends Control

const GHOST_FRUIT_KEYWORD: String = "[color=#b9c1eb]Ghost Fruit[/color] [img=40]res://Shop/UI/KeywordGhostFruitSymbol.svg[/img]"
const TASTY_KEYWORD: String = "[color=#5fedd1]Tasty[/color] [img=40]res://Shop/UI/KeywordTastySymbol.svg[/img]"
const ADVANCEMENT_KEYWORD: String = "[color=#fff87d]Advancement[/color][img=40]res://Shop/UI/KeywordAdvancementSymbol.svg[/img]"
const HOLLOW_KEYWORD: String = "[color=#eb72d8]Hollow[/color] [img=40]res://Shop/UI/KeywordHollowSymbol.svg[/img]"
const DENSE_KEYWORD: String = "[color=#ab3076]Dense[/color] [img=40]res://Shop/UI/KeywordDenseSymbol.svg[/img]"
const PHASING_KEYWORD: String = "[color=#d1ff94]Phasing[/color] [img=40]res://Shop/UI/KeywordPhasingSymbol.svg[/img]"
const SHIELDED_KEYWORD: String = "[color=#e0b798]Shielded[/color] [img=40]res://Shop/UI/EffectTriggerShieldedSymbol.svg[/img]"

var upgrade_descriptions = {
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_1) : "Uncover more area for your map.\n\nThis card is lost upon reaching the next map.",
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_2) : ADVANCEMENT_KEYWORD+". Uncover even more area for your map.\n\nThis card is lost upon reaching the next map.",
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_3) : ADVANCEMENT_KEYWORD+". Uncover the maximum amount of area.\n\nThis Upgrade is lost upon reaching the next map.",
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1) : "Attract fruit in front of you.",
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2) : ADVANCEMENT_KEYWORD+". Attract fruit in a radius around you.",
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3) : ADVANCEMENT_KEYWORD+". Attract fruit in a larger radius.",
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_1) : "Gain a larger Sprint Meter.",
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_2) : ADVANCEMENT_KEYWORD+". The Sprint Meter refills faster.",
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_3) : ADVANCEMENT_KEYWORD+". The Sprint Meter is always usable, even before it filled up.",
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1) : "Every 3 collected Fruits a " + GHOST_FRUIT_KEYWORD + " will appear.",
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2) : ADVANCEMENT_KEYWORD+". The longer a " + GHOST_FRUIT_KEYWORD + " is left uncollected, the more " + TASTY_KEYWORD + " it becomes.",
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3) : ADVANCEMENT_KEYWORD+". A " + GHOST_FRUIT_KEYWORD + " will appear for every 2 collected fruits.",
	str(GameConsts.UPGRADE_LIST.EDGE_WRAP) : "When exiting the screen, enter on the opposite side.\n\nYou can't use other Teleporters",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1) : "All Fruits change their position.\n\nUsable up to 2 times.",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2) : ADVANCEMENT_KEYWORD+". All fruits change their position.\n\nUsable up to 4 times.",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3) : ADVANCEMENT_KEYWORD+". All fruits change their position.\n\nUsable up to 6 times.",
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_1) : "Place a persisting Crossroad where your Head is.\n\nBodyparts on top of it are "+PHASING_KEYWORD+".\n\nUsable up to 1 time.",
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_2) : ADVANCEMENT_KEYWORD+". Place a persisting 3x3 Crossroad where your Head is.\n\nBodyparts on top of it are "+PHASING_KEYWORD+".\n\nUsable up to 1 time.",
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_3) : ADVANCEMENT_KEYWORD+". Place a persisting 3x3 Crossroad where your Head is.\n\nBodyparts on top of it are "+PHASING_KEYWORD+".\n\nUsable up to 2 times.",
	str(GameConsts.UPGRADE_LIST.TAIL_CUT) : "One time per round you can cut off your tail by surpassing it",
	str(GameConsts.UPGRADE_LIST.CORNER_PHASING) : "Corners you take are "+PHASING_KEYWORD+".",
	str(GameConsts.UPGRADE_LIST.KNOT_SLOWMO) : "Gain time whenever you surpass your body",
	str(GameConsts.UPGRADE_LIST.ITEM_RELOADER) : "When reaching the fruit requirement, all active Items get refilled",
	str(GameConsts.UPGRADE_LIST.IMMUTABLE) : "Within the first 25 seconds, 5 "+ GHOST_FRUIT_KEYWORD +" will spawn. If exactly 5 "+ GHOST_FRUIT_KEYWORD +" are on the map, all Fruits become "+ HOLLOW_KEYWORD +".\n\nYou can't be dealt map space cards.",
	str(GameConsts.UPGRADE_LIST.MOULTING) : "Remove every Body Modification.\n\nBuying a card doesn't lock you out Rerolls.\n\nSet the Reroll cost to 0\nReroll cost starts at 0",
	str(GameConsts.UPGRADE_LIST.ANCHOR) : "No longer auto move forward and become invincible while standing still.\n\nLose 2 Points when hitting an obstacle",
	str(GameConsts.UPGRADE_LIST.TIME_STOP_1) : "Stop moving for as long as the button is held down (max. 10s).\n\nBecome invincible while standing still.\n\nUsable up to 3 times.",
	str(GameConsts.UPGRADE_LIST.TIME_STOP_2) : ADVANCEMENT_KEYWORD+". Holding any direction while stopping rewinds your steps up to 7 steps\n\nUsable up to 3 times.",
	str(GameConsts.UPGRADE_LIST.TIME_STOP_3) : ADVANCEMENT_KEYWORD+". Holding any direction while stopping rewinds your steps an unlimited amount\n\nUsable up to 3 times.",
	str(GameConsts.UPGRADE_LIST.WORMHOLE_1) : "Create a Teleporter in front of you and choose its destination tile.\n\nThe Teleporter disappears after it is used.\n\nUsable up to 2 times.",
	str(GameConsts.UPGRADE_LIST.WORMHOLE_2) : ADVANCEMENT_KEYWORD+". Create a Teleporter in front of you and choose its destination tile.\n\nThe Teleporter disappears after it is used.\n\nUsable up to 4 times.",
	str(GameConsts.UPGRADE_LIST.WORMHOLE_3) : ADVANCEMENT_KEYWORD+". Create a Teleporter in front of you and choose its destination tile.\n\nThe Teleporter disappears after it is used.\n\nUsable up to 6 times.",
	str(GameConsts.UPGRADE_LIST.PIGGY_BANK) : "When destroying this Item, lower the Fruit requirement for the next round by 5",
	str(GameConsts.UPGRADE_LIST.SWISS_KNIVE) : "Body Modifications become more effective.\n\nChanges will be marked in blue in their description once bought",
	str(GameConsts.UPGRADE_LIST.SALE) : "Whenever cards are dealt \nReduce the cost of a random card by 1 for each filled card category",
	str(GameConsts.UPGRADE_LIST.DIET_1) : "Fruits are likeley to be "+HOLLOW_KEYWORD+", when collected in quick succession.",
	str(GameConsts.UPGRADE_LIST.DIET_2) : ADVANCEMENT_KEYWORD+". Probability for "+HOLLOW_KEYWORD+" lowers half as fast when collecting Fruits beyond the requirement.",
	str(GameConsts.UPGRADE_LIST.DIET_3) : ADVANCEMENT_KEYWORD+". Probabilities for "+HOLLOW_KEYWORD+" lower slower.",
	str(GameConsts.UPGRADE_LIST.COATING) : "Become "+SHIELDED_KEYWORD+" for your first hit.",
	str(GameConsts.UPGRADE_LIST.STEEL_HELMET) : "Become "+SHIELDED_KEYWORD+" while sprinting.\n\nDoes not work when running into your own body.",
	str(GameConsts.UPGRADE_LIST.RUBBER_BAND) : "Long straights create pressure points in their center.\nPassing through them gives short invincibility.",
	str(GameConsts.UPGRADE_LIST.FUEL_1) : "Collecting Fruits while sprinting completely fills the Sprint Meter, as long as your Sprint Meter is more than half empty.\n\nFruits collected this way have a 3 in 4 chance to be "+TASTY_KEYWORD+".",
	str(GameConsts.UPGRADE_LIST.FUEL_2) : ADVANCEMENT_KEYWORD+".\n\nFruits collected this way also have a 3 in 4 chance to be "+HOLLOW_KEYWORD+".",
	str(GameConsts.UPGRADE_LIST.FUEL_3) : ADVANCEMENT_KEYWORD+".\n\nThe chances for the Fruit becoming "+TASTY_KEYWORD+" and "+HOLLOW_KEYWORD+" are 100%",
	str(GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1) : "Using Active Items and Teleporters cause fruits to move toward you.",
	str(GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2) : ADVANCEMENT_KEYWORD+". Using Active Items and Teleporters cause fruits to move toward you for longer.",
	str(GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3) : ADVANCEMENT_KEYWORD+". Using Active Items and Teleporters cause fruits to move toward you even longer.",
	str(GameConsts.UPGRADE_LIST.BIG_FRUIT_1) : "Spawning fruits have a 30% chance to become big. Fruits grown that way can't move anymore.",
	str(GameConsts.UPGRADE_LIST.BIG_FRUIT_2) : ADVANCEMENT_KEYWORD+". Spawning fruits have a 60% chance to become big. Fruits grown that way can't move anymore.",
	str(GameConsts.UPGRADE_LIST.BIG_FRUIT_3) : ADVANCEMENT_KEYWORD+". Spawning fruits have a 60% chance to become big even more. Fruits grown that way can't move anymore.",
	str(GameConsts.UPGRADE_LIST.PACMAN_1) : "Spawn a "+GHOST_FRUIT_KEYWORD+" that moves away from you.\n\nUsable up to 3 times.",
	str(GameConsts.UPGRADE_LIST.PACMAN_2) : ADVANCEMENT_KEYWORD+". Spawn a "+GHOST_FRUIT_KEYWORD+" that moves away from you.\n\nUsable up to 5 times.",
	str(GameConsts.UPGRADE_LIST.PACMAN_3) : ADVANCEMENT_KEYWORD+". Spawn a "+GHOST_FRUIT_KEYWORD+" that moves away from you.\n\nUsable up to 7 times.",
	str(GameConsts.UPGRADE_LIST.SNEK_1) : "Stand still as your body length shrinks as long as the button is held down.\n\nAfter a short while grow back to normal size.\n\nUsable up to 2 times.",
	str(GameConsts.UPGRADE_LIST.SNEK_2) : ADVANCEMENT_KEYWORD+". Shrinking happens at sprint speed\n\nUsable up to 2 time.",
	str(GameConsts.UPGRADE_LIST.SNEK_3) : ADVANCEMENT_KEYWORD+". Shrinking happens at sprint speed\n\nUsable up to 3 times.",
	str(GameConsts.UPGRADE_LIST.PLANT_SNAKE) : "Whenever you get hit, a "+GHOST_FRUIT_KEYWORD+" will grow attached to your Tail",
	str(GameConsts.UPGRADE_LIST.DIFFUSION) : "Every fruit that would move onto your body, automatically gets collected",
	str(GameConsts.UPGRADE_LIST.SHINY_GHOST) : "1 in 3 times "+GHOST_FRUIT_KEYWORD+" are "+ TASTY_KEYWORD +".",
	str(GameConsts.UPGRADE_LIST.POWER_NAP) : "While Standing still, your Sprint Meter refills twice as fast",
	str(GameConsts.UPGRADE_LIST.CATCH) : "Moving Fruits have a 1 in 3 chance to be " + TASTY_KEYWORD + ".",
	str(GameConsts.UPGRADE_LIST.DANCE) : "Whenever you move, all Fruits move in the opposite direction.\n\nThis movement overrides any other Fruit movement.",
	str(GameConsts.UPGRADE_LIST.OVERFED) : "Fill every empty Card slot with dead mice, which can't be replaced. Buying map space cards destroys a dead mouse for a random Item.",
	str(GameConsts.UPGRADE_LIST.HALF_GONE) : "After collecting a fruit, your front half becomes "+PHASING_KEYWORD+" for a set time.\n\nAll Fruits are "+DENSE_KEYWORD+".",
	str(GameConsts.UPGRADE_LIST.ALLERGY) : GHOST_FRUIT_KEYWORD+ " spawn over time. Eating them does not affect your Points, but makes them spawn faster.\n\nGet points for every uncollected Fruit on the map.\n\nFruits move towards you.",
	}

var upgrade_names = {
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_1) : "MAP SPACE 1",  
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_2) : "MAP SPACE 2",  
	str(GameConsts.UPGRADE_LIST.AREA_SIZE_3) : "MAP SPACE 3",  
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1) : "MAGNET 1",  
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2) : "MAGNET 2",  
	str(GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3) : "MAGNET 3",  
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_1) : "SPRINTER 1",  
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_2) : "SPRINTER 2",  
	str(GameConsts.UPGRADE_LIST.HYPER_SPEED_3) : "SPRINTER 3",  
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1) : "ECHO FRUIT 1",   
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2) : "ECHO FRUIT 2",
	str(GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3) : "ECHO FRUIT 3",
	str(GameConsts.UPGRADE_LIST.EDGE_WRAP) : "THE CHEATER",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1) : "BLENDER 1",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2) : "BLENDER 2",
	str(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3) : "BLENDER 3",
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_1) : "CROSSING 1",   
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_2) : "CROSSING 2",  
	str(GameConsts.UPGRADE_LIST.CROSS_ROAD_3) : "CROSSING 3",
	str(GameConsts.UPGRADE_LIST.TAIL_CUT) : "CAUDAL AUTONOMY",  
	str(GameConsts.UPGRADE_LIST.CORNER_PHASING) : "CORNER PHASING",  
	str(GameConsts.UPGRADE_LIST.KNOT_SLOWMO) : "KNOT",  
	str(GameConsts.UPGRADE_LIST.ITEM_RELOADER) : "RELOAD",  
	str(GameConsts.UPGRADE_LIST.IMMUTABLE) : "THE IMMUTABLE",  
	str(GameConsts.UPGRADE_LIST.MOULTING) : "THE MOULTING",  
	str(GameConsts.UPGRADE_LIST.ANCHOR) : "THE ANCHOR",  
	str(GameConsts.UPGRADE_LIST.TIME_STOP_1) : "TIME STOP 1",  
	str(GameConsts.UPGRADE_LIST.TIME_STOP_2) : "TIME STOP 2",  
	str(GameConsts.UPGRADE_LIST.TIME_STOP_3) : "TIME STOP 3",  
	str(GameConsts.UPGRADE_LIST.WORMHOLE_1) : "WORM HOLE 1",  
	str(GameConsts.UPGRADE_LIST.WORMHOLE_2) : "WORM HOLE 2",  
	str(GameConsts.UPGRADE_LIST.WORMHOLE_3) : "WORM HOLE 3",  
	str(GameConsts.UPGRADE_LIST.PIGGY_BANK) : "PIGGY BANK",  
	str(GameConsts.UPGRADE_LIST.SWISS_KNIVE) : "SWISS KNIVE",  
	str(GameConsts.UPGRADE_LIST.SALE) : "SALE",  
	str(GameConsts.UPGRADE_LIST.DIET_1) : "DIET 1",  
	str(GameConsts.UPGRADE_LIST.DIET_2) : "DIET 2",  
	str(GameConsts.UPGRADE_LIST.DIET_3) : "DIET 3",  
	str(GameConsts.UPGRADE_LIST.COATING) : "COATING",  
	str(GameConsts.UPGRADE_LIST.STEEL_HELMET) : "LOCOMOTIVE",  
	str(GameConsts.UPGRADE_LIST.RUBBER_BAND) : "RUBBER BAND",  
	str(GameConsts.UPGRADE_LIST.FUEL_1) : "FUEL 1",  
	str(GameConsts.UPGRADE_LIST.FUEL_2) : "FUEL 2",  
	str(GameConsts.UPGRADE_LIST.FUEL_3) : "FUEL 3",  
	str(GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1) : "MAGIC FLUTE 1",  
	str(GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2) : "MAGIC FLUTE 2",  
	str(GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3) : "MAGIC FLUTE 3",  
	str(GameConsts.UPGRADE_LIST.BIG_FRUIT_1) : "FERTILIZER 1",  
	str(GameConsts.UPGRADE_LIST.BIG_FRUIT_2) : "FERTILIZER 2",  
	str(GameConsts.UPGRADE_LIST.BIG_FRUIT_3) : "FERTILIZER 3",  
	str(GameConsts.UPGRADE_LIST.PACMAN_1) : "PAC SNAKE 1",  
	str(GameConsts.UPGRADE_LIST.PACMAN_2) : "PAC SNAKE 2",  
	str(GameConsts.UPGRADE_LIST.PACMAN_3) : "PAC SNAKE 3",  
	str(GameConsts.UPGRADE_LIST.SNEK_1) : "SNEK 1",  
	str(GameConsts.UPGRADE_LIST.SNEK_2) : "SNEK 2",  
	str(GameConsts.UPGRADE_LIST.SNEK_3) : "SNEK 3",  
	str(GameConsts.UPGRADE_LIST.PLANT_SNAKE) : "PLANT SNAKE",  
	str(GameConsts.UPGRADE_LIST.DIFFUSION) : "DIFFUSION",  
	str(GameConsts.UPGRADE_LIST.SHINY_GHOST) : "SHINY GHOST",  
	str(GameConsts.UPGRADE_LIST.POWER_NAP) : "POWER NAP",  
	str(GameConsts.UPGRADE_LIST.CATCH) : "CATCH",  
	str(GameConsts.UPGRADE_LIST.DANCE) : "THE DANCE", 
	str(GameConsts.UPGRADE_LIST.OVERFED) : "THE OVERFED",
	str(GameConsts.UPGRADE_LIST.HALF_GONE) : "THE HALF EMPTY",
	str(GameConsts.UPGRADE_LIST.ALLERGY) : "THE ALLERGY"
	}

var font_colors = {
	str(GameConsts.UPGRADE_TYPE.DEFAULT) : Color(0.59, 0.59, 0.59),
	str(GameConsts.UPGRADE_TYPE.PASSIVE) : Color(0.88, 0.662, 0.484),
	str(GameConsts.UPGRADE_TYPE.BODYMOD) : Color(0.435, 0.82, 0.454),
	str(GameConsts.UPGRADE_TYPE.SYNERGY) : Color(0.333, 0.72, 0.9),
	str(GameConsts.UPGRADE_TYPE.ACTIVE) : Color(0.81, 0.405, 0.412),
	str(GameConsts.UPGRADE_TYPE.SPECIAL) : Color(0.707, 0.538, 0.96)
}

var swiss_knive_upgrade_descriptions = {
	str(GameConsts.UPGRADE_LIST.TAIL_CUT) : "One time per round, cut off your tail when surpassing it.\n\n[color=#4fabf9]Cuttable tailpart is bigger[/color]",
	str(GameConsts.UPGRADE_LIST.CORNER_PHASING) : "Corners you take are "+PHASING_KEYWORD+".\n\n[color=#4fabf9]NO SWISS KNIVE EFFECT - Suggestions are welcome:)[/color]",
	str(GameConsts.UPGRADE_LIST.COATING) : "Become "+SHIELDED_KEYWORD+" for your first [color=#4fabf9]and second[/color] hit.",
	str(GameConsts.UPGRADE_LIST.STEEL_HELMET) : "Become "+SHIELDED_KEYWORD+" while sprinting.\n\n[color=#4fabf9]Does also work when running into your own body.[/color]",
	str(GameConsts.UPGRADE_LIST.RUBBER_BAND) : "Long straights create pressure points in their center.\nPassing through them gives [color=#4fabf9]longer invincibility[/color]",
	str(GameConsts.UPGRADE_LIST.PLANT_SNAKE) : "Whenever you get hit, a "+GHOST_FRUIT_KEYWORD+" will grow attached to your Tail\n\n[color=#4fabf9]1 in 3 times "+GHOST_FRUIT_KEYWORD+" are "+HOLLOW_KEYWORD+".[/color]",
	str(GameConsts.UPGRADE_LIST.DIFFUSION) : "Every fruit that would move onto your body, automatically gets collected\n\n[color=#4fabf9]When Diffusion happens, all Fruits move towards you[/color]",
}

var tooltip_descriptions = {
	str(GameConsts.KEYWORDS.ADVAMCEMENT): ADVANCEMENT_KEYWORD + "\nKeep the effects of the card you are replacing.\n\n",
	str(GameConsts.KEYWORDS.TASTY): TASTY_KEYWORD + "\nTasty fruits give an additional point when collected.\n\n",
	str(GameConsts.KEYWORDS.DENSE): DENSE_KEYWORD + "\nDense fruits make you grow more when collected.\n\n",
	str(GameConsts.KEYWORDS.HOLLOW): HOLLOW_KEYWORD + "\nHollow fruits make you grow one less when collected.\n\n",
	str(GameConsts.KEYWORDS.SHIELDED): SHIELDED_KEYWORD + "\nDon't lose points when running into an obstacle.\n\n",
	str(GameConsts.KEYWORDS.GHOST_FRUIT): GHOST_FRUIT_KEYWORD + "\nA type of Fruit that does not cause another fruit to spawn.\n\n",
	str(GameConsts.KEYWORDS.PHASING): PHASING_KEYWORD + "\nPhasing Bodyparts are allowed to be overlapped once.\n\n"
	
}

var mouse_in: bool = false
var is_dragging: bool = false
@onready var card_shadow: Sprite2D = $CardSprite/CardShadow
@onready var card_sprite: AnimatedSprite2D = $CardSprite
@onready var card_area: Area2D = $CardArea
@onready var sale_number: Label = $CardSprite/SaleTag/SaleNumber
@export var upgrade_id: int
@onready var card_snap_audio: AudioStreamPlayer = $CardSnapAudio
@onready var card_select_audio: AudioStreamPlayer = $CardSelectAudio
@onready var card_deselect_audio: AudioStreamPlayer = $CardDeselectAudio
@onready var card_buy_audio: AudioStreamPlayer = $CardBuyAudio

@export var is_play_button = false

var upgrade_description: String
var upgrade_name: String
var font_color: Color
var keyword_descriptions: Array[String]
var upgrade_type: int
var is_advanced: bool
var has_advancements: bool

var owned_slot_area: Area2D = null

var base_price: int = 4
var price: int
var is_bought: bool = false
signal bought
signal destroyed

signal got_clicked
signal let_go
signal hovered

var shop: Shop
var item_shelf
	
func _ready() -> void:
	if is_play_button:
		let_go.connect(play_hovered_mode)
		return
	#globally accessed since salamander start Item is not added to Itemshelf as parent
	shop = get_node("/root/MainSceneLoader/RunManager/Shop")
	item_shelf = get_node("/root/MainSceneLoader/RunManager/Shop/ItemShelf")
	
	got_clicked.connect(shop._on_got_clicked)
	bought.connect(shop._on_upgrade_card_bought)
	destroyed.connect(shop._on_upgrade_destroyed)
	let_go.connect(shop._on_let_go)
	hovered.connect(item_shelf.change_item_description)

func turn_into_playbutton():
	card_sprite.play("play_button_anim")

func play_hovered_mode():
	if card_area.get_overlapping_areas().is_empty():
		print("empty")
		return
	
	var play_area: Area2D = card_area.get_overlapping_areas()[0]
	match play_area.name:
		"EasyArea":
			get_parent()._on_easy_run_pressed()
		"NormalArea":
			get_parent()._on_normal_run_pressed()
		"HardArea":
			get_parent()._on_hard_run_pressed()
	

func instantiate_upgrade_card(id: int):
	upgrade_id = id
	card_sprite.frame = id
	upgrade_description = upgrade_descriptions[str(id)]
	upgrade_name = upgrade_names[str(id)]
	font_color = font_colors[str(GameConsts.get_upgrade_type(id))]
	if id == GameConsts.UPGRADE_LIST.AREA_SIZE_2 or\
	id == GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3 or\
	id == GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3 or\
	id == GameConsts.UPGRADE_LIST.HYPER_SPEED_2 or\
	id == GameConsts.UPGRADE_LIST.HYPER_SPEED_3 or\
	id == GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2 or\
	id == GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3 or\
	id == GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_2 or\
	id == GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_3 or\
	id == GameConsts.UPGRADE_LIST.CROSS_ROAD_2 or\
	id == GameConsts.UPGRADE_LIST.CROSS_ROAD_3 or\
	id == GameConsts.UPGRADE_LIST.TIME_STOP_2 or\
	id == GameConsts.UPGRADE_LIST.TIME_STOP_3 or\
	id == GameConsts.UPGRADE_LIST.WORMHOLE_2 or\
	id == GameConsts.UPGRADE_LIST.WORMHOLE_3 or\
	id == GameConsts.UPGRADE_LIST.DIET_2 or\
	id == GameConsts.UPGRADE_LIST.DIET_3 or\
	id == GameConsts.UPGRADE_LIST.FUEL_2 or\
	id == GameConsts.UPGRADE_LIST.FUEL_3 or\
	id == GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2 or\
	id == GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3 or\
	id == GameConsts.UPGRADE_LIST.PACMAN_2 or\
	id == GameConsts.UPGRADE_LIST.PACMAN_3 or\
	id == GameConsts.UPGRADE_LIST.SNEK_2 or\
	id == GameConsts.UPGRADE_LIST.SNEK_3 or\
	id == GameConsts.UPGRADE_LIST.BIG_FRUIT_2 or\
	id == GameConsts.UPGRADE_LIST.BIG_FRUIT_3:
		keyword_descriptions.append(tooltip_descriptions[str(GameConsts.KEYWORDS.ADVAMCEMENT)])
	if id == GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1 or\
	id == GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2 or\
	id == GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3 or\
	id == GameConsts.UPGRADE_LIST.PACMAN_1 or\
	id == GameConsts.UPGRADE_LIST.PACMAN_2 or\
	id == GameConsts.UPGRADE_LIST.PACMAN_3 or\
	id == GameConsts.UPGRADE_LIST.PLANT_SNAKE or\
	id == GameConsts.UPGRADE_LIST.IMMUTABLE or\
	id == GameConsts.UPGRADE_LIST.SHINY_GHOST:
		keyword_descriptions.append(tooltip_descriptions[str(GameConsts.KEYWORDS.GHOST_FRUIT)])
	if id == GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2 or\
	id == GameConsts.UPGRADE_LIST.CATCH or\
	id == GameConsts.UPGRADE_LIST.FUEL_1 or\
	id == GameConsts.UPGRADE_LIST.FUEL_3 or\
	id == GameConsts.UPGRADE_LIST.ALLERGY or\
	id == GameConsts.UPGRADE_LIST.SHINY_GHOST:
		keyword_descriptions.append(tooltip_descriptions[str(GameConsts.KEYWORDS.TASTY)])
	if id == GameConsts.UPGRADE_LIST.CROSS_ROAD_1 or\
	id == GameConsts.UPGRADE_LIST.CROSS_ROAD_2 or\
	id == GameConsts.UPGRADE_LIST.CROSS_ROAD_3 or\
	id == GameConsts.UPGRADE_LIST.HALF_GONE or\
	id == GameConsts.UPGRADE_LIST.CORNER_PHASING:
		keyword_descriptions.append(tooltip_descriptions[str(GameConsts.KEYWORDS.PHASING)])
	if id == GameConsts.UPGRADE_LIST.IMMUTABLE or\
	id == GameConsts.UPGRADE_LIST.FUEL_2 or\
	id == GameConsts.UPGRADE_LIST.FUEL_3 or\
	id == GameConsts.UPGRADE_LIST.DIET_1 or\
	id == GameConsts.UPGRADE_LIST.DIET_2 or\
	id == GameConsts.UPGRADE_LIST.DIET_3:
		keyword_descriptions.append(tooltip_descriptions[str(GameConsts.KEYWORDS.HOLLOW)])
	if id == GameConsts.UPGRADE_LIST.HALF_GONE:
		keyword_descriptions.append(tooltip_descriptions[str(GameConsts.KEYWORDS.DENSE)])
	if id == GameConsts.UPGRADE_LIST.STEEL_HELMET or\
	id == GameConsts.UPGRADE_LIST.COATING:
		keyword_descriptions.append(tooltip_descriptions[str(GameConsts.KEYWORDS.SHIELDED)])
	is_advanced = GameConsts.advanced_upgrades.has(upgrade_id)
	has_advancements = GameConsts.upgrades_with_advancement.has(upgrade_id)
	upgrade_type = GameConsts.get_upgrade_type(id)
	price = calculate_price()

	

func _process(delta: float) -> void:
	drag_logic(delta)

func drag_logic(delta: float):
	#shadow always follows card
	card_shadow.position = Vector2(.12, 12).rotated(card_sprite.rotation)
	
	#all interacting logic works only on a single card, and only if mouse hovers or drags it
	if (mouse_in or is_dragging) and (GameConsts.node_being_dragged == null or GameConsts.node_being_dragged == self):
		#card is being dragged
		if Input.is_action_pressed("click"):
			#card is just now being dragged
			if Input.is_action_just_pressed("click"):
				card_select_audio.play()
				if not is_bought:
					got_clicked.emit(self)
			global_position = lerp(global_position, get_global_mouse_position() - (size/2.0), 22*delta)
			_change_scale(Vector2(0.7,0.7))
			_set_rotation(delta)
			card_sprite.z_index = 100
			is_dragging = true
			GameConsts.node_being_dragged = self
		#card is only being hovered
		else:
			_change_scale(Vector2(1.42,1.42))
			card_sprite.rotation_degrees = lerp(card_sprite.rotation_degrees, 0.0, 22*delta)
			#card is just now let go of
			if is_dragging:
				card_deselect_audio.play()
				decide_on_let_go()
				let_go.emit()
			is_dragging = false
			if GameConsts.node_being_dragged == self:
				GameConsts.node_being_dragged = null
		return
	#card is not interacted with
	card_sprite.z_index = 5
	if is_bought:
		_change_scale(Vector2(0.7,0.7))
	else:
		_change_scale(Vector2(1,1))

func decide_on_let_go():
	if is_bought:
		_snap_to_slot(owned_slot_area)
		card_snap_audio.play()
		return
	if card_area.get_overlapping_areas().is_empty():
		return
	owned_slot_area = card_area.get_overlapping_areas()[0]
	
	var replaced_card: UpgradeCard
	if owned_slot_area.get_child(-1) is UpgradeCard:
		replaced_card = owned_slot_area.get_child(-1)
	

	#the upgrade type must be the same as the upgrade type for the slot
	#also: if it is an advanced upgrade, the replaced upgrade has to be the prior version of it
	if upgrade_type == get_slot_type(owned_slot_area.get_parent().get_groups()[0]) and\
	(!is_advanced or (replaced_card != null and replaced_card.upgrade_id == upgrade_id - 1)):
		
		if shop.can_afford(owned_slot_area.get_parent()):
			card_sprite.rotation_degrees = 0
			_snap_to_slot(owned_slot_area)
			card_buy_audio.play()
			if replaced_card != null:
				replaced_card.destroyed.emit(replaced_card.upgrade_id)
				replaced_card.queue_free()
			
			get_parent().remove_child(self)
			owned_slot_area.add_child(self)
			
			await get_tree().process_frame
			is_bought = true
			sale_number.get_parent().hide()
			bought.emit(upgrade_id, owned_slot_area.get_parent())

var current_goal_scale: Vector2 = Vector2(1.2,1.2)
var scale_tween: Tween
func _change_scale(desired_scale: Vector2):
	if desired_scale == current_goal_scale:
		return
	
	if scale_tween:
		scale_tween.kill()
	scale_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	scale_tween.tween_property(card_sprite, "scale", desired_scale, 0.12)
	
	current_goal_scale = desired_scale


var last_pos: Vector2
var max_card_rotation: float = 12.5
func _set_rotation(delta: float) -> void:
	var desired_rotation: float = clamp((global_position-last_pos).x*0.85, -max_card_rotation, max_card_rotation)
	card_sprite.rotation_degrees = lerp(card_sprite.rotation_degrees, desired_rotation, 12*delta)
	last_pos = global_position


func _snap_to_slot(upgrade_slot: Area2D):
	var start_position = global_position
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "global_position", upgrade_slot.global_position - (size/2), 0.3).from(start_position)

func _on_mouse_entered() -> void:
	if not is_dragging:
		hovered.emit(self)
	mouse_in = true
	
func _on_mouse_exited() -> void:
	mouse_in = false

func get_slot_type(group) -> int:
	match group:
		"Slot Default":
			return GameConsts.UPGRADE_TYPE.DEFAULT
		"Slot Passive":
			return GameConsts.UPGRADE_TYPE.PASSIVE
		"Slot Synergy":
			return GameConsts.UPGRADE_TYPE.SYNERGY
		"Slot Bodymod":
			return GameConsts.UPGRADE_TYPE.BODYMOD
		"Slot Active":
			return GameConsts.UPGRADE_TYPE.ACTIVE
		"Slot Special":
			return GameConsts.UPGRADE_TYPE.SPECIAL
		_:
			print_debug("No Slot Type is matching with card type (maybe it is the play button?)")
			return -1

func calculate_price():
	if GameConsts.test_mode:
		return 0
	
	var modifier = 0
	
	match GameConsts.get_upgrade_type(upgrade_id):
		GameConsts.UPGRADE_TYPE.DEFAULT:
			modifier -= 3
		GameConsts.UPGRADE_TYPE.PASSIVE:
			modifier -= 1
		GameConsts.UPGRADE_TYPE.BODYMOD:
			pass
		GameConsts.UPGRADE_TYPE.SYNERGY:
			modifier += 1
		GameConsts.UPGRADE_TYPE.ACTIVE:
			modifier -= 1
		GameConsts.UPGRADE_TYPE.SPECIAL:
			modifier += 2
	
	if GameConsts.advanced_upgrades.has(upgrade_id):
		modifier += 2
		if not GameConsts.upgrades_with_advancement.has(upgrade_id):
			modifier += 1
	
	return base_price + modifier
