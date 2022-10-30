tool
extends Spatial
class_name MeshMergerTool

export(bool) var merge_meshes = false setget _on_merge_meshes
export(bool) var print_normals = false setget _on_print_normals

func _on_print_normals(value):
	if not value:
		return
	var meshes = get_children()
	meshes.append(self)
	for child in meshes:
		var mesh_inst = child as MeshInstance
		if not mesh_inst:
			continue
		var arrays_inst = mesh_inst.mesh.surface_get_arrays(0) as Array
		var arr_normal = arrays_inst[Mesh.ARRAY_NORMAL]
		
		for normal in arr_normal:
			print(normal)
			
func _on_merge_meshes(value):
	if value:
		_merge_meshes()

func _merge_meshes():
	var arr_mesh = ArrayMesh.new()
	var new_mesh = MeshInstance.new()
	var arrays_new = []
	arrays_new.resize(Mesh.ARRAY_MAX)
	
	var arr_vertex = PoolVector3Array()
	var arr_normal = PoolVector3Array()
	var arr_tangent = PoolRealArray()
	var arr_color = PoolColorArray()
	var arr_uv = PoolVector2Array()
	var arr_uv2 = PoolVector2Array()
	var arr_bones = PoolRealArray()
	var arr_weights = PoolRealArray()
	var arr_index = PoolIntArray()

	
	for child in get_children():
		var mesh_inst = child as MeshInstance
		if not mesh_inst:
			continue

		var arrays_inst = mesh_inst.mesh.surface_get_arrays(0) as Array
		var material = mesh_inst.mesh.surface_get_material(0) as SpatialMaterial
		for array_idx in Mesh.ARRAY_MAX:
			var array_inst = arrays_inst[array_idx]
			if array_inst == null:
				continue
			
			if array_idx == Mesh.ARRAY_VERTEX:
				for idx in array_inst.size():
					var vertex = array_inst[idx]
					var global_vertex = mesh_inst.to_global(vertex)
					arr_vertex.push_back(global_vertex)
			elif array_idx == Mesh.ARRAY_NORMAL:
				for idx in array_inst.size():
					var normal = array_inst[idx] as Vector3
					var rotated_normal = mesh_inst.transform.basis.xform(normal)
					arr_normal.push_back(rotated_normal)
			elif array_idx == Mesh.ARRAY_TANGENT:
				for idx in array_inst.size():
					var tangent = array_inst[idx]
					print(tangent)
					arr_tangent.push_back(array_inst[idx])
			elif array_idx == Mesh.ARRAY_TEX_UV:
				var uv_scale = Vector3(1, 1, 1)
				var uv_offset = Vector3(0, 0, 0)
				if material:
					uv_scale = material.uv1_scale
					uv_offset = material.uv1_offset
				for idx in array_inst.size():
					var scaled_uv = Vector2(
						array_inst[idx].x * uv_scale.x + uv_offset.x, 
						array_inst[idx].y * uv_scale.y + uv_offset.y
					)
					arr_uv.push_back(scaled_uv)
			
	
	arrays_new[Mesh.ARRAY_VERTEX] = arr_vertex
	arrays_new[Mesh.ARRAY_NORMAL] = arr_normal
	arrays_new[Mesh.ARRAY_TANGENT] = arr_tangent
	arrays_new[Mesh.ARRAY_COLOR] = arr_color if arr_color.size() > 0 else null
	arrays_new[Mesh.ARRAY_TEX_UV] = arr_uv
	arrays_new[Mesh.ARRAY_TEX_UV2] = arr_uv2 if arr_uv2.size() > 0 else null
	arrays_new[Mesh.ARRAY_BONES] = arr_bones if arr_bones.size() > 0 else null
	arrays_new[Mesh.ARRAY_WEIGHTS] = arr_weights if arr_weights.size() > 0 else null
	arrays_new[Mesh.ARRAY_INDEX] = arr_index if arr_index.size() > 0 else null

	print(arr_uv)
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays_new)
	new_mesh.mesh = arr_mesh
	owner.add_child(new_mesh)
	new_mesh.owner = owner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
