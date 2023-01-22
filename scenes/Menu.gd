extends Control

onready var splash_godot = $SplashGodot
onready var splash_gwj = $SplashGWJ
onready var splash_subvert = $SplashSubvert
onready var main_menu = $MainMenu
onready var play_button = $MainMenu/MarginContainer/VBoxContainer/Play
onready var levels_buttom =$MainMenu/MarginContainer/VBoxContainer/Levels
onready var settings_button = $MainMenu/MarginContainer/VBoxContainer/Settings
onready var credits_button = $MainMenu/MarginContainer/VBoxContainer/Credits
onready var exit_button = $MainMenu/MarginContainer/VBoxContainer/Exit
onready var startup = $Startup
onready var background_tilemap = $ViewportContainer/Viewport/TileMapMenu


func _ready():
	print("scores:")
	print(Global.keeping_scores)
	background_tilemap.hide()
	splash_godot.hide()
	splash_gwj.hide()
	splash_subvert.hide()
	main_menu.hide()
	if OS.has_feature("HTML5"):
		exit_button.disabled = true
		
	if Global.just_one_level:
		Global.just_one_level = false
		Global.levels.update_scores()
		background_tilemap.show()
		main_menu.show()
		Global.levels.show()
	else:
		yield(get_tree(), "idle_frame")
		boot_sequence()

func boot_sequence():
#	startup.play("Splash01godot")
#	yield(startup, "animation_finished")
#	startup.play("SplashGWJ")
#	yield(startup, "animation_finished")
#	startup.play("Splash02subver")
#	yield(startup, "animation_finished")
#	yield(get_tree().create_timer(4.0), "timeout")

#	Global.FadeIn()
#	yield(Global.FadeIn(), "completed")
	background_tilemap.show()
	main_menu.show()
	

func _on_Play_pressed() -> void:
	_removeFocus()
	get_tree().change_scene("res://3d/Outside.tscn")

func _on_Levels_pressed() -> void:
	_removeFocus()
	Global.levels.show()

func _on_Settings_pressed() -> void:
	_removeFocus()
	Global.settings.show()

func _on_Credits_pressed() -> void:
	_removeFocus()
	Global.credits.show()

func _on_Exit_pressed() -> void:
	_removeFocus()
	get_tree().quit()


func _removeFocus():
	play_button.release_focus()
	levels_buttom.release_focus()
	settings_button.release_focus()
	credits_button.release_focus()
	exit_button.release_focus()

func _unhandled_input(event):
	if event.is_pressed():
		var pressed = OS.get_scancode_string(event.scancode)
		if pressed == "Tab":
			if !play_button.has_focus() and !settings_button.has_focus() and !credits_button.has_focus() and !exit_button.has_focus():
				play_button.grab_focus()

func _on_Play_mouse_entered() -> void:
	_removeFocus()
	
func _on_Levels_mouse_entered() -> void:
	_removeFocus()
	
func _on_Settings_mouse_entered() -> void:
	_removeFocus()

func _on_Credits_mouse_entered() -> void:
	_removeFocus()

func _on_Exit_mouse_entered() -> void:
	_removeFocus()

func SubvertSplashSubs():
	var subs = Global.subtitles_box.instance()
	splash_subvert.add_child(subs)
	subs.visible = false
	yield(get_tree().create_timer(0.3), "timeout")
	subs.get_child(1).text = "ticking"
	subs.visible = true
	yield(get_tree().create_timer(1.6), "timeout")
	subs.visible = false
	yield(get_tree().create_timer(0.3), "timeout")
	subs.get_child(1).text = "ping!"
	subs.visible = true
	yield(get_tree().create_timer(1.5), "timeout")
	subs.visible = false

