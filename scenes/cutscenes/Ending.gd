extends Control

onready var label_a : Label = $Control/Label1
onready var label_b : Label = $Control/Label2
onready var label_c : Label = $Control/Label3
onready var anim_player : AnimationPlayer = $AnimationPlayer

func set_credits(a : String, b : String, c : String) -> void:
	label_a.text = a
	label_b.text = b
	label_c.text = c

func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://scenes/Menu.tscn")

func _ready() -> void:
	yield(get_tree().create_timer(3.0), "timeout")
	Global.play_track(Global.MUSIC_TRACKS.LAID_TO_REST)
	anim_player.play("ending")

