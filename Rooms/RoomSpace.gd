tool
extends Spatial
class_name RoomSpace

export(int) var width = 5
export(int) var depth = 5
export(int) var height = 2

export(bool) var generate_room = false setget _on_generate_room

export(PackedScene) var door_scene : PackedScene = null

func _on_generate_room(value):
	if !value:
		return
		
	if !Engine.editor_hint:
		return
		
	grid_map = get_node("GridMap") as GridMap
	
	_clear_doors()
	grid_map.clear()
	
	for x in range(width):
		for z in range(depth):
			grid_map.set_cell_item(x, 0, z, 0)
			
			if x == width / 2 and z == 0:
				_create_door(x, 0, z)
			elif x == 0 and z == depth / 2:
				_create_door(x, 0, z, 1)
			elif x == width / 2 and z == depth - 1:
				_create_door(x, 0, z, 2)
			elif x == width - 1 and z == depth / 2:
				_create_door(x, 0, z, 3)
				
	var position_3d = find_node("Position3D") as Position3D
	if position_3d:
		var half_size = grid_map.cell_size / 2
		half_size.y = 0
		position_3d.global_translation = grid_map.cell_size * Vector3(width / 2, 0, depth / 2) + half_size

var doors = []
var navigation_position : Position3D = null

onready var grid_map : GridMap = get_node("GridMap") as GridMap

signal door_clicked(door)

func _create_door(x : int, y : int, z : int, orientation : int = 0) -> Door:
	var new_door = door_scene.instance() as Door
	add_child(new_door)
	new_door.owner = owner if owner else self
	var half_size = grid_map.cell_size / 2
	half_size.y = 0
	new_door.global_translation = grid_map.cell_size * Vector3(x, 0, z) + half_size
	new_door.global_rotation = Vector3(0, deg2rad(orientation * 90), 0)
	return new_door
	
func _clear_doors():
	for child_index in range(get_child_count() - 1, -1, -1):
		var child = get_child(child_index)
		if child is Door:
			remove_child(child)
	
	doors.clear()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Door:
			child.connect("door_clicked", self, "_on_door_clicked", [child])
			child.room_origin = self
			doors.append(child)
			
		if child is Position3D:
			navigation_position = child

func _on_door_clicked(door : Door):
	emit_signal("door_clicked", door)
