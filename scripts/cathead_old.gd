extends RigidBody3D
@onready var body: RigidBody3D = $"../Body"
@onready var cat: Node = $".."
@onready var sprite_3d: AnimatedSprite3D = $Collision/Sprite3D
var looking := false
@onready var look_target: Vector3
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:


	if looking:
		if cat.thingtolookat_head != null and cat.thingtolookat_head != self:
			look_target = cat.thingtolookat_head.global_position
		var target_direction: Vector3 = (look_target - state.transform.origin).normalized()
		var current_forward: Vector3 = state.transform.basis.z 
		var rotation_axis: Vector3 = current_forward.cross(target_direction).normalized()
		var rotation_angle: float = acos(current_forward.dot(target_direction))
		var torque: Vector3 = rotation_axis * rotation_angle * 20 - (state.angular_velocity * owner.limbdamping)
		state.apply_torque(torque)
