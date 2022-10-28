tool
extends Spatial
class_name Prototype3D

export(bool) var _print_grid_map = false setget _on_print_grid_map
func _ready():
	pass

onready var grid_map
onready var camera = get_node("%Camera") as Camera
onready var character = get_node("%Character3D") as Character3D
onready var highlight = get_node("%MIHighlight")

func find_grid_map_under_mouse():
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 100
	var cast_from = camera.project_ray_origin(mouse_position)
	var cast_to = cast_from + camera.project_ray_normal(mouse_position) * ray_length

	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(
		cast_from, 
		cast_to, 
		[], # exclude
		10000 # mask for grid map
		)
	
	return result

var mouse_button_down = false
func _physics_process(delta):
	if Engine.editor_hint:
		return
		
	if !grid_map:
		highlight.visible = false
		return

	var was_mouse_button_down = mouse_button_down
	mouse_button_down = Input.is_mouse_button_pressed(1)
	
	var mouse_just_pressed = mouse_button_down and not was_mouse_button_down
	var result = find_grid_map_under_mouse()
	
	
	if result:
		highlight.visible = true
		var half_size = grid_map.cell_size / 2
		var map_pos = grid_map.world_to_map(result.position + Vector3(0, 0.1, 0))
		var h_pos = grid_map.map_to_world(map_pos.x, map_pos.y, map_pos.z)
		highlight.translation = h_pos
	else:
		highlight.visible = false
		
	if mouse_just_pressed and result:
		var half_size = grid_map.cell_size / 2
		var map_pos = grid_map.world_to_map(result.position + Vector3(0, 0.1, 0))
		var center_pos = grid_map.map_to_world(map_pos.x, map_pos.y, map_pos.z) + half_size
		center_pos.y = 0
		character.set_target_location(center_pos)

func _on_print_grid_map(value):
	if !value:
		return
	
	
	var half_size = grid_map.cell_size / 2
	var center_pos = grid_map.map_to_world(0, 0, 0) + half_size
