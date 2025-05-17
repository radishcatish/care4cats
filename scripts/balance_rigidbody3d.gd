extends RigidBody3D
var head_damping := .5
var head_speed   := 25
var loose := false

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if not loose:
		var correction_axis: Vector3 = state.transform.basis.y.cross(Vector3.UP)
		var total_torque: Vector3 = correction_axis * head_speed + (-state.angular_velocity * head_damping)
		state.apply_torque(total_torque)
		
