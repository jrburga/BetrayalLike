tool
extends Spatial
class_name Prototype3D

export(bool) var _print_grid_map = false setget _on_print_grid_map
func _ready():
	pass

onready var grid_map = get_node("%GridMap") as GridMap
onready var camera = get_node("%Camera") as Camera
onready var character = get_node("%Character3D") as Character3D

var mouse_button_down = false
func _physics_process(delta):
	if Engine.editor_hint:
		return
	var mouse = get_viewport().get_mouse_position()
	
	
	
	var ray_length = 100
	var cast_from = camera.project_ray_origin(mouse)
	var cast_to = cast_from + camera.project_ray_normal(mouse) * ray_length

	var was_mouse_button_down = mouse_button_down
	mouse_button_down = Input.is_mouse_button_pressed(1)
	
	var mouse_just_pressed = mouse_button_down and not was_mouse_button_down
	
	if mouse_just_pressed:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(
			cast_from, 
			cast_to, 
			[], # exclude
			10000
			)
		
		if result:
			var half_size = grid_map.cell_size / 2
			var map_pos = grid_map.world_to_map(result.position)
			var center_pos = grid_map.map_to_world(map_pos.x, map_pos.y, map_pos.z) + half_size
			center_pos.y = 0
			
			print(center_pos)
			character.set_target_location(center_pos)

func _on_print_grid_map(value):
	if !value:
		return
	
	
	var half_size = grid_map.cell_size / 2
	var center_pos = grid_map.map_to_world(0, 0, 0) + half_size
	print(center_pos)
