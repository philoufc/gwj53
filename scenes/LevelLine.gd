extends HBoxContainer

onready var recipe_name = $ColumnRecipe/MarginContainer/Label
onready var recipe_score = $ColumnBestScore/Label
onready var recipe_button = $ColumnPlay/Button

var connected_level : int

func _on_Button_mouse_entered() -> void:
	Global.play_ui_mouseover()

func _on_Button_pressed() -> void:
	Global.play_ui_click()
	Global.levels.hide()
	Global.just_one_level = true
	Global.current_level = connected_level
	get_tree().change_scene("res://scenes/MainLevelScreen.tscn")

