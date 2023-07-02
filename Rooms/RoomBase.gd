tool
extends Spatial
class_name RoomBase

enum {
	NORTH = 1,
	EAST  = 2,
	SOUTH = 4,
	WEST  = 8
}

static func convert_direction(direction : int):
	match direction:
		NORTH: return Vector2(0, -1)
		EAST: return Vector2(1, 0)
		SOUTH: return Vector2(0, 1)
		WEST: return Vector2(-1, 0)

class RoomDef:
	var width : int = 5
	var depth : int = 5
	var height : int = 2
	var door_flags : int = NORTH | EAST | SOUTH | WEST

export(Vector3) var grid_offset = Vector3()
export(int) var width = 5
export(int) var depth = 5
export(int) var height = 2
export(int, FLAGS, "North", "East", "South", "West") var door_flags

export(bool) var _generate_room = false setget _on_generate_room
export(bool) var _print_tiles = false setget _on_print_tiles

export(PackedScene) var door_scene : PackedScene = null

var doors = []
var doors_dict = {}
var connected_rooms = {}
var navigation_position : Position3D = null

onready var grid_map : GridMap = get_node("GridMap") as GridMap

signal door_clicked(door)

func _create_door(x : int, y : int, z : int, orientation : int = 0) -> Door:
	var cell_pos = Vector3(x, y, z)
	var new_door = door_scene.instance() as Door
	add_child(new_door)
	new_door.owner = owner if owner else self
	var half_size = grid_map.cell_size / 2
	half_size.y = 0
	new_door.global_translation = grid_map.cell_size * cell_pos + half_size
	new_door.global_rotation = Vector3(0, deg2rad(orientation * 90), 0)
	
	new_door.connect("door_clicked", self, "_on_door_clicked", [new_door])
	return new_door
	
func _clear_doors():
	for child_index in range(get_child_count() - 1, -1, -1):
		var child = get_child(child_index)
		if child is Door:
			remove_child(child)
	
	doors.clear()
	doors_dict.clear()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.editor_hint:
		return
	for child in get_children():
		if child is Door:
			child.connect("door_clicked", self, "_on_door_clicked", [child])
			child.room_origin = self
			var direction = get_door_direction(child)
			if direction in connected_rooms:
				print("connecting door: ", child, " ", connected_rooms[direction])
				child.room_destination = connected_rooms[direction]
			doors.append(child)
			
		if child is Position3D:
			navigation_position = child

func _on_door_clicked(door : Door):
	assert(door)
	emit_signal("door_clicked", door)
	
func connect_room(other_room, direction):
	connected_rooms[direction] = other_room
	if Engine.editor_hint:
		return
	if direction in doors_dict:
		var door : Door = doors_dict[direction]
		door.room_destination = other_room
	
func get_door_direction(door : Door):
	for direction in doors_dict:
		if doors_dict[direction] == door:
			return direction
	return 0
	
func generate_room():
	grid_map = get_node("GridMap") as GridMap
	
	_clear_doors()
	grid_map.clear()
	for x in range(width):
		for z in range(depth):
			var cell_pos = Vector3(x, 0, z) + grid_offset
			
			var created_door : bool = false
			if (door_flags & NORTH) and (x == width / 2 and z == 0):
				var door = _create_door(cell_pos.x, 0, cell_pos.z, 0)
				doors.append(door)
				doors_dict[NORTH] = door
				created_door = true
			elif (door_flags & EAST) and (x == width - 1 and z == depth / 2):
				var door = _create_door(cell_pos.x, 0, cell_pos.z, 3)
				doors.append(door)
				doors_dict[EAST] = door
				created_door = true
			elif (door_flags & SOUTH) and (x == width / 2 and z == depth - 1):
				var door = _create_door(cell_pos.x, 0, cell_pos.z, 2)
				doors.append(door)
				doors_dict[SOUTH] = door
				created_door = true
			elif (door_flags & WEST) and (x == 0 and z == depth / 2):
				var door = _create_door(cell_pos.x, 0, cell_pos.z, 1)
				doors.append(door)
				doors_dict[WEST] = door
				created_door = true
				
			if x == 0:
				if z == 0:
					grid_map.set_cell_item(cell_pos.x, cell_pos.y, cell_pos.z, 3, 0)
				elif z == depth:
					grid_map.set_cell_item(cell_pos.x, cell_pos.y, cell_pos.z, 3, 16)
				else:
					pass
			elif x == width:
				if z == 0:
					grid_map.set_cell_item(cell_pos.x, cell_pos.y, cell_pos.z, 3, 22)
				elif z == depth:
					grid_map.set_cell_item(cell_pos.x, cell_pos.y, cell_pos.z, 3, 10)
				else:
					pass
			else:
				grid_map.set_cell_item(cell_pos.x, cell_pos.y, cell_pos.z, 0)
				
	var position_3d = find_node("Position3D") as Position3D
	if not position_3d:
		position_3d = Position3D.new()
		add_child(position_3d)

	position_3d.owner = owner if owner else self
	if position_3d:
		var cell_pos = Vector3(width / 2, 0, depth / 2) + grid_offset
		var half_size = grid_map.cell_size / 2
		half_size.y = 0
		position_3d.global_translation = grid_map.cell_size * cell_pos + half_size

func _on_generate_room(value):
	if !value:
		return
		
	if !Engine.editor_hint:
		return
		
	generate_room()
	
func _on_print_tiles(value):
	if !value:
		return
	
	if !Engine.editor_hint:
		return
		
	grid_map = get_node("GridMap") as GridMap
	
	for cell in grid_map.get_used_cells():
		var item = grid_map.get_cell_item(cell.x, cell.y, cell.z)
		var orientation = grid_map.get_cell_item_orientation(cell.x, cell.y, cell.z)
		
		print("Cell: ", cell, ", ", item, ", ", orientation)
