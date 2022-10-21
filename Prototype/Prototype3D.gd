tool
extends Spatial


export(bool) var print_owner = false setget _on_print_owner


func _on_print_owner(value):
	print(owner)
