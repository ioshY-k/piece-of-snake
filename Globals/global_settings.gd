extends Node

enum languages {ENGLISH, GERMAN}
var language = languages.GERMAN

var masteries_json_path = "user://masteries.json"
var masteries = {
	"EASY" : {
		"GODOT" : false,"PYTHON" : false,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"CHAR6" : false,"CHAR7" : false,"CHAR8" : false,
		"IMMUTABLE" : false,"MOULTING" : false,"EDGE_WRAP" : false,"DANCE" : false,"HALF_GONE" : false,"ALLERGY" : false,"OVERFED" : false,"ANCHOR" : false,
		"WOODS" : false,"STADIUM" : false,"RESTAURANT" : false,"Map4" : false,"OFFICE" : false,"CAVE" : false,"TRAIN" : false,"Map8" : false,"DISCO" : false,"BEACH" : false,"TOMB" : false,"Map12" : false
	},
	"NORMAL" : {
		"GODOT" : false,"PYTHON" : false,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"CHAR6" : false,"CHAR7" : false,"CHAR8" : false,
		"IMMUTABLE" : false,"MOULTING" : false,"EDGE_WRAP" : false,"DANCE" : false,"HALF_GONE" : false,"ALLERGY" : false,"OVERFED" : false,"ANCHOR" : false,
		"WOODS" : false,"STADIUM" : false,"RESTAURANT" : false,"Map4" : false,"OFFICE" : false,"CAVE" : false,"TRAIN" : false,"Map8" : false,"DISCO" : false,"BEACH" : false,"TOMB" : false,"Map12" : false
	},
	"HARD" : {
		"GODOT" : false,"PYTHON" : false,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"CHAR6" : false,"CHAR7" : false,"CHAR8" : false,
		"IMMUTABLE" : false,"MOULTING" : false,"EDGE_WRAP" : false,"DANCE" : false,"HALF_GONE" : false,"ALLERGY" : false,"OVERFED" : false,"ANCHOR" : false,
		"WOODS" : false,"STADIUM" : false,"RESTAURANT" : false,"Map4" : false,"OFFICE" : false,"CAVE" : false,"TRAIN" : false,"Map8" : false,"DISCO" : false,"BEACH" : false,"TOMB" : false,"Map12" : false
	},
	"ASCENSION" : {
		"GODOT" : false,"PYTHON" : false,"SALAMANDER" : false,"CHAMELEON" : false,"ELEPHANT" : false,"CHAR6" : false,"CHAR7" : false,"CHAR8" : false,
		"IMMUTABLE" : false,"MOULTING" : false,"EDGE_WRAP" : false,"DANCE" : false,"HALF_GONE" : false,"ALLERGY" : false,"OVERFED" : false,"ANCHOR" : false,
		"WOODS" : false,"STADIUM" : false,"RESTAURANT" : false,"Map4" : false,"OFFICE" : false,"CAVE" : false,"TRAIN" : false,"Map8" : false,"DISCO" : false,"BEACH" : false,"TOMB" : false,"Map12" : false
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
	print(masteries)
	save_masteries()

func save_masteries():
	if FileAccess.file_exists(masteries_json_path):
		print("File exists. writing into masteries file.")
	else:
		print("masteries file didn't exist. Creating new file.")
	
	var masteries_file = FileAccess.open(masteries_json_path,FileAccess.WRITE)
	
	if masteries_file:
		var masteries_json = JSON.stringify(masteries, "\t")
		masteries_file.store_string(masteries_json)
		print("masteries data written to files")
	else:
		print("failed to open or create the file")

func reset_masteries():
	for difficulty in masteries.keys():
		var mastery_dict = masteries[difficulty]
		for mastery in mastery_dict.keys():
			mastery_dict[mastery] = false
	save_masteries()
