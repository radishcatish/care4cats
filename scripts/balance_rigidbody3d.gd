extends RigidBody3D
var damping : float = 0
var speed   : float = 50
var loose   : bool  = false

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if not loose:
		var correction_axis: Vector3 = state.transform.basis.y.cross(Vector3.UP)
		var total_torque: Vector3 = correction_axis * speed + (-state.angular_velocity * damping)
		state.apply_torque(total_torque)
