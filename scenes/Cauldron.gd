extends Sprite

onready var animated_sprite = $AnimatedSprite
onready var blblblu = preload("res://audio/blblblu.ogg")

func _ready() -> void:
	animated_sprite.stop()
	animated_sprite.animation = "smoked"
	animated_sprite.frame = 0
	if OS.has_feature("HTML5"):
		animated_sprite.queue_free()

func smoking_is_bad():
	if OS.has_feature("HTML5"):
		return
	else:
		yield(get_tree(), "idle_frame")
		Global.sfx_player.stream = blblblu
		Global.sfx_player.play()
		animated_sprite.play("smoked")
