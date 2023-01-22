extends PopupDialog


func _input(event):
	if self.get_parent().popup:
		if not event.is_action_pressed("ui_accept"):
			if event.is_pressed():
				if event is InputEventKey:
					Global.remap_key = event
					Global.remap_pressed = OS.get_scancode_string(event.scancode).to_lower()
#					prints("remap_key",Global.remap_key)
#					prints("scancode", event.scancode)
					$MarginContainer/VBoxContainer/LineEdit.text = Global.remap_pressed
		if event.is_action_released("ui_cancel"):
			self.hide()
			$MarginContainer/VBoxContainer/LineEdit.text = ""
			get_parent().popup = false
			get_tree().paused = false
		if event.is_action_released("ui_accept"):
			InputMap.action_erase_events(Global.action_to_remap)
			InputMap.action_add_event(Global.action_to_remap, Global.remap_key)
			self.get_parent().UpdateLabels()
			self.hide()
#				release_focus()
			get_tree().paused = false

func _on_cancel_pressed():
	self.hide()
	$MarginContainer/VBoxContainer/LineEdit.text = ""
	get_parent().popup = false
	get_tree().paused = false


func _on_confirm_pressed():
	InputMap.action_erase_events(Global.action_to_remap)
	InputMap.action_add_event(Global.action_to_remap, Global.remap_key)
	match Global.action_to_remap:
		"up":
			Global.custom_up_key = Global.remap_pressed
		"left":
			Global.custom_left_key = Global.remap_pressed
		"down":
			Global.custom_down_key = Global.remap_pressed
		"right":
			Global.custom_right_key = Global.remap_pressed
		"sprint":
			Global.custom_sprint_key = Global.remap_pressed
		"level_reset":
			Global.custom_restart_key = Global.remap_pressed
	self.get_parent().UpdateLabels()
	self.hide()
	$MarginContainer/VBoxContainer/LineEdit.text = ""
	get_parent().popup = false
	get_tree().paused = false
