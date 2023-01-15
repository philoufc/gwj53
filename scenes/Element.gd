extends StaticBody2D

var element_free_spaces = {"up": 0, "down": 0, "right": 0, "left": 0}
export var element_number :int
onready var collision_shape :CollisionShape2D = $CollisionElement
onready var raycast_up : RayCast2D = $RayCastUp
onready var raycast_down : RayCast2D = $RayCastDown
onready var raycast_right : RayCast2D = $RayCastRight
onready var raycast_left : RayCast2D = $RayCastLeft

func _ready() -> void:
	yield(get_tree(), "idle_frame")
	self.position = get_pos_from_tile(get_tile_from_pos(self.position))


func update_free_spaces():
	raycast_up.cast_to = Vector2(0, -2000)
	raycast_down.cast_to = Vector2(0, 2000)
	raycast_right.cast_to = Vector2(2000, 0)
	raycast_left.cast_to = Vector2(-2000, 0)
	for i in element_free_spaces: element_free_spaces[i] = 0
	if raycast_up.is_colliding():
		element_free_spaces["up"] = int(abs(raycast_up.get_collision_point().y - self.global_position.y) / Global.TILE_SIZE)
	if raycast_down.is_colliding():
		element_free_spaces["down"] = int(abs(raycast_down.get_collision_point().y - self.global_position.y) / Global.TILE_SIZE)
	if raycast_right.is_colliding():
		element_free_spaces["right"] = int(abs(raycast_right.get_collision_point().x - self.global_position.x) / Global.TILE_SIZE)
	if raycast_left.is_colliding():
		element_free_spaces["left"] = int(abs(raycast_left.get_collision_point().x - self.global_position.x) / Global.TILE_SIZE)
	
func get_free_spaces(direction):
	update_free_spaces()
	return element_free_spaces[direction]

func get_tile_from_pos(position):
	return get_tree().root.get_node("Level").return_tile(position)

func get_pos_from_tile(tile):
	return get_tree().root.get_node("Level").return_middle_pos(tile)
