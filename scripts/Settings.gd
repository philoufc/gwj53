extends Control

var popup = false

func _ready():
	$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/controls_side/HBoxContainer7/VBoxContainer2/HBoxContainer/up_key.grab_focus()
	$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/audio_side/VBoxContainer/HBoxContainer/music_vol.value = Global.music_volume
	$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/audio_side/VBoxContainer2/HBoxContainer2/fx_vol.value = Global.fx_volume


func _on_music_vol_plus_pressed():
	$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/audio_side/VBoxContainer/HBoxContainer/music_vol.value += 5

func _on_music_vol_minus_pressed():
	$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/audio_side/VBoxContainer/HBoxContainer/music_vol.value -= 5

func _on_fx_vol_minus_pressed():
	$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/audio_side/VBoxContainer2/HBoxContainer2/fx_vol.value -= 5

func _on_fx_vol_plus_pressed():
	$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/audio_side/VBoxContainer2/HBoxContainer2/fx_vol.value += 5

func UpdateLabels():
	match Global.action_to_remap:
		"up":
			$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/controls_side/HBoxContainer7/VBoxContainer2/HBoxContainer/up_key.text = Global.remap_pressed
		"left":
			$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/controls_side/HBoxContainer7/VBoxContainer2/HBoxContainer2/left_key.text = Global.remap_pressed
		"down":
			$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/controls_side/HBoxContainer7/VBoxContainer2/HBoxContainer3/down_key.text = Global.remap_pressed
		"right":
			$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/controls_side/HBoxContainer7/VBoxContainer2/HBoxContainer4/right_key.text = Global.remap_pressed
		"sprint":
			$MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/controls_side/HBoxContainer7/VBoxContainer2/HBoxContainer7/sprint_key.text = Global.remap_pressed
		_:
			pass

func _on_PopupDialog_about_to_show():
	popup = true
	get_tree().paused = true

func _on_up_key_pressed():
	Global.action_to_remap = "up"
	$PopupDialog.popup()

func _on_left_key_pressed():
	Global.action_to_remap = "left"
	$PopupDialog.popup()

func _on_down_key_pressed():
	Global.action_to_remap = "down"
	$PopupDialog.popup()

func _on_right_key_pressed():
	Global.action_to_remap = "right"
	$PopupDialog.popup()

#func _on_interact_key_pressed():
#	Global.action_to_remap = "interact"
#	$PopupDialog.popup()
#
#func _on_light_key_pressed():
#	Global.action_to_remap = "flashlight"
#	$PopupDialog.popup()

func _on_sprint_key_pressed():
	Global.action_to_remap = "sprint"
	$PopupDialog.popup()


func _on_return_pressed():
	self.visible = false


func _on_music_vol_value_changed(value):
	Global.MusicVolumeSet(value)

func _on_fx_vol_value_changed(value):
	Global.FXVolumeSet(value)


func _on_CheckBoxMusic_pressed():
	prints("test")
	Global.MusicMuteToggle()

func _on_CheckBoxFX_pressed():
	Global.FXMuteToggle()

