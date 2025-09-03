extends RigidBody3D
func _integrate_forces(state: PhysicsDirectBodyState3D): pass
func apply_custom_forces(state: PhysicsDirectBodyState3D):
	state.apply_torque(state.transform.basis.y.cross(Vector3.UP) * 50 + (-state.angular_velocity))
