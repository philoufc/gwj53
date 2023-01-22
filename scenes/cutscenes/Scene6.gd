extends Control

onready var convo_scene : Control = $ConvoScene

func _on_ConvoScene_scene_done() -> void:
	Global.play_level(10, false)

func _ready() -> void:
	convo_scene.play_scene("scene1")
