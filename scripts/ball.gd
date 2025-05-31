extends RigidBody3D
const OUTLINEMATERIAL = preload("res://scenes/outlinematerial.tres")
func _ready() -> void:
	var val =  randf_range(.6, 1.3)
	scale = Vector3(val,val,val)
	apply_torque(Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50)))
	var mat = StandardMaterial3D.new()
	
	mat.albedo_color = Color(randf(),randf(),randf())
	mat.next_pass = OUTLINEMATERIAL
	$CollisionShape3D/MeshInstance3D.material_override = mat
