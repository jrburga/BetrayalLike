tool
extends Spatial
class_name TileMap3D

export(bool) var clear_map : bool = false setget _on_clear_map
export(bool) var generate_map : bool = false setget _on_generate_map
export(PackedScene) var tile_scene : PackedScene = null
export(Vector2) var tile_size : Vector2 = Vector2(2, 2)

var map_string = """
0001100
0111110
1111111
1111111
1111111
1111111
1111111
1111111
"""

func _ready():
	_on_generate_map()

func _on_clear_map(value=true):
	while get_child_count():
		remove_child(get_child(0))

func _on_generate_map(value=true):
	_on_clear_map()
	if tile_scene == null:
		return
	var map_string_stripped = map_string.strip_edges() as String

	var z_offset = 0
	for line in map_string_stripped.split("\n"):
		var x_offset = 0
		for chr in line:
			if chr != "1":
				x_offset += tile_size.x
				continue
			var new_tile = tile_scene.instance() as Spatial
			new_tile.translation = Vector3(x_offset, 0, z_offset)
			add_child(new_tile)
			new_tile.owner = self.owner if self.owner else self
			x_offset += tile_size.x
		z_offset += tile_size.y
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
