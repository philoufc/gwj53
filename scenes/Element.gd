extends StaticBody2D

var element_free_spaces = {"up": 0, "down": 0, "right": 0, "left": 0}

func _ready() -> void:
	self.position = get_pos_from_tile(get_tile_from_pos(self.position))


#func update_free_spaces():
#	$RayCast_up.cast_to = Vector2(0, -2000)
#	$RayCast_down.cast_to = Vector2(0, 2000)
#	$RayCast_right.cast_to = Vector2(2000, 0)
#	$RayCast_left.cast_to = Vector2(-2000, 0)
#	for i in element_free_spaces: element_free_spaces[i] = 0
#	if $RayCast_up.is_colliding():
#		element_free_spaces["up"] = int(abs($RayCast_up.get_collision_point().y - self.position.y) / Global.TILE_SIZE)
#	if $RayCast_down.is_colliding():
#		element_free_spaces["down"] = int(abs($RayCast_down.get_collision_point().y - self.position.y) / Global.TILE_SIZE)
#	if $RayCast_right.is_colliding():
#		element_free_spaces["right"] = int(abs($RayCast_right.get_collision_point().x - self.position.x) / Global.TILE_SIZE)
#	if $RayCast_left.is_colliding():
#		element_free_spaces["left"] = int(abs($RayCast_left.get_collision_point().x - self.position.x) / Global.TILE_SIZE)



func get_tile_from_pos(position):
	return get_tree().root.get_node("Level").return_tile(position)

func get_pos_from_tile(tile):
	return get_tree().root.get_node("Level").return_middle_pos(tile)
