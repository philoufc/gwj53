extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if Global.pause_menu_available:
			Global.ingame_menu.visible = not Global.ingame_menu.visible
			get_tree().paused = not get_tree().paused

func _on_Resume_pressed() -> void:
	Global.play_ui_click()
	Global.ingame_menu.hide()
	get_tree().paused = false

func _on_Settings_pressed() -> void:
	Global.play_ui_click()
	Global.settings.show()

func _on_ReturnMainMenu_pressed() -> void:
	Global.play_ui_click()
	pass # Replace with function body.

func _on_button_entered():
	Global.play_ui_mouseover()
