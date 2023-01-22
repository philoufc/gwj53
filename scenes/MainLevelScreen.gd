extends Control

var level_scenes := {
	1: preload("res://scenes/levels/Level1.tscn"),
	2: preload("res://scenes/levels/Level2.tscn"),
	3: preload("res://scenes/levels/Level3.tscn"),
	4: preload("res://scenes/levels/Level4.tscn"),
	5: preload("res://scenes/levels/Level5.tscn"),
	6: preload("res://scenes/levels/Level6.tscn"),
	7: preload("res://scenes/levels/Level7.tscn"),
	8: preload("res://scenes/levels/Level8.tscn"),
	9: preload("res://scenes/levels/Level9.tscn"),
	10: preload("res://scenes/levels/Level10.tscn")
}

export (int, 1, 11) var loaded_level = 1

#var loaded_level_number :int
onready var label_level := $CenterContainer/LabelLevel

func _ready() -> void:
#	Global.current_level = loaded_level # temporary testing
	if Global.current_level == 0:
		next_level(Global.current_level)
	else:
		import_level(Global.current_level)
	

func import_level(level):
	Global.number_of_moves = 0
	Global.update_ui()
	level = level_scenes[level]
	loaded_level = level._bundled.variants[2]
	label_level.text = str(loaded_level) + "\n\n" + str(Global.level_names[loaded_level])
	label_level.show()
	yield(get_tree().create_timer(3), "timeout")
	label_level.hide()
	level = level.instance()
	self.add_child(level)
	Global.ui_moves.show()
	level.player.main_screen_level = self

func next_level(current_level):
	if Global.just_one_level:
		get_tree().change_scene("res://scenes/Menu.tscn")
	else:
	#	print("global current level:", Global.current_level)
	#	if current_level == 4:
	#		print("goto next scene")
	#	else:
			loaded_level += 1
			Global.current_level = current_level + 1
			import_level(Global.current_level)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("level_reset"):
		level_restart()
	

func level_restart():
	Global.msg_panel.hide()
	Global.fade_sweep()
	yield(get_tree().create_timer(0.8), "timeout")
	Global.ui_moves.hide()
	get_tree().reload_current_scene()
