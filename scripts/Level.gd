extends Node2D

onready var main_camera :Camera2D = $MainCamera
onready var tilemap :TileMap = $TileMap
onready var player :StaticBody2D = $Player
export var level_number :int

func _ready() -> void:
#	print(tilemap.get_used_rect().size)
	player.level = self
	player.position = return_middle_pos(return_tile(player.position))
	for element in get_tree().get_nodes_in_group("elements"):
		element.position = return_middle_pos(return_tile(element.position))
		element.level = self
		element.player = player
	
func return_tile(position):
	return tilemap.world_to_map(position)
	
func return_middle_pos(tile):
	return tilemap.map_to_world(tile) + Vector2(32, 32)

func tile_is_walkable(tile):
	return tilemap.get_cellv(tile) == 0

func tile_is_exit(tile):
	return tilemap.get_cellv(tile) == 4
