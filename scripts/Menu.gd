extends Control

onready var splash_godot = $SplashGodot
onready var splash_gwj = $SplashGWJ
onready var splash_subvert = $SplashSubvert
onready var main_menu = $MainMenu
onready var play_button = $MainMenu/MarginContainer/VBoxContainer/Play
onready var settings_button = $MainMenu/MarginContainer/VBoxContainer/Settings
onready var credits_button = $MainMenu/MarginContainer/VBoxContainer/Credits
onready var exit_button = $MainMenu/MarginContainer/VBoxContainer/Exit
onready var startup = $Startup

func _ready():
	splash_godot.visible = false
	splash_gwj.visible = false
	splash_subvert.visible = false
	main_menu.visible = false
	if OS.has_feature("HTML5"):
		exit_button.visible = false
	yield(get_tree(), "idle_frame")
	boot_sequence()

func boot_sequence():
	startup.play("Splash01godot")
	yield(startup, "animation_finished")
	startup.play("SplashGWJ")
	yield(startup, "animation_finished")
	startup.play("Splash02subver")
	yield(startup, "animation_finished")
#	yield(get_tree().create_timer(4.0), "timeout")

# TODO send me your splashes!
# or do we want to make a custom one for this team?
# do we have a team name?

	Global.FadeIn()
	yield(Global.FadeIn(), "completed")
	main_menu.show()

func _on_Play_pressed() -> void:
	_removeFocus()
	print("let's go!")
#	$SM_Boot.set_trigger("playbutton")

func _on_Settings_pressed() -> void:
	_removeFocus()
	Global.settings.visible = true

func _on_Credits_pressed() -> void:
	_removeFocus()
	Global.credits.visible = true

func _on_Exit_pressed() -> void:
	_removeFocus()
	get_tree().quit()


func _removeFocus():
	play_button.release_focus()
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
	
func _on_Settings_mouse_entered() -> void:
	_removeFocus()

func _on_Credits_mouse_entered() -> void:
	_removeFocus()

func _on_Exit_mouse_entered() -> void:
	_removeFocus()

#func _on_SM_Boot_transited(_from, to):
#	match to:
#		"Entry":
#			print("entry")
#		"splashScreen":
#			$Startup.play("Splash01godot")
#			yield(get_tree().create_timer(2.8), "timeout")
#			$Startup.play("Splash02subver")
#			yield(get_tree().create_timer(4.0), "timeout")
#			$SM_Boot.set_trigger("splashed")
#		"Menu":
#			Global.menu_music.volume_db = -6
#			Global.menu_music.playing = true
#			Global.is_menu = true
#			$MainMenu.visible = false
#			Global.FadeIn()
#			yield(get_tree().create_timer(0.5), "timeout")
#			$MainMenu.visible = true
#		"Play":
#			prints("menu SM reached Play state")
#			Global.FadeOut()
#			yield(get_tree().create_timer(2.0), "timeout")
#			self.queue_free()
#
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

