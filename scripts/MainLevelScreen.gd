extends Control

var level_scenes := {
	1: preload("res://scenes/levels/Level1.tscn"),
	2: preload("res://scenes/levels/Level2.tscn"),
	3: preload("res://scenes/levels/Level3.tscn"),
	4: preload("res://scenes/levels/Level4.tscn"),
}

var level_names := {
	1: "Non-Flammable\nWater",
	2: "Recongestant",
	3: "Anti-Anti-Itching\nPowder",
	4: "Potion of Eternal Middle-Age",
	5: "A Nice, Hot Cup of Tea\n(definitely not poisoned)",
	6: "A Nice, Hot Cup of Antidote",
	7: "Seeking the Cure, pt. 1",
	8: "Seeking the Cure, pt. 2",
	9: "Seeking the Cure, pt. 3",
	10: "The Cure",
} # elixir of love-hate, Shinra Guards' Quantum Potion

export (int, 1, 11) var loaded_level = 1

var loaded_level_number :int
onready var label_level := $CenterContainer/LabelLevel

func _ready() -> void:
	if Global.current_level == 0:
		next_level(Global.current_level)
	else:
		import_level(Global.current_level)
	

func import_level(level):
	Global.number_of_moves = 0
	Global.update_ui()
	level = level_scenes[level]
	loaded_level_number = level._bundled.variants[2]
	label_level.text = str(loaded_level_number) + "\n\n" + str(level_names[loaded_level_number])
	label_level.show()
	yield(get_tree().create_timer(3), "timeout")
	label_level.hide()
	level = level.instance()
	self.add_child(level)
	Global.ui_moves.show()
	level.player.main_screen_level = self

func next_level(current_level):
	# if current_level == X, goto scene Y instead
	# else
	Global.current_level = current_level + 1
	import_level(Global.current_level)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("level_reset"):
		print("global level:", Global.current_level)
		Global.fade_sweep()
		yield(get_tree().create_timer(0.8), "timeout")
		Global.ui_moves.hide()
		get_tree().reload_current_scene()
