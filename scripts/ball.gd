extends RigidBody3D
func _ready() -> void:
	var val =  randf_range(.6, 1.3)
	scale = Vector3(val,val,val)
	apply_torque(Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50)))
	var mat = StandardMaterial3D.new()
	
	mat.albedo_color = Color(randf(),randf(),randf())
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	$CollisionShape3D/MeshInstance3D.material_override = mat
