extends Control

onready var sounds : Dictionary = {
	"doorbell": preload("res://audio/doorbell.ogg"),
	"envelope": preload("res://audio/envelope.ogg"),
	"footsteps_in": preload("res://audio/footsteps_in.ogg"),
	"footsteps_out": preload("res://audio/footsteps_out.ogg"),
}

onready var mad_talk : Node = $MadTalk
onready var room : Spatial = $Viewport/Room
onready var audio_voice_clip : AudioStreamPlayer = $Audio_VoiceClip
onready var audio_sound_effect : AudioStreamPlayer = $Audio_SoundEffect

signal scene_done

func _on_MadTalk_activate_custom_effect(custom_id, custom_data):
	match custom_id:
		"play_camera_anim":
			room.play_camera_animation(custom_data[0])
		"play_broom_anim":
			room.play_broom_animation(custom_data[0])
		"play_music":
			Global.play_track(int(custom_data[0]))
		"fade_out_music":
			Global.fade_out_music()
		"play_sfx":
			audio_sound_effect.stream = sounds[custom_data[0]]
			audio_sound_effect.play()

func _on_MadTalk_voice_clip_requested(speaker_id, clip_path):
	audio_voice_clip.stream = load(clip_path)
	audio_voice_clip.play()

func _on_MadTalk_dialog_finished(sheet_name, sequence_id):
	emit_signal("scene_done")

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("next_line"):
		mad_talk.dialog_acknowledge()

func play_scene(which_scene : String) -> void:
	mad_talk.start_dialog(which_scene)
