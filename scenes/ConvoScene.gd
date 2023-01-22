extends Control

onready var mad_talk : Node = $MadTalk
onready var room : Spatial = $Viewport/Room
onready var audio_voice_clip : AudioStreamPlayer = $Audio_VoiceClip

func _on_MadTalk_activate_custom_effect(custom_id, custom_data):
	match custom_id:
		"play_camera_anim":
			room.play_camera_animation(custom_data[0])

func _on_MadTalk_voice_clip_requested(speaker_id, clip_path):
	audio_voice_clip.stream = load(clip_path)
	audio_voice_clip.play()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("next_line"):
		mad_talk.dialog_acknowledge()

func _ready() -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	room.play_broom_animation("broom")
	mad_talk.start_dialog("scene1")
