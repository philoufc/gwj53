extends Control

onready var convo_scene : Control = $ConvoScene

func _on_ConvoScene_scene_done() -> void:
	get_tree().change_scene("res://scenes/cutscenes/Ending.tscn")

func _ready() -> void:
	convo_scene.play_scene("scene7")
