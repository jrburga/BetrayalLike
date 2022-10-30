extends Spatial
class_name Door

onready var area_3d : Area = get_node("Area")
onready var highlight : MeshInstance = get_node("MIHighlight")

export(NodePath) var Destination = NodePath()

var room_origin = null;
var room_destination = null

signal door_clicked()

func find_parent_room():
	var parent = get_parent()
	return parent

# Called when the node enters the scene tree for the first time.
func _ready():
	room_origin = find_parent_room()
	room_destination = get_node(Destination)
	area_3d.connect("mouse_entered", self, "_on_Area_mouse_entered")
	area_3d.connect("mouse_exited", self, "_on_Area_mouse_exited")
	area_3d.connect("input_event", self, "_on_Area_input_event")
	highlight.visible = false
	
func _on_Area_input_event(camera : Node, event : InputEvent, position : Vector3, normal : Vector3, shape_idx : int):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			emit_signal("door_clicked")
	
func _on_Area_mouse_entered():
	highlight.visible = true
	
func _on_Area_mouse_exited():
	highlight.visible = false
