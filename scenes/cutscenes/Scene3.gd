extends Control

onready var convo_scene : Control = $ConvoScene

func _on_ConvoScene_scene_done() -> void:
	Global.fade_sweep()
	yield(get_tree().create_timer(0.8), "timeout")
	get_tree().change_scene("res://scenes/cutscenes/Scene4.tscn")

func _ready() -> void:
	convo_scene.play_scene("scene3")
