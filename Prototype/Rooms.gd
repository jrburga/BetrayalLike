extends Spatial
class_name Rooms

var rooms = []

signal door_clicked(door)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is RoomSpace:
			child.connect("door_clicked", self, "_on_door_clicked", [child])
			rooms.append(child)

func _on_door_clicked(door : Door, room: RoomSpace):
	emit_signal("door_clicked", door)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
