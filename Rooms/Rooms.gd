tool
extends Spatial
class_name Rooms

export(PackedScene) var room_scene = null
export(bool) var _generate_rooms setget _on_generate_rooms

var rooms = []
var rooms_dict = {}

signal door_clicked(door)

var rooms_string = """
###
"""

func get_room_at(x : int, y : int):
	pass
	
func _clear_rooms():
	while get_child_count():
		remove_child(get_child(0))
		
	rooms.clear()
	rooms_dict.clear()

func generate_rooms():
	_clear_rooms()
	
	var width = 5
	var depth = 5
	rooms_string = rooms_string.strip_edges()
	var y = 0
	for line in rooms_string.split("\n"):
		var x = 0
		for chr in line:
			if chr == "#":
				var new_room = room_scene.instance() as RoomBase
				new_room.width = width
				new_room.depth = depth
				new_room.door_flags = RoomBase.EAST | RoomBase.WEST
				new_room.grid_offset = Vector3(x * width, 0, y * depth)
				
				add_child(new_room)
				new_room.owner = owner
				new_room.generate_room()
				
				rooms.append(new_room)
				rooms_dict[Vector2(x, y)] = new_room
			x += 1
		y += 1
		
	for room_pos in rooms_dict:
		var room = rooms_dict[room_pos] as RoomBase
		
		for direction in [1, 2, 4, 8]:
			var dpos = room_pos + RoomBase.convert_direction(direction)
			if dpos in rooms_dict:
				room.connect_room(rooms_dict[dpos], direction)
			
# Called when the node enters the scene tree for the first time.
func _ready():
	if Engine.editor_hint:
		return
		
	generate_rooms()
	for child in get_children():
		if child is RoomBase:
			child.connect("door_clicked", self, "_on_door_clicked", [child])
			rooms.append(child)

func _on_door_clicked(door : Door, room: RoomBase):
	emit_signal("door_clicked", door)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_generate_rooms(value):
	if !value:
		return
	
	if !Engine.editor_hint:
		return
		
	generate_rooms()
