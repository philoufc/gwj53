extends Node2D


func _ready() -> void:
	pass 

func return_tile(position):
	return $TileMap.world_to_map(position)
	
func return_middle_pos(tile):
	return $TileMap.map_to_world(tile) + Vector2(32, 32)

func tile_is_walkable(tile):
	return $TileMap.get_cellv(tile) == 0
