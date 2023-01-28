extends Control

onready var levels_vbox = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
onready var new_level_line = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/LevelLine
onready var actual_line = $MarginContainer/Panel/MarginContainer/VBoxContainer/Title/ColorRect

func _ready() -> void:
	list_levels()
	update_scores()

func list_levels():
	for recipe in range(len(Global.level_names)):
		var this_level = recipe + 1
		var new_hbox = new_level_line.duplicate()
		levels_vbox.add_child(new_hbox)
		var level_line = actual_line.duplicate()
		level_line.rect_min_size.x = levels_vbox.rect_size.x
		level_line.color = Color("46425e")
		new_hbox.recipe_name.text = "%s) %s" % [this_level, Global.level_names[this_level].replace("\n", " ")]
		new_hbox.recipe_score.name = str(this_level)
		new_hbox.recipe_score.text = "-"
		new_hbox.recipe_button.text = "Play"
		new_hbox.connected_level = this_level
		levels_vbox.add_child(level_line)
		if this_level == 1:
			new_hbox.recipe_button.grab_focus()
	new_level_line.hide()

func update_scores():
	for score in get_tree().get_nodes_in_group("scores"):
		if int(score.name) in Global.keeping_scores:
			print(score)
			print("it's in!")
			score.text = str(Global.keeping_scores[int(score.name)])

func _on_Return_pressed() -> void:
	Global.play_ui_click()
	self.visible = false

func _on_Return_mouse_entered():
	Global.play_ui_mouseover()
