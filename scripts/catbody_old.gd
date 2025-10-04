extends RigidBody3D

@onready var left_front: RigidBody3D = $"../LeftFront"
@onready var right_front: RigidBody3D = $"../RightFront"
@onready var left_back: RigidBody3D = $"../LeftBack"
@onready var right_back: RigidBody3D = $"../RightBack"
@onready var cat: Node = $".."
@onready var forward_direction : Vector3 = transform.basis.x.normalized()
@onready var look_target: Vector3
var timer := randf()
var iswalking := true
var islooking := false
var loose := false
var sitting := false
var laying := false
func _ready() -> void:
	if sitting:
		right_back.apply_torque(forward_direction * -35)
		left_back.apply_torque(forward_direction * -35)



func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	var correction_axis: Vector3 = state.transform.basis.y.cross(Vector3.UP)
	var total_torque: Vector3 = correction_axis * 20 + (-state.angular_velocity * .2)
	var target_direction: Vector3 = (state.transform.origin - look_target).normalized()
	var current_forward: Vector3 = -state.transform.basis.z
	var rotation_axis: Vector3 = current_forward.cross(target_direction).normalized()
	var rotation_angle: float = acos(current_forward.dot(target_direction))
	var torque: Vector3 = rotation_axis * rotation_angle * 20 - (state.angular_velocity * .2)
	forward_direction = transform.basis.x.normalized()

	
	if islooking and cat.thingtolookat_body:
		look_target = cat.thingtolookat_body.position
		state.apply_torque(torque)
		
	if not loose:
		state.apply_torque(total_torque)
		
	if iswalking:
		var forward = transform.basis.z.normalized()
		state.apply_central_force(forward * 50.0) # adjust strength
		var walkwave = sin(Time.get_ticks_msec() * 10.0) * 60.0
		left_front.apply_torque(forward_direction * -walkwave)
		right_back.apply_torque(forward_direction * -walkwave)
		right_front.apply_torque(forward_direction * walkwave)
		left_back.apply_torque(forward_direction * walkwave)
		
	if laying:
		right_front.apply_torque(forward_direction * -10)
		left_front.apply_torque(forward_direction * -10)
		right_back.apply_torque(forward_direction * 10)
		left_back.apply_torque(forward_direction * 10)
		
	if sitting:
		right_back.apply_torque(forward_direction * -2)
		left_back.apply_torque(forward_direction * -2)

	#right_back.loose = sitting or laying 
	#left_back.loose = sitting or laying 
	#right_front.loose = laying 
	#left_front.loose = laying 
	#loose = (sitting or laying)
