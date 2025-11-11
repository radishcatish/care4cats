extends CharacterBody3D
var mouse_sensitivity = 0.01
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $Camera
@onready var ray = $Camera/RayCast3D
@onready var hold_point = $Camera/Node3D
@onready var right_hand: MeshInstance3D = $RightHand
@onready var left_hand: MeshInstance3D = $LeftHand
@onready var camera_hand: MeshInstance3D = $Camera/Hand


var body
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		var rotation_x = camera.rotation.x
		rotation_x = clampf(rotation_x, deg_to_rad(-90), deg_to_rad(90))
		camera.rotation.x = rotation_x
		
func _physics_process(delta):
	velocity.y += 1 if Input.is_action_pressed("jump") else 0
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity += Vector3(direction.x * 1.5, -gravity * delta, direction.z * 1.5)
	velocity *= Vector3(.9, 1, .9)
	move_and_slide()
	
	if Input.is_action_just_pressed("scrolldown"):
		hold_point.position.z += 1
	if Input.is_action_just_pressed("scrollup"):
		hold_point.position.z -= 1
	hold_point.position.z = clamp(hold_point.position.z, -3, -1)
	if Input.is_action_pressed("grab"):
		if not body:
			var collider = ray.get_collider()
			if collider is RigidBody3D:
				body = collider
				hold_point.position.z = -3
				var fsdfsd = hold_point.global_position - body.global_position
				if fsdfsd.length() > 2:
					body = null
			else:
				return
		if not body: 
			return
		var to_target = hold_point.global_position - body.global_position
		var strength = 50.0
		var max_speed = INF
		if body.get_parent() is Cat:
			max_speed = 50
			hold_point.position.z = -2
		var desired_vel = to_target * strength
		if desired_vel.length() > max_speed:
			desired_vel = desired_vel.normalized() * max_speed
		var force = (desired_vel - body.linear_velocity) * body.mass / delta
		body.apply_central_force(force)

		if body.get_parent() is Cat:
			body.get_parent().forcelookplayer = global_position + Vector3(0, 2, 0)
			var cat_basis = body.global_transform.basis
			var cat_right = cat_basis.x.normalized()
			var cat_up = cat_basis.y.normalized()
			var side_offset = body.get_parent().body_width / 4 + 0.1
			var height_offset = 0.2
			left_hand.global_position = body.global_position + (-cat_right * side_offset) + (cat_up * height_offset)
			right_hand.global_position = body.global_position + (cat_right * side_offset) + (cat_up * height_offset)
			left_hand.look_at(body.global_position, Vector3.UP)
			right_hand.look_at(body.global_position, Vector3.UP)
			body.get_parent().grabbed = true
			left_hand.visible = true
			right_hand.visible = true
			camera_hand.visible = false

	else:
		left_hand.visible = false
		right_hand.visible = false
		camera_hand.visible = false

		if body:
			if body.get_parent() is Cat:
				body.get_parent().grabbed = false
				body.get_parent().forcelookplayer = Vector3.ZERO
				for child in body.get_parent().get_children():
					if child is RigidBody3D:
						child.linear_velocity /= 4
						child.linear_velocity += velocity / 2
			body = null
