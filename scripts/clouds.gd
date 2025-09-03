extends MeshInstance3D
func _process(_delta: float) -> void:
	material_override.albedo_texture.noise.offset += Vector3(0.05,0.05,0)
