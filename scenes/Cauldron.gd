extends Sprite

onready var animated_sprite = $AnimatedSprite

func _ready() -> void:
	animated_sprite.stop()
	animated_sprite.animation = "smoked"
	animated_sprite.frame = 0

func smoking_is_bad():
	yield(get_tree(), "idle_frame")
	animated_sprite.play("smoked")
