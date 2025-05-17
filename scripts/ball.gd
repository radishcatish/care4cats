extends RigidBody3D
func _ready() -> void:

	apply_torque(Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50)))
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(randf(),randf(),randf())
	$CollisionShape3D/MeshInstance3D.material_override = mat
