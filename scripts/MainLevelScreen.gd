extends Control

var level_1 = preload("res://scenes/levels/Level1.tscn")
var level_2 = preload("res://scenes/levels/Level2.tscn")
var level_3 = preload("res://scenes/levels/Level3.tscn")

export var loaded_level = preload("res://scenes/levels/Level1.tscn")

func _ready() -> void:
	_import_level(loaded_level)

func _import_level(level):
	Global.number_of_moves = 0
	Global.update_ui()
	level = level.instance()
	self.add_child(level)
	prints("imported", level, "num of moves:", Global.number_of_moves)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("level_reset"):
		Global.fade_sweep()
		yield(get_tree().create_timer(0.6), "timeout")
		get_tree().reload_current_scene()
