extends Node

enum LANGUAGES {ENGLISH, GERMAN}
var language = LANGUAGES.ENGLISH
var keyboard_only: bool = true

var masteries_json_path = "user://masteries.json"
var masteries = {
	"EASY" : {
		"OSTRICH" : false,"PYTHON" : false,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"RETRO" : false,"CENTIPEDE" : false,"TWOHEAD" : false,
		"IMMUTABLE" : false,"MOULTING" : false,"EDGE_WRAP" : false,"DANCE" : false,"HALF_GONE" : false,"ALLERGY" : false,"OVERFED" : false,"ANCHOR" : false,
		"WOODS" : false,"STADIUM" : false,"RESTAURANT" : false,"MAP4" : false,"OFFICE" : false,"CAVE" : false,"TRAIN" : false,"GARDEN" : false,"DISCO" : false,"BEACH" : false,"TOMB" : false,"SPACE" : false
	},
	"NORMAL" : {
		"OSTRICH" : false,"PYTHON" : false,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"RETRO" : false,"CENTIPEDE" : false,"TWOHEAD" : false,
		"IMMUTABLE" : false,"MOULTING" : false,"EDGE_WRAP" : false,"DANCE" : false,"HALF_GONE" : false,"ALLERGY" : false,"OVERFED" : false,"ANCHOR" : false,
		"WOODS" : false,"STADIUM" : false,"RESTAURANT" : false,"MAP4" : false,"OFFICE" : false,"CAVE" : false,"TRAIN" : false,"GARDEN" : false,"DISCO" : false,"BEACH" : false,"TOMB" : false,"SPACE" : false
	},
	"HARD" : {
		"OSTRICH" : false,"PYTHON" : false,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"RETRO" : false,"CENTIPEDE" : false,"TWOHEAD" : false,
		"IMMUTABLE" : false,"MOULTING" : false,"EDGE_WRAP" : false,"DANCE" : false,"HALF_GONE" : false,"ALLERGY" : false,"OVERFED" : false,"ANCHOR" : false,
		"WOODS" : false,"STADIUM" : false,"RESTAURANT" : false,"MAP4" : false,"OFFICE" : false,"CAVE" : false,"TRAIN" : false,"GARDEN" : false,"DISCO" : false,"BEACH" : false,"TOMB" : false,"SPACE" : false
	},
	"ASCENSION" : {
		"OSTRICH" : false,"PYTHON" : false,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"RETRO" : false,"CENTIPEDE" : false,"TWOHEAD" : false,
		"IMMUTABLE" : false,"MOULTING" : false,"EDGE_WRAP" : false,"DANCE" : false,"HALF_GONE" : false,"ALLERGY" : false,"OVERFED" : false,"ANCHOR" : false,
		"WOODS" : false,"STADIUM" : false,"RESTAURANT" : false,"MAP4" : false,"OFFICE" : false,"CAVE" : false,"TRAIN" : false,"GARDEN" : false,"DISCO" : false,"BEACH" : false,"TOMB" : false,"SPACE" : false
	}
}

var character_unlocks_json_path = "user://character_unlocks.json"
var character_unlocks = {
	"OSTRICH" : false,"PYTHON" : true,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"RETRO" : false,"CENTIPEDE" : false,"TWOHEAD" : false
}

var difficulty_unlocks_json_path = "user://difficulty_unlocks.json"
var difficulty_unlocks = {
	"EASY" : true,"NORMAL" : false,"HARD" : false,"ASCENSION" : false
}

func _ready() -> void:
	load_masteries()
	load_character_unlocks()
	load_difficulty_unlocks()
	
func load_masteries():
	var masteries_file = FileAccess.open(masteries_json_path, FileAccess.READ)
	if masteries_file != null:
		var masteries_json = masteries_file.get_as_text()
		var json_object = JSON.new()
		json_object.parse(masteries_json)
		masteries = json_object.data
	save_masteries()

func save_masteries():
	var masteries_file = FileAccess.open(masteries_json_path,FileAccess.WRITE)
	
	if masteries_file:
		var masteries_json = JSON.stringify(masteries, "\t")
		masteries_file.store_string(masteries_json)
	else:
		print_debug("failed to open or create the file")

func reset_masteries():
	for difficulty in masteries.keys():
		var mastery_dict = masteries[difficulty]
		for mastery in mastery_dict.keys():
			mastery_dict[mastery] = false
	save_masteries()

func load_character_unlocks():
	var character_unlocks_file = FileAccess.open(character_unlocks_json_path, FileAccess.READ)
	if character_unlocks_file != null:
		var character_unlocks_json = character_unlocks_file.get_as_text()
		var json_object = JSON.new()
		json_object.parse(character_unlocks_json)
		character_unlocks = json_object.data
	save_character_unlocks()

func save_character_unlocks():
	var character_unlocks_file = FileAccess.open(character_unlocks_json_path,FileAccess.WRITE)
	
	if character_unlocks_file:
		var character_unlocks_json = JSON.stringify(character_unlocks, "\t")
		character_unlocks_file.store_string(character_unlocks_json)
	else:
		print_debug("failed to open or create the file")

func reset_character_unlocks():
	for char in character_unlocks.keys():
		character_unlocks[char] = false
	character_unlocks["PYTHON"] = true
	save_character_unlocks()
	
func unlock_all_characters():
	for char in character_unlocks.keys():
		character_unlocks[char] = true
	save_character_unlocks()
	
func load_difficulty_unlocks():
	var difficulty_unlocks_file = FileAccess.open(difficulty_unlocks_json_path, FileAccess.READ)
	if difficulty_unlocks_file != null:
		var difficulty_unlocks_json = difficulty_unlocks_file.get_as_text()
		var json_object = JSON.new()
		json_object.parse(difficulty_unlocks_json)
		difficulty_unlocks = json_object.data
	save_difficulty_unlocks()

func save_difficulty_unlocks():
	var difficulty_unlocks_file = FileAccess.open(difficulty_unlocks_json_path,FileAccess.WRITE)
	
	if difficulty_unlocks_file:
		var difficulty_unlocks_json = JSON.stringify(difficulty_unlocks, "\t")
		difficulty_unlocks_file.store_string(difficulty_unlocks_json)
	else:
		print_debug("failed to open or create the file")
		
func unlock_all_difficulties():
	for diff in difficulty_unlocks.keys():
		difficulty_unlocks[diff] = true
	save_difficulty_unlocks()
	
func reset_difficulty_unlocks():
	for char in difficulty_unlocks.keys():
		difficulty_unlocks[char] = false
	difficulty_unlocks["EASY"] = true
	save_difficulty_unlocks()
	
