extends Control

const TILE_SIZE = 64

enum MUSIC_TRACKS {CAULDRONS_RONDO, CIARAS_DETERMINATION, CIARAS_GIFT, CIARAS_LAMENT, FINDING_THE_CURE, LAID_TO_REST, PROUD_OF_YOU, SUAVE_SENILE}

const MUSIC_STREAMS := {
	MUSIC_TRACKS.CAULDRONS_RONDO: preload("res://audio/music/cauldrons_rondo.ogg"),
	MUSIC_TRACKS.CIARAS_DETERMINATION: preload("res://audio/music/ciaras_determination.ogg"),
	MUSIC_TRACKS.CIARAS_GIFT: preload("res://audio/music/ciaras_gift.ogg"),
	MUSIC_TRACKS.CIARAS_LAMENT: preload("res://audio/music/ciaras_lament.ogg"),
	MUSIC_TRACKS.FINDING_THE_CURE: preload("res://audio/music/finding_the_cure.ogg"),
	MUSIC_TRACKS.LAID_TO_REST: preload("res://audio/music/laid_to_rest.ogg"),
	MUSIC_TRACKS.PROUD_OF_YOU: preload("res://audio/music/proud_of_you.ogg"),
	MUSIC_TRACKS.SUAVE_SENILE: preload("res://audio/music/suave_senile.ogg"),
}

var level_names := {
	1: "Non-Flammable\nWater",
	2: "Recongestant",
	3: "Anti-Anti-Itching\nPowder",
	4: "Potion of Eternal Middle-Age",
	5: "A Nice, Hot Cup of Tea\n(definitely not poisoned)",
	6: "A Nice, Hot Cup of Antidote",
	7: "Seeking the Cure, pt. 1",
	8: "Seeking the Cure, pt. 2",
	9: "Seeking the Cure, pt. 3",
	10: "The Cure",
} # elixir of love-hate,
# Shinra Guards' Quantum Potion
# bad breath of the wild

var level_music := {
	1: MUSIC_TRACKS.SUAVE_SENILE,
	2: MUSIC_TRACKS.SUAVE_SENILE,
	3: MUSIC_TRACKS.SUAVE_SENILE,
	4: MUSIC_TRACKS.CAULDRONS_RONDO,
	5: MUSIC_TRACKS.CAULDRONS_RONDO,
	6: MUSIC_TRACKS.CAULDRONS_RONDO,
	7: MUSIC_TRACKS.CIARAS_DETERMINATION,
	8: MUSIC_TRACKS.CIARAS_DETERMINATION,
	9: MUSIC_TRACKS.CIARAS_DETERMINATION,
	10: MUSIC_TRACKS.FINDING_THE_CURE
}

onready var main_level_screen = preload("res://scenes/MainLevelScreen.tscn")
onready var msg_panel = $CanvasLayer/MsgPanel
onready var msg_label = $CanvasLayer/MsgPanel/MsgLabel
#onready var msg_continue = $CanvasLayer/UI/HBoxContainer/MsgPanel/VBoxContainer/ContinueMsg
onready var subtitles_box = preload("res://scenes/SubtitlesBox.tscn")
onready var settings = $CanvasLayer/Settings
onready var levels = $CanvasLayer/Levels
onready var credits = $CanvasLayer/Credits
onready var ingame_menu = $CanvasLayer/InGameMenu
onready var fader = $CanvasLayer/Fader
onready var sweep = $CanvasLayer/Sweep
onready var menu_music = $MenuMusic
onready var animation_player = $AnimationPlayer
onready var color_rect = $ColorRect

export (int, 1, 11) var current_level = 1
var number_of_moves :int = 0
var keeping_scores :Dictionary = {}

var just_one_level = false
var restart_message_shown = false
var pause_menu_available = false

var music_muted = false
var voice_muted = false
var fx_muted = false
var music_volume :float
var voice_volume :float
var fx_volume :float
export(String, "normal", "hard") var game_difficulty

var action_to_remap :String
var remap_key :InputEventKey
var remap_pressed :String
var custom_up_key :String = "w"
var custom_left_key :String = "a"
var custom_down_key :String = "s"
var custom_right_key :String = "d"
var custom_restart_key :String = "r"

var currently_playing := -1

onready var moves = $CanvasLayer/UI/HBoxContainer/VBoxContainer/UIMoves/Moves
onready var ui_moves = $CanvasLayer/UI/HBoxContainer/VBoxContainer/UIMoves
onready var music_player : AudioStreamPlayer = $Music

func _ready():
	randomize()
	fader.hide()
	sweep.hide()
	yield(get_tree(), "idle_frame")
	music_volume = AudioServer.get_bus_volume_db(1)
	voice_volume = AudioServer.get_bus_volume_db(2)
	fx_volume = AudioServer.get_bus_volume_db(3)
	settings.hide()
	credits.hide()
	ingame_menu.hide()
	ui_moves.hide()
	msg_panel.hide()

func play_track(which_track : int) -> void:
	if currently_playing == which_track:
		return
	music_player.stop()
	music_player.stream = MUSIC_STREAMS[which_track]
	music_player.play()
	currently_playing = which_track

func play_track_for_level(which_level : int) -> void:
	if level_music.has(which_level):
		play_track(level_music[which_level])

func update_ui():
	moves.text = str(number_of_moves)

func FadeOut():
	fader.visible = true
	animation_player.play("ScreenVisualFadeOut")
	yield(animation_player, "animation_finished")

func FadeIn():
	fader.visible = true
	animation_player.play("ScreenVisualFadeIn")
	yield(animation_player, "animation_finished")

func fade_sweep():
	animation_player.play("SweepFade")
	yield(animation_player, "animation_finished")
	
func show_restart_message():
	if not restart_message_shown:
		msg_label.text = "If you're stuck, you can press the '%s' key to restart." % custom_restart_key
		animation_player.play("MsgPanelBottom")
		restart_message_shown = true

func play_one_level(level):
	pass

func MusicMuteToggle():
	if music_muted == false:
		AudioServer.set_bus_mute(1, true)
	elif music_muted == true:
		AudioServer.set_bus_mute(1, false)
	music_muted = not music_muted

func MusicVolumeSet(volume :float):
	music_volume = volume
	AudioServer.set_bus_volume_db(1, volume)

func VoiceMuteToggle():
	if voice_muted == false:
		AudioServer.set_bus_mute(2, true)
	elif voice_muted == true:
		AudioServer.set_bus_mute(2, false)
	voice_muted = not voice_muted

func VoiceVolumeSet(volume :float):
	voice_volume = volume
	AudioServer.set_bus_volume_db(2, volume)

func FXMuteToggle():
	if fx_muted == false:
		AudioServer.set_bus_mute(3, true)
	elif fx_muted == true:
		AudioServer.set_bus_mute(3, false)
	fx_muted = not fx_muted

func FXVolumeSet(volume :float):
	fx_volume = volume
	AudioServer.set_bus_volume_db(3, volume)
