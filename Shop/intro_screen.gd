extends Node2D
@onready var label_2: Label = $Panel/Sprite2D/Label2

const text1 = "Thank you for playing and testing this early alpha version of the Snake based rougelike 'Piece of Snake'.\n\nBefore you start, first read these short notes of advice..."
const text2 = "No.1: This game is run based.\n\nIt is designed to be beaten not at first try, but after many failed attempts in wich you will learn more and more about the game.\n\nDon't go too hard on yourself! That said.."
const text3 = "No.2: Other sources of frustration could include game crashes, bugs or unwinnable states (soft locks).\n\nSince this is an early alpha build with many possible interactions, it is unavoidable that the game might rob you of more than one earned victory.\n\nIf this happens to you, just know that you are still a winner in our book!"
const text4 = "No.3: There are multiple ways to help with the development of the the game:\n\n1. Report any bugs, glitches or gameplay errors in my discord channel or per mail (of course this also includes every type of constructive personal feedback)\n2. Record your gameplay for me to review it (no shame!)\n3. After every run - successfull or not - save the generated code and post it on my Discord or send it to me per Mail (Data is everything!)"
const text5 = "\n\n\nNo.4: Of course most important: don't forget to have fun! :)"

var texts = [text2, text3, text4, text5]
var text_counter = 0

func _ready():
	label_2.text = text1

func _on_continue_button_pressed() -> void:
	if text_counter == 4:
		queue_free()
	else:
		label_2.text = texts[text_counter]
		text_counter += 1
