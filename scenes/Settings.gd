extends Control

var popup = false
onready var up_key = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/ControlsSide/Panel/MarginContainer/HBoxContainer7/VBoxContainer2/HBoxContainer/UpKey
onready var left_key = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/ControlsSide/Panel/MarginContainer/HBoxContainer7/VBoxContainer2/HBoxContainer2/LeftKey
onready var down_key = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/ControlsSide/Panel/MarginContainer/HBoxContainer7/VBoxContainer2/HBoxContainer3/DownKey
onready var right_key = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/ControlsSide/Panel/MarginContainer/HBoxContainer7/VBoxContainer2/HBoxContainer4/RightKey
onready var restart_key = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/ControlsSide/Panel/MarginContainer/HBoxContainer7/VBoxContainer2/HBoxContainer8/RestartKey
onready var music_volume = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/AudioSide/Panel/MarginContainer/VBoxContainer3/MusicVBox/HBoxContainer/MusicVol
onready var sfx_volume = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/AudioSide/Panel/MarginContainer/VBoxContainer3/SFXVBox/HBoxContainer2/FXVol
onready var voice_volume = $MarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/AudioSide/Panel/MarginContainer/VBoxContainer3/VoiceVBox/HBoxContainer2/VoiceVol

func _ready():
	up_key.grab_focus()
	music_volume.value = Global.music_volume
	sfx_volume.value = Global.fx_volume

func _on_music_vol_plus_pressed():
	Global.play_ui_click()
	music_volume.value += 5

func _on_music_vol_minus_pressed():
	Global.play_ui_click()
	music_volume.value -= 5

func _on_fx_vol_minus_pressed():
	Global.play_ui_click()
	sfx_volume.value -= 5

func _on_fx_vol_plus_pressed():
	Global.play_ui_click()
	sfx_volume.value += 5

func UpdateLabels():
	match Global.action_to_remap:
		"up":
			up_key.text = Global.remap_pressed
		"left":
			left_key.text = Global.remap_pressed
		"down":
			down_key.text = Global.remap_pressed
		"right":
			right_key.text = Global.remap_pressed
		"level_reset":
			restart_key.text = Global.remap_pressed
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

func _on_restart_key_pressed() -> void:
	Global.action_to_remap = "level_reset"
	$PopupDialog.popup()

func _on_return_pressed():
	Global.play_ui_click()
	self.visible = false

func _on_music_vol_value_changed(value):
	Global.play_ui_click()
	Global.MusicVolumeSet(value)

func _on_fx_vol_value_changed(value):
	Global.play_ui_click()
	Global.FXVolumeSet(value)

func _on_VoiceVol_value_changed(value: float) -> void:
	Global.play_ui_click()
	Global.VoiceVolumeSet(value)

func _on_CheckBoxMusic_pressed():
	Global.play_ui_click()
	Global.MusicMuteToggle()

func _on_CheckBoxVoice_pressed() -> void:
	Global.play_ui_click()
	Global.VoiceMuteToggle()

func _on_CheckBoxFX_pressed():
	Global.play_ui_click()
	Global.FXMuteToggle()

func _on_OptionButton_item_selected(index: int) -> void:
	Global.play_ui_click()
	match index:
		0:
			Global.game_difficulty = "normal"
		1:
			Global.game_difficulty = "hard"

func _on_button_entered() -> void:
	Global.play_ui_mouseover()
