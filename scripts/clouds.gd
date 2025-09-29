extends MeshInstance3D




func _physics_process(delta: float) -> void:
	material_override.uv1_offset = material_override.uv1_offset + Vector3(0.00001, 0.00001, 0)
	
