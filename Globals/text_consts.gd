extends Node

var card_data
var keyword_data

enum TABLES {CARDS, KEYWORDS}

func _ready() -> void:
	var file_string = FileAccess.get_file_as_string("res://Data/Piece of Snake Data.json")
	var json_data
	if file_string != null:
		json_data = JSON.parse_string(file_string)
	else:
		push_warning("json data could not be loaded from res://Data/Piece of Snake Data.json")
	card_data = json_data.get("Upgrade Cards")
	keyword_data = json_data.get("Keywords")

func get_text(table:int, id: String, attribute:String) -> String:
	var language_suffix
	match GlobalSettings.language:
		GlobalSettings.languages.ENGLISH:
			language_suffix = "_ENG"
		GlobalSettings.languages.GERMAN:
			language_suffix = "_GER"
	match table:
		TABLES.CARDS:
			return card_data[id][attribute + language_suffix]
		TABLES.KEYWORDS:
			return keyword_data[id][attribute + language_suffix]
		_:
			push_error("couldn't find attribute ", attribute, " for id ", id, " in table ", table)
			return "UNKNOWN"
