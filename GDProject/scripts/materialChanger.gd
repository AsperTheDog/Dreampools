@tool
extends Node3D

@export var material: BaseMaterial3D:
	set(value):
		material = value
		setMaterials(self)


func setMaterials(node):
	if node.name == "EXCLUSION" or node.name.begins_with("ex-"):
		return
	for N in node.get_children():
		if N.is_class("MeshInstance3D"):
			N.set_surface_override_material(0, material)
		setMaterials(N)

func _ready():
	setMaterials(self)
