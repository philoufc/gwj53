extends Spatial

onready var anim_player_camera : AnimationPlayer = $AnimationPlayer_Camera
onready var anim_player_broom : AnimationPlayer = $AnimationPlayer_Broom

func play_camera_animation(anim_name : String) -> void:
	anim_player_camera.play(anim_name)

func play_broom_animation(anim_name : String) -> void:
	anim_player_broom.play(anim_name)
