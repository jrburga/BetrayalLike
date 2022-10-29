tool
extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var grid_map : GridMap = get_node("Walls")

export(bool) var print_meshes = false setget _on_print_meshes

func _on_print_meshes(value):
	grid_map = get_node("Walls")
	print(grid_map.get_meshes())

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
