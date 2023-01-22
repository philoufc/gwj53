extends Spatial

onready var anim_player : AnimationPlayer = $AnimationPlayer

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	Global.color_rect.show()
	get_tree().change_scene("res://scenes/Menu.tscn")

func _ready() -> void:
	Global.color_rect.hide()
	yield(get_tree().create_timer(1.0), "timeout")
	anim_player.play("splash")
