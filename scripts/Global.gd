extends Control

var is_menu = false
#onready var msg_panel = $CanvasLayer/UI/HBoxContainer/MsgPanel
#onready var msg_richtext = $CanvasLayer/UI/HBoxContainer/MsgPanel/VBoxContainer/RichTextLabel
#onready var msg_continue = $CanvasLayer/UI/HBoxContainer/MsgPanel/VBoxContainer/ContinueMsg
onready var subtitles_box = preload("res://scenes/SubtitlesBox.tscn")
onready var settings = $CanvasLayer/Settings
onready var credits = $CanvasLayer/Credits
onready var fader = $CanvasLayer/Fader

onready var menu_music = $MenuMusic
onready var animation_player = $AnimationPlayer

var music_muted = false
var voice_muted = false
var fx_muted = false
var music_volume :float
var voice_volume :float
var fx_volume :float
#export(String, "easy", "normal", "hard") var game_difficulty

var action_to_remap :String
var remap_key :InputEventKey
var remap_pressed :String
var custom_up_key :String = "w"
var custom_left_key :String = "a"
var custom_down_key :String = "s"
var custom_right_key :String = "d"
#var custom_sprint_key :String = "shift"

var player_movement_locked = false

# replace timer for an number-of-actions counter
var timer_on = false
var time = 0
var time_passed
onready var timer = $CanvasLayer/UI/HBoxContainer/VBoxContainer/UI_Timer/Timer
onready var ui_timer = $CanvasLayer/UI/HBoxContainer/VBoxContainer/UI_Timer



func _ready():
	fader.visible = true
	yield(get_tree(), "idle_frame")
	music_volume = AudioServer.get_bus_volume_db(1)
	fx_volume = AudioServer.get_bus_volume_db(2)
	settings.visible = false
	credits.visible = false
	ui_timer.visible = false


func _process(delta):
#	if(timer_on):
#		time += delta
#	var mils = fmod(time, 1)*1000
#	var seconds = fmod(time, 60)
#	var minutes = fmod(time, 60*60) / 60
#	time_passed = "%02d : %02d : %03d" % [minutes, seconds, mils]
#
#	timer.text = str(time_passed)
#	if time == 36000:
#		prints("one hour, the end")
	pass


func FadeOut():
	fader.visible = true
	animation_player.play("ScreenVisualFadeOut")
	yield(get_tree().create_timer(2.0), "timeout")

func FadeIn():
	fader.visible = true
	animation_player.play("ScreenVisualFadeIn")
	yield(get_tree().create_timer(2.0), "timeout")

func MusicMuteToggle():
	if music_muted == false:
		AudioServer.set_bus_mute(1, true)
		music_muted = not music_muted
	elif music_muted == true:
		AudioServer.set_bus_mute(1, false)
		music_muted = not music_muted

func MusicVolumeSet(volume :float):
	music_volume = volume
	AudioServer.set_bus_volume_db(1, volume)

func FXMuteToggle():
	if fx_muted == false:
		AudioServer.set_bus_mute(2, true)
		fx_muted = not fx_muted
	elif fx_muted == true:
		AudioServer.set_bus_mute(2, false)
		fx_muted = not fx_muted

func FXVolumeSet(volume :float):
	fx_volume = volume
	AudioServer.set_bus_volume_db(2, volume)
