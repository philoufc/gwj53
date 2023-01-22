extends Sprite

onready var animated_sprite = $AnimatedSprite
onready var blblblu = preload("res://audio/blblblu.ogg")

func _ready() -> void:
	animated_sprite.stop()
	animated_sprite.animation = "smoked"
	animated_sprite.frame = 0

func smoking_is_bad():
	yield(get_tree(), "idle_frame")
	Global.sfx_player.stream = blblblu
	Global.sfx_player.play()
	animated_sprite.play("smoked")
