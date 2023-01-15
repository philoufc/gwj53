extends StaticBody2D

export var current_level = 1
var player_on_tile :Vector2
var free_spaces = {
	"up": 0, 
	"down": 0, 
	"right": 0,
	"left": 0
	}
var is_moving = false
var elements_carried = []

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var area_up : Area2D = $Area_up
onready var area_down : Area2D = $Area_down
onready var area_left : Area2D = $Area_left
onready var area_right : Area2D = $Area_right
onready var raycast_up : RayCast2D = $RayCast_up
onready var raycast_down : RayCast2D = $RayCast_down
onready var raycast_left : RayCast2D = $RayCast_left
onready var raycast_right : RayCast2D = $RayCast_right
onready var elements : Node2D = $Elements
onready var tween : Tween = $Tween

func _ready() -> void:
	self.position = get_pos_from_tile(get_tile_from_pos(self.position))
	for element in get_tree().get_nodes_in_group("elements"):
		elements_carried.append(element)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		update_free_spaces()
		if not is_moving:
			if event.is_action_pressed("up"):
				if free_spaces["up"] > 0:
					move("up")
			elif event.is_action_pressed("down"):
				if free_spaces["down"] > 0:
					move("down")
			elif event.is_action_pressed("right"):
				if free_spaces["right"] > 0:
					move("right")
				sprite.flip_h = false
			elif event.is_action_pressed("left"):
				if free_spaces["left"] > 0:
					move("left")
				sprite.flip_h = true

func update_free_spaces():
	raycast_up.cast_to = Vector2(0, -2000)
	raycast_down.cast_to = Vector2(0, 2000)
	raycast_right.cast_to = Vector2(2000, 0)
	raycast_down.cast_to = Vector2(-2000, 0)
	for i in free_spaces: free_spaces[i] = 0
	if raycast_up.is_colliding():
		free_spaces["up"] = int(abs(raycast_up.get_collision_point().y - self.position.y) / Global.TILE_SIZE)
	if raycast_down.is_colliding():
		free_spaces["down"] = int(abs(raycast_down.get_collision_point().y - self.position.y) / Global.TILE_SIZE)
	if raycast_right.is_colliding():
		free_spaces["right"] = int(abs(raycast_right.get_collision_point().x - self.position.x) / Global.TILE_SIZE)
	if raycast_left.is_colliding():
		free_spaces["left"] = int(abs(raycast_left.get_collision_point().x - self.position.x) / Global.TILE_SIZE)
	
func move(direction):
	is_moving = true
	var tile_movement = Vector2.ZERO
	match direction:
		"up":
			tile_movement = Vector2.UP
		"down":
			tile_movement = Vector2.DOWN
		"right":
			tile_movement = Vector2.RIGHT
		"left":
			tile_movement = Vector2.LEFT
	tween.interpolate_property(
		self, 
		"position", 
		self.position, 
		self.position + (tile_movement * free_spaces[direction] * Global.TILE_SIZE), 
		0.5, 
		Tween.TRANS_BACK, 
		Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	is_moving = false
	yield(get_tree().create_timer(0.1), "timeout")
	check_around_and_attach()

func check_around_and_attach():
	if area_up.get_overlapping_bodies():
		if area_up.get_overlapping_bodies()[0].is_in_group("elements"):
			var element = area_up.get_overlapping_bodies()[0]
			print("it's elemental, dear watson!", element)
			element.get_parent().remove_child(element)
			elements.add_child(element)
			element.position = $Elements/Position2D_up.position
	if area_down.get_overlapping_bodies():
		if area_down.get_overlapping_bodies()[0].is_in_group("elements"):
			var element = area_down.get_overlapping_bodies()[0]
			print("it's elem!", element)
	if area_right.get_overlapping_bodies():
		if area_right.get_overlapping_bodies()[0].is_in_group("elements"):
			print("it's elemental, dear watson!")
	if area_left.get_overlapping_bodies():
		if area_left.get_overlapping_bodies()[0].is_in_group("elements"):
			print("it's elemental, dear watson!")

func get_tile_from_pos(position):
	return get_tree().root.get_node("Level").return_tile(position)

func get_pos_from_tile(tile):
	return get_tree().root.get_node("Level").return_middle_pos(tile)
