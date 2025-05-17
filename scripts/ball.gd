extends RigidBody3D

func _ready() -> void:
	apply_force(Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50)))
	apply_torque(Vector3(randf_range(-50, 50), randf_range(-50, 50), randf_range(-50, 50)))
