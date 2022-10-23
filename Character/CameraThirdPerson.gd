extends Camera

export(bool) var enable_look_at = false
export(NodePath) var look_at_target = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if enable_look_at:
		var look_at_node = get_node(look_at_target) as Spatial
		if look_at_node:
			look_at(look_at_node.global_translation, Vector3.UP)
