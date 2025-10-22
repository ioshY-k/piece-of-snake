extends Node

var codestring: String = ""

#one letter
var maps: Array[String] = []

#two characters
var mapmods: Array[String] = []

#number characters
var bonus_fruits: Array[String] = []

#letter b/s followed by id
var buys: Array[String] = [""]

var current_act: int
var current_round: int

func generate_code():
	codestring += maps[0]
	for i in range(0, 4):
		codestring += mapmods [i]
		codestring += bonus_fruits[i]
		if "X" in bonus_fruits[i]:
			return
		codestring += buys[i]
		
	codestring += maps[1]
	for i in range(4, 8):
		codestring += mapmods [i]
		codestring += bonus_fruits[i]
		if "X" in bonus_fruits[i]:
			return
		codestring += buys[i]
		
	codestring += maps[2]
	for i in range(8, 12):
		codestring += mapmods [i]
		codestring += bonus_fruits[i]
		if "X" in bonus_fruits[i]:
			return
		codestring += buys[i]

func reset_code():
	codestring = ""
	maps = []
	mapmods = []
	bonus_fruits = []
	buys = [""]
