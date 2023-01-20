extends TileMap

onready var points = [$Position2D, $Position2D2, $Position2D3, $Position2D4, $Position2D5, $Position2D6, $Position2D7, $Position2D8, $Position2D9, $Position2D10]
onready var camera = $Camera2D
onready var tween = $Tween


func _ready() -> void:
	move_camera()
	
func _on_Timer_timeout() -> void:
	move_camera()

func move_camera():
	var new_point_index = randi() % len(points)
	print(points[new_point_index].global_position)
	tween.interpolate_property(camera, "position", camera.global_position, points[new_point_index].global_position, 20)
	tween.start()
#	yield(tween, "tween_completed")
	$Timer.start()
