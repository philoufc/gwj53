extends Spatial

func _on_AnimationPlayer_animation_finished(anim_name) -> void:
	get_tree().change_scene("res://scenes/cutscenes/Scene1.tscn")

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("next_line"):
		get_tree().change_scene("res://scenes/cutscenes/Scene1.tscn")

func _ready() -> void:
	Global.color_rect.hide()
	$AnimationPlayer.play("outside")
