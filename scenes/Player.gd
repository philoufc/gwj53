extends StaticBody2D

export var current_level = 1
var player_on_tile :Vector2
var free_spaces = {
	"up": 0, 
	"down": 0, 
	"right": 0,
	"left": 0
	}
var can_move = true
var not_exploding = true
var elements_carried = []
var elements_offsets = {}

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var area_up : Area2D = $AreaUp
onready var area_down : Area2D = $AreaDown
onready var area_right : Area2D = $AreaRight
onready var area_left : Area2D = $AreaLeft
onready var raycast_up : RayCast2D = $RayCastUp
onready var raycast_down : RayCast2D = $RayCastDown
onready var raycast_right : RayCast2D = $RayCastRight
onready var raycast_left : RayCast2D = $RayCastLeft
onready var tween : Tween = $Tween
onready var level : Node2D 
onready var main_screen_level
onready var position_up :Position2D = $ElementsPositions/Position2D_up
onready var position_down :Position2D = $ElementsPositions/Position2D_down
onready var position_right :Position2D = $ElementsPositions/Position2D_right
onready var position_left :Position2D = $ElementsPositions/Position2D_left
onready var cauldron :Sprite = $Cauldron
var cauldron_final_position :Vector2

var solutions :Dictionary = {
	1: {
		2: [Vector2(0, 1)]
	},
	2: {
		1: [Vector2(0, -1)]
	},
	3: {
		1: [Vector2(-1, 0)],
		3: [Vector2(1, 0)]
	},
	4: {
		1: [Vector2(0, 1)],
		2: [Vector2(0, -1)]
	},
	5: {
		1: [Vector2(-3, 0)],
		2: [Vector2(-1, 0)],
		3: [Vector2(-2, 0)],
	},
	6: {
		1: [Vector2(1, 0)],
		2: [Vector2(-1, 0)],
		3: [Vector2(2, 0)]
	},
	7: {
		1: [Vector2(-2, 0)],
		2: [Vector2(-1, 0)],
		3: [Vector2(-3, 0)]
	},
	8: {
		3: [
			Vector2(-1, 0),
			Vector2(1, 0),
			Vector2(0, -1),
			Vector2(0, 1)]
	},
	9: {
		3: [Vector2(0, -1)],
		2: [Vector2(1, -1)]
	},
	10: {
		1: [
			Vector2(0, 1),
			Vector2(-1, 0),
			Vector2(1, 0),
			Vector2(-2, -1),
			Vector2(-1, -1),
			Vector2(0, -1),
			Vector2(1, -1),
			Vector2(2, -1),
			Vector2(-1, -2),
			Vector2(1, -2)]
	}
}


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	cauldron.hide()
	current_level = level.level_number
	cauldron_final_position = Vector2(get_viewport_rect().size.x * 0.5, get_viewport_rect().size.y * 0.84)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if can_move and not_exploding:
			update_free_spaces()
			can_move = false
			if event.is_action_pressed("up"):
				if free_spaces["up"] > 0:
					move("up")
				else:
					can_move = true
			elif event.is_action_pressed("down"):
				if free_spaces["down"] > 0:
					move("down")
				else:
					can_move = true
			elif event.is_action_pressed("right"):
				if free_spaces["right"] > 0:
					move("right")
				else:
					can_move = true
				sprite.flip_h = false
			elif event.is_action_pressed("left"):
				if free_spaces["left"] > 0:
					move("left")
				else:
					can_move = true
				sprite.flip_h = true
			else:
				can_move = true

func update_free_spaces():
	raycast_up.cast_to = Vector2(0, -2000)
	raycast_down.cast_to = Vector2(0, 2000)
	raycast_right.cast_to = Vector2(2000, 0)
	raycast_left.cast_to = Vector2(-2000, 0)
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
	var tile_movement = Vector2.ZERO
	var number_of_tiles = 0
	match direction:
		"up":
			tile_movement = Vector2.UP
		"down":
			tile_movement = Vector2.DOWN
		"right":
			tile_movement = Vector2.RIGHT
		"left":
			tile_movement = Vector2.LEFT
#	yield(get_tree().create_timer(0.1), "timeout")
	number_of_tiles = free_spaces[direction]
	for element in elements_carried:
		if element.get_free_spaces(direction) < number_of_tiles:
			number_of_tiles = element.get_free_spaces(direction)
	
	if number_of_tiles > 0:
		tween.interpolate_property(
			self, 
			"position", 
			self.position, 
			self.position + (tile_movement * number_of_tiles * Global.TILE_SIZE), 
			clamp(0.15 * number_of_tiles, 0.42, 0.84),
			Tween.TRANS_BACK, 
			Tween.EASE_IN)
		tween.start()
#		Global.sfx_player.stream = whoosh
#		Global.sfx_player.play()
		yield(tween, "tween_completed")
		yield(get_tree().create_timer(0.1), "timeout")
		check_around_and_attach()
		for element in elements_carried:
			element.element_check_around_and_attach()
		Global.number_of_moves += 1
		Global.update_ui()
		can_move = true
		if level.tile_is_exit(get_tile_from_pos(position)):
			check_if_level_complete(Global.game_difficulty)
		
	else:
		can_move = true

func check_around_and_attach():
	if area_up.get_overlapping_bodies():
		if area_up.get_overlapping_bodies()[0].is_in_group("elements"):
			var element = area_up.get_overlapping_bodies()[0]
			element.get_parent().remove_child(element)
			self.add_child(element)
			element.position = position_up.position
			element.collision_shape.disabled = true
			elements_carried.append(element)
			if not element.element_number in elements_offsets.keys():
				elements_offsets[element.element_number] = []
			elements_offsets[element.element_number].append(get_tile_from_pos(element.position))
			yield(get_tree().create_timer(0.1), "timeout")
			element.element_check_around_and_attach() # comment out to connect only one element at a time
	if area_down.get_overlapping_bodies():
		if area_down.get_overlapping_bodies()[0].is_in_group("elements"):
			var element = area_down.get_overlapping_bodies()[0]
			element.get_parent().remove_child(element)
			self.add_child(element)
			element.position = position_down.position
			element.collision_shape.disabled = true
			elements_carried.append(element)
			if not element.element_number in elements_offsets.keys():
				elements_offsets[element.element_number] = []
			elements_offsets[element.element_number].append(get_tile_from_pos(element.position))
			yield(get_tree().create_timer(0.1), "timeout")
			element.element_check_around_and_attach() # comment out to connect only one element at a time
	if area_right.get_overlapping_bodies():
		if area_right.get_overlapping_bodies()[0].is_in_group("elements"):
			var element = area_right.get_overlapping_bodies()[0]
			element.get_parent().remove_child(element)
			self.add_child(element)
			element.position = position_right.position
			element.collision_shape.disabled = true
			elements_carried.append(element)
			if not element.element_number in elements_offsets.keys():
				elements_offsets[element.element_number] = []
			elements_offsets[element.element_number].append(get_tile_from_pos(element.position))
			yield(get_tree().create_timer(0.1), "timeout")
			element.element_check_around_and_attach() # comment out to connect only one element at a time
	if area_left.get_overlapping_bodies():
		if area_left.get_overlapping_bodies()[0].is_in_group("elements"):
			var element = area_left.get_overlapping_bodies()[0]
			element.get_parent().remove_child(element)
			self.add_child(element)
			element.position = position_left.position
			element.collision_shape.disabled = true
			elements_carried.append(element)
			if not element.element_number in elements_offsets.keys():
				elements_offsets[element.element_number] = []
			elements_offsets[element.element_number].append(get_tile_from_pos(element.position))
			yield(get_tree().create_timer(0.1), "timeout")
			element.element_check_around_and_attach() # comment out to connect only one element at a time
#	print(elements_offsets)


func check_if_level_complete(difficulty):
	can_move = false
	var final_positions = []
	flatten_array(elements_offsets.values(), final_positions)
	var removed_duplicates = []
	for pos in final_positions:
		if not pos in removed_duplicates:
			removed_duplicates.append(pos)
	final_positions = removed_duplicates
	final_positions.sort()
	var solution_positions = []
	flatten_array(solutions[current_level].values(), solution_positions)
	solution_positions.sort()
	removed_duplicates = []
	for element in elements_carried:
		if not element in removed_duplicates:
			removed_duplicates.append(element)
	elements_carried = removed_duplicates
	print(elements_offsets)
	print(elements_carried)
	if len(final_positions) == len(solution_positions):
		var found_discrepancy = false
		match difficulty:
			"hard":
#					print("our shape:", elements_offsets)
#					print("solution:", solutions[current_level])
				for element in solutions[current_level]:
					if solutions[current_level][element] != elements_offsets[element]:
						found_discrepancy = true
						break
			"normal":
				if final_positions != solution_positions:
					found_discrepancy = true
						
		if !found_discrepancy:
			$LevelEnd.text = "win!"
			$LevelEnd.show()
#			yield(get_tree().create_timer(2), "timeout")
			$LevelEnd.hide()
			if current_level in Global.keeping_scores:
				Global.keeping_scores[current_level] = min(Global.keeping_scores[current_level], Global.number_of_moves)
			else:
				Global.keeping_scores[current_level] = Global.number_of_moves
			print(Global.keeping_scores)
			cauldron_assembly()
#			yield(cauldron_assembly(), "completed")
			yield(cauldron.animated_sprite, "animation_finished")
			Global.fade_sweep()
			yield(get_tree().create_timer(0.8), "timeout")
			Global.ui_moves.hide()
			main_screen_level.next_level(Global.current_level)
			level.queue_free()
		else:
			Global.show_restart_message()
			can_move = true
	else:
		Global.show_restart_message()
		can_move = true

func cauldron_assembly():
	cauldron.scale = Vector2(0.1, 0.1)
	cauldron.show()
	tween.interpolate_property(cauldron, "scale", Vector2(0.4, 0.4), Vector2(2, 2), 1.5, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	tween.interpolate_property(cauldron, "global_position", self.global_position, cauldron_final_position, 2, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	for element in elements_carried:
		element.z_index = 2
		var new_tween = Tween.new()
		add_child(new_tween)
		yield(get_tree(), "idle_frame")
		new_tween.interpolate_property(element, "global_position:x", element.global_position.x, (cauldron_final_position.x + element.global_position.x) / 2, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN)
		new_tween.interpolate_property(element, "global_position:y", element.global_position.y, element.global_position.y - 64, 0.4, Tween.TRANS_LINEAR)
		new_tween.interpolate_property(element, "scale", element.scale, element.scale * 2, 0.4)
		new_tween.start()
		yield(new_tween, "tween_completed")
		remove_child(new_tween)
		var new_tween_2 = Tween.new()
		add_child(new_tween_2)
		new_tween_2.interpolate_property(element, "global_position:x", element.global_position.x, cauldron_final_position.x, 0.6, Tween.TRANS_QUAD, Tween.EASE_OUT)
		new_tween_2.interpolate_property(element, "global_position:y", element.global_position.y, cauldron_final_position.y, 0.6, Tween.TRANS_SINE)
		new_tween_2.interpolate_property(element, "scale", element.scale, element.scale * 0.66, 0.4)
		new_tween_2.start()
		yield(new_tween_2, "tween_completed")
		element.hide()
		remove_child(new_tween_2)
	cauldron.smoking_is_bad()
	
	#bubulblblublbulublub

func flatten_array(array, flattened):
	for element in array:
		if typeof(element) == TYPE_ARRAY:
			flatten_array(element, flattened)
		else:
			flattened.append(element)

func get_tile_from_pos(position):
	return level.return_tile(position)

func get_pos_from_tile(tile):
	return level.return_middle_pos(tile)
#	return get_tree().root.get_node("Level").return_middle_pos(tile)
