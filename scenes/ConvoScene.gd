extends Control

onready var mad_talk : Node = $MadTalk

func _ready() -> void:
	mad_talk.start_dialog("scene1")

