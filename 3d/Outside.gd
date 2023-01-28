extends Spatial

onready var anim_player : AnimationPlayer = $AnimationPlayer

func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	if anim_name == "outside":
		get_tree().change_scene("res://scenes/cutscenes/Scene1.tscn")
	else:
		anim_player.play("outside")

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("next_line"):
		get_tree().change_scene("res://scenes/cutscenes/Scene1.tscn")

func _ready() -> void:
	Global.color_rect.hide()
	anim_player.play("prologue")
