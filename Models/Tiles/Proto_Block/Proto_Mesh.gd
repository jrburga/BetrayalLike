tool
extends MeshInstance
class_name ProtoMesh

export(String, "Dark", "Light") var style = "Dark" setget _set_style
export(int, 1, 13) var variant = 1 setget _set_variant

func create_texture_path():
	return "res://Textures/Prototype/%s/texture_%02d.png" % [style, variant]

func find_mesh_instance() -> MeshInstance:
	if self is MeshInstance:
		return self
	for child in get_children():
		if child is MeshInstance:
			return child
	return null

func _set_style(value):
	CSGBox
	style = value
	var path = create_texture_path()
	var mesh : MeshInstance = find_mesh_instance()
	var material = mesh.get_surface_material(0)
	material.albedo_texture = load(path)
	
func _set_variant(value):
	variant = value
	var path = create_texture_path()
	var mesh : MeshInstance = find_mesh_instance()
	var material = mesh.get_surface_material(0)
	material.albedo_texture = load(path)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
