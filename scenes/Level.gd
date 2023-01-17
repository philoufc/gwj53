extends Node2D

onready var tilemap :TileMap = $TileMap

func _ready() -> void:
	pass

func return_tile(position):
	return tilemap.world_to_map(position)
	
func return_middle_pos(tile):
	return tilemap.map_to_world(tile) + Vector2(32, 32)

func tile_is_walkable(tile):
	return tilemap.get_cellv(tile) == 0

func tile_is_exit(tile):
	return tilemap.get_cellv(tile) == 4
