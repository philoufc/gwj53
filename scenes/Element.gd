extends StaticBody2D

var element_free_spaces = {"up": 0, "down": 0, "right": 0, "left": 0}
export var element_number :int
onready var level : Node2D = get_tree().root.get_node("Level")
onready var player : Node2D = level.get_node("Player")
onready var collision_shape :CollisionShape2D = $CollisionElement
onready var raycast_up : RayCast2D = $RayCastUp
onready var raycast_down : RayCast2D = $RayCastDown
onready var raycast_right : RayCast2D = $RayCastRight
onready var raycast_left : RayCast2D = $RayCastLeft
onready var area_up : Area2D = $AreaUp
onready var area_down : Area2D = $AreaDown
onready var area_right : Area2D = $AreaRight
onready var area_left : Area2D = $AreaLeft
onready var position_up :Position2D = $ElementsPositions/Position2D_up
onready var position_down :Position2D = $ElementsPositions/Position2D_down
onready var position_right :Position2D = $ElementsPositions/Position2D_right
onready var position_left :Position2D = $ElementsPositions/Position2D_left


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

func element_check_around_and_attach():
	print("elem check around fired from:", self)
	if area_up.get_overlapping_bodies():
		if area_up.get_overlapping_bodies()[0].is_in_group("elements"):
			var new_element = area_up.get_overlapping_bodies()[0]
			level.remove_child(new_element)
			player.add_child(new_element)
			new_element.position = self.position + position_up.position
			new_element.collision_shape.disabled = true
			player.elements_carried.append(new_element)
			yield(get_tree(), "idle_frame")
			player.elements_offsets[new_element.element_number] = get_tile_from_pos(new_element.position)
			yield(get_tree().create_timer(0.1), "timeout")
			new_element.element_check_around_and_attach() # comment out to connect only one element at a time
	if area_down.get_overlapping_bodies():
		if area_down.get_overlapping_bodies()[0].is_in_group("elements"):
			var new_element = area_down.get_overlapping_bodies()[0]
			level.remove_child(new_element)
			player.add_child(new_element)
			new_element.position = self.position + position_down.position
			new_element.collision_shape.disabled = true
			player.elements_carried.append(new_element)
			player.elements_offsets[new_element.element_number] = get_tile_from_pos(new_element.position)
			yield(get_tree().create_timer(0.1), "timeout")
			new_element.element_check_around_and_attach() # comment out to connect only one element at a time
	if area_right.get_overlapping_bodies():
		if area_right.get_overlapping_bodies()[0].is_in_group("elements"):
			var new_element = area_right.get_overlapping_bodies()[0]
			level.remove_child(new_element)
			player.add_child(new_element)
			new_element.position = self.position + position_right.position
			new_element.collision_shape.disabled = true
			player.elements_carried.append(new_element)
			player.elements_offsets[new_element.element_number] = get_tile_from_pos(new_element.position)
			yield(get_tree().create_timer(0.1), "timeout")
			new_element.element_check_around_and_attach() # comment out to connect only one element at a time
	if area_left.get_overlapping_bodies():
		if area_left.get_overlapping_bodies()[0].is_in_group("elements"):
			var new_element = area_left.get_overlapping_bodies()[0]
			level.remove_child(new_element)
			player.add_child(new_element)
			new_element.position = self.position + position_left.position
			new_element.collision_shape.disabled = true
			player.elements_carried.append(new_element)
			player.elements_offsets[new_element.element_number] = get_tile_from_pos(new_element.position)
			yield(get_tree().create_timer(0.1), "timeout")
			new_element.element_check_around_and_attach() # comment out to connect only one element at a time

func get_tile_from_pos(position):
	return level.return_tile(position)

func get_pos_from_tile(tile):
	return level.return_middle_pos(tile)
