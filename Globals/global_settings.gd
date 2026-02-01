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

func _ready() -> void:
	load_masteries()
	
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
