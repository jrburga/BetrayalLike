extends Spatial
class_name RoomSpace

var doors = []
var navigation_position : Position3D = null

signal door_clicked(door)

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
	print("door clicked: ", door)
	emit_signal("door_clicked", door)
