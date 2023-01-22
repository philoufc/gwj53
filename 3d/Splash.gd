extends Spatial

onready var anim_player : AnimationPlayer = $AnimationPlayer

func goto_title() -> void:
	Global.color_rect.show()
	get_tree().change_scene("res://scenes/Menu.tscn")

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	goto_title()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("next_line"):
		goto_title()

func _ready() -> void:
	Global.color_rect.hide()
	yield(get_tree().create_timer(1.0), "timeout")
	anim_player.play("splash")
