extends Node3D
class_name Cat
#region setup stuff
@onready var head: RigidBody3D = $Head
@onready var head_mesh: MeshInstance3D = $Head/Collision/Head
@onready var right_ear: RigidBody3D = $RightEar
@onready var right_ear_collision: CollisionShape3D = $RightEar/CollisionShape3D
@onready var right_ear_mesh: MeshInstance3D = $RightEar/CollisionShape3D/RightEar
@onready var left_ear: RigidBody3D = $LeftEar
@onready var left_ear_collision: CollisionShape3D = $LeftEar/CollisionShape3D
@onready var left_ear_mesh: MeshInstance3D = $LeftEar/CollisionShape3D/LeftEar
@onready var right_ear_joint: Generic6DOFJoint3D = $RightEar/RightEarJoint
@onready var left_ear_joint: Generic6DOFJoint3D = $LeftEar/LeftEarJoint
@onready var mouth: MeshInstance3D = $Head/Collision/Head/Mouth
@onready var eye_left: MeshInstance3D = $Head/Collision/Head/EyeLeft
@onready var eye_right: MeshInstance3D = $Head/Collision/Head/EyeRight


@onready var body: RigidBody3D = $Body
@onready var body_joint: ConeTwistJoint3D = $Head/BodyHeadJoint
@onready var body_collision: CollisionShape3D = $Body/Collision
@onready var body_mesh: MeshInstance3D = $Body/Collision/MeshInstance3D

@onready var tail_1: RigidBody3D = $Tail1
@onready var tail_1_joint: Generic6DOFJoint3D = $Tail1/Generic6DOFJoint3D
@onready var tail_1_collision: CollisionShape3D = $Tail1/CollisionShape3D
@onready var tail_1_mesh: MeshInstance3D = $Tail1/CollisionShape3D/MeshInstance3D
@onready var tail_2: RigidBody3D = $Tail1/Tail2
@onready var tail_2_joint: Generic6DOFJoint3D = $Tail1/Tail2/Generic6DOFJoint3D
@onready var tail_2_collision: CollisionShape3D = $Tail1/Tail2/CollisionShape3D
@onready var tail_2_mesh: MeshInstance3D = $Tail1/Tail2/CollisionShape3D/MeshInstance3D

@onready var left_front: RigidBody3D = $LeftFront
@onready var left_front_joint: ConeTwistJoint3D = $LeftFront/PinJoint3D
@onready var left_front_collision: CollisionShape3D = $LeftFront/Collision
@onready var left_front_mesh: MeshInstance3D = $LeftFront/Collision/MeshInstance3D

@onready var right_front: RigidBody3D = $RightFront
@onready var right_front_joint: ConeTwistJoint3D = $RightFront/PinJoint3D
@onready var right_front_collision: CollisionShape3D = $RightFront/Collision
@onready var right_front_mesh: MeshInstance3D = $RightFront/Collision/MeshInstance3D

@onready var left_back: RigidBody3D = $LeftBack
@onready var left_back_joint: ConeTwistJoint3D = $LeftBack/PinJoint3D
@onready var left_back_collision: CollisionShape3D = $LeftBack/Collision
@onready var left_back_mesh: MeshInstance3D = $LeftBack/Collision/MeshInstance3D

@onready var right_back: RigidBody3D = $RightBack
@onready var right_back_joint: ConeTwistJoint3D = $RightBack/PinJoint3D
@onready var right_back_collision: CollisionShape3D = $RightBack/Collision
@onready var right_back_mesh: MeshInstance3D = $RightBack/Collision/MeshInstance3D
@onready var name_text: Label3D = $Nametags/Name

const SHADER = preload("res://shaders/cat.gdshader")
const FACESHADER = preload("res://shaders/catface.gdshader")
const CATEARMESH = preload("res://models/ear.obj")
const CUBE = preload("res://models/cube.obj")
var ear_mesh = CATEARMESH.duplicate()

const BODYTEX = "res://images/cat/body/"
const LEGTEX = "res://images/cat/legs/"
const HEADTEX = "res://images/cat/head/"
const EARTEX = "res://images/cat/ears/"
const FACETEX = "res://images/cat/faces/"
const CONSONANTS = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "r", "s", "t", "w"]
const VOWELS = ["a", "e", "i", "o", "u"]
var namelength       : int        = 0
var voicepitch       : float      = 0.0
var catcolor         : Color      = Color(0,0,0)
var catcolor_alt     : Color      = Color(0,0,0)
var catcolor_alt2    : Color      = Color(0,0,0)
var facecolor        : Color      = Color(0,0,0)
var mouthcolor       : Color      = Color(0,0,0)
var head_size        : float      = 1
var leg_height       : float      = 1
var leg_thickness    : float      = .3
var catscale         : float      = 1
var body_length      : float      = 1.5
var body_width       : float      = 1
var body_height      : float      = .6
var tail_length      : float      = .6
var tail_thickness   : float      = .2
var tail_1_angle     : float      = 0
var tail_2_angle     : float      = 0
var ear_width        : float      = .35
var ear_length       : float      = .18
var ear_angle        : float      = 0
var left_eye_offset  : Vector2    = Vector2(0.2, .1)
var right_eye_offset : Vector2    = Vector2(-0.2, .1)
var mouth_offset     : float      = 0
var body_texture     : int        = 0
var leg_texture      : int        = 0
var tail2_texture    : int        = 0
var head_texture     : int        = 0
var ear_texture      : int        = 0
var eyes_texture     : int        = 1
var mouth_texture    : int        = 1
var head_dark        : bool       = false
var leg_collision      : BoxShape3D            = BoxShape3D.new()
var leg_mesh           :                       = CUBE.duplicate()
var body_collision_new : BoxShape3D            = BoxShape3D.new()
var body_mesh_new      :                       = CUBE.duplicate()
var tail_collision     : BoxShape3D            = BoxShape3D.new()
var tail_mesh          :                       = CUBE.duplicate()
var foot_mesh          :                       = CUBE.duplicate()
var material           : StandardMaterial3D    = StandardMaterial3D.new()
var catname : String = ""

func makecat():
	
	var is_vowel_turn = randf() < 0.5
	namelength = randi_range(3, 6)
	for i in namelength:
		var last_char_was_vowel = false
		if is_vowel_turn:
			catname += VOWELS[randi_range(0, VOWELS.size() - 1)]
			if randf() < 0.2:
				continue
			last_char_was_vowel = true
		else:
			catname += CONSONANTS[randi_range(0, CONSONANTS.size() - 1)]
			if randf() < 0.2:
				continue
			last_char_was_vowel = false
		is_vowel_turn = not last_char_was_vowel

	catcolor = Color.from_hsv(randf(), randf(), randf()) 
	catcolor_alt = Color.from_hsv(catcolor.h + randf_range(-0.05, 0.05), catcolor.s + randf_range(-0.05, 0.05), clamp(catcolor.v + randf_range(0.1, 0.2), 0, 1))
	catcolor_alt2 = Color.from_hsv(catcolor.h + randf_range(-0.05, 0.05), catcolor.s + randf_range(-0.05, 0.05), clamp(catcolor.v - randf_range(0.1, 0.2), 0, 1))
	if catcolor.get_luminance() < .4:
		facecolor = Color.from_hsv(randf(), randf(), randf_range(.45, 1))
	else:
		facecolor = Color.from_hsv(randf(), randf(), randf_range(.05, .5))
	mouthcolor = Color.from_hsv(facecolor.h - .2, facecolor.s, clamp(facecolor.v - .2, 0, 1))

	name_text.modulate = catcolor_alt
	name_text.outline_modulate = Color.from_hsv(catcolor_alt2.h, catcolor_alt2.s, clamp(catcolor.v - .4, 0, 1))
	voicepitch       = randf_range(0.75, 1.15)
	catscale         = randf_range(0.7, 1)
	leg_height       = randf_range(.6, 1.4)
	leg_thickness    = randf_range(.25, .35)
	body_length      = randf_range(1.2, 1.8)
	body_width       = randf_range(.7, 1)
	body_height      = randf_range(.55, .65)
	head_size        = randf_range(.95, 1.05)
	tail_length      = randf_range(.7, 1.3)
	tail_thickness   = randf_range(.2, .5)
	tail_1_angle     = randf_range(45, 120)
	tail_2_angle     = randf_range(45, 75)
	ear_width        = randf_range(.7, 1)
	ear_length       = randf_range(.7, 1)
	ear_angle        = randf_range(-20, 12)
	left_eye_offset  = Vector2(randf_range(0.15, 0.25), randf_range(-.1, .1))
	right_eye_offset = Vector2(randf_range(-0.15, -0.25), randf_range(-.1, .1))
	mouth_offset     = randf_range(-.3, -.2)
	body_texture     = randi_range(0, 5)
	leg_texture      = randi_range(0, 3)
	tail2_texture    = randi_range(0, 3)
	head_texture     = randi_range(0, 5)
	ear_texture      = randi_range(0, 1)
	eyes_texture     = randi_range(1, 3)
	mouth_texture    = randi_range(1, 2)
	head_dark        = randi_range(0, 1)

func catdata():
	var save_dict = {
		"catname"        : catname,
		"voicepitch"     : voicepitch,
		"catcolor_r"     : catcolor.r,
		"catcolor_g"     : catcolor.g,
		"catcolor_b"     : catcolor.b,
		"catcolor_alt_r" : catcolor_alt.r,
		"catcolor_alt_g" : catcolor_alt.g,
		"catcolor_alt_b" : catcolor_alt.b,
		"catcolor_alt2_r": catcolor_alt2.r,
		"catcolor_alt2_g": catcolor_alt2.g,
		"catcolor_alt2_b": catcolor_alt2.b,
		"facecolor_r"    : facecolor.r,
		"facecolor_g"    : facecolor.g,
		"facecolor_b"    : facecolor.b,
		"mouthcolor_r"   : mouthcolor.r,
		"mouthcolor_g"   : mouthcolor.g,
		"mouthcolor_b"   : mouthcolor.b,
		"head_size"      : head_size,
		"leg_height"     : leg_height,
		"leg_thickness"  : leg_thickness,
		"catscale"       : catscale,
		"body_length"    : body_length,
		"body_width"     : body_width,
		"body_height"    : body_height,
		"tail_length"    : tail_length,
		"tail_thickness" : tail_thickness,
		"tail_1_angle"   : tail_1_angle,
		"tail_2_angle"   : tail_2_angle,
		"ear_width"      : ear_width,
		"ear_length"     : ear_length,
		"ear_angle"      : ear_angle,
		"left_eye_offset_x" : left_eye_offset.x,
		"left_eye_offset_y" : left_eye_offset.y,
		"right_eye_offset_x": right_eye_offset.x,
		"right_eye_offset_y": right_eye_offset.y,
		"mouth_offset"      : mouth_offset,
		"body_texture"      : body_texture,
		"leg_texture"       : leg_texture,
		"tail2_texture"     : tail2_texture,
		"head_texture"      : head_texture,
		"ear_texture"       : ear_texture,
		"eyes_texture"      : eyes_texture,
		"mouth_texture"     : mouth_texture,
		"head_dark"         : head_dark
	}
	return save_dict


func save():
	var save_file = FileAccess.open("user://" + catname + ".bloccat", FileAccess.WRITE)
	var json_string = JSON.stringify(catdata())
	save_file.store_line(json_string)

	
var premade: bool = false
func _ready() -> void:
	left_front_collision.shape = leg_collision
	left_front_mesh.mesh = leg_mesh
	right_front_collision.shape = leg_collision
	right_front_mesh.mesh = leg_mesh
	left_back_collision.shape = leg_collision
	left_back_mesh.mesh = leg_mesh
	right_back_collision.shape = leg_collision
	right_back_mesh.mesh = leg_mesh
	body_collision.shape = body_collision_new
	body_mesh.mesh = body_mesh_new
	tail_1_collision.shape = tail_collision
	tail_1_mesh.mesh = tail_mesh
	tail_2_collision.shape = tail_collision
	tail_2_mesh.mesh = tail_mesh
	right_ear_mesh.mesh = ear_mesh
	left_ear_mesh.mesh  = ear_mesh
	
	if not premade: 
		makecat()
		#save()
	
	
	name_text.modulate = catcolor_alt
	name_text.outline_modulate = Color.from_hsv(catcolor_alt2.h, catcolor_alt2.s, clamp(catcolor.v - .4, 0, 1))

	
	var shader_template = ShaderMaterial.new()
	shader_template.shader = SHADER
	shader_template.set_shader_parameter("original_colors", [Color(0, 1, 0), Color(1, 0, 0), Color(0, 0, 1)])
	shader_template.set_shader_parameter("replace_colors", [catcolor, catcolor_alt, catcolor_alt2])

	var legmat = shader_template.duplicate(true)
	legmat.set_shader_parameter("texture_albedo", load(LEGTEX + str(leg_texture) + ".png"))
	left_front_mesh.material_override = legmat
	right_front_mesh.material_override = legmat
	left_back_mesh.material_override = legmat
	right_back_mesh.material_override = legmat
	
	var tempvarhead = HEADTEX + str(head_texture)
	tempvarhead += "_d.png" if head_dark else ".png"

	var headmat = shader_template.duplicate(true)
	headmat.set_shader_parameter("texture_albedo", load(tempvarhead))
	head_mesh.material_override = headmat
	
	var tempvarear = EARTEX + str(ear_texture)
	tempvarear += "_d.png" if head_dark else ".png"
	var earmat = shader_template.duplicate(true)
	earmat.set_shader_parameter("texture_albedo", load(tempvarear))
	left_ear_mesh.material_override = earmat
	right_ear_mesh.material_override = earmat

	var bodymat = shader_template.duplicate(true)
	bodymat.set_shader_parameter("texture_albedo", load(BODYTEX + str(body_texture) + ".png"))
	body_mesh.material_override = bodymat
	
	var tail2mat = shader_template.duplicate(true)
	tail2mat.set_shader_parameter("texture_albedo", load(LEGTEX + str(tail2_texture) + ".png"))
	tail_2_mesh.material_override = tail2mat
	
	var tail1mat = shader_template.duplicate(true)
	tail1mat.set_shader_parameter("texture_albedo", load("res://images/cat/green.png"))
	tail_1_mesh.material_override = tail1mat
	
	var tempvareye = FACETEX + "eyetype" + str(eyes_texture) + ".png"
	var tempvarmouth = FACETEX + "mouthtype" + str(mouth_texture) + ".png"
	eye_left.material_override = eye_left.material_override.duplicate()
	eye_left.material_override.set_shader_parameter("texture_albedo", load(tempvareye))
	eye_left.material_override.set_shader_parameter("original_colors", [Color(0, 0, 1), Color(1, 0, 0), Color(0, 1, 0)])
	eye_left.material_override.set_shader_parameter("replace_colors", [facecolor, mouthcolor, Color(0, 0, 0, 0)])
	eye_right.material_override = eye_left.material_override.duplicate()
	eye_left.material_override.set_shader_parameter("texture_offset", left_eye_offset)
	eye_right.material_override.set_shader_parameter("texture_offset", right_eye_offset)
	mouth.material_override = mouth.material_override.duplicate()
	mouth.material_override.set_shader_parameter("texture_albedo", load(tempvarmouth))
	mouth.material_override.set_shader_parameter("original_colors", [Color(0, 0, 1), Color(1, 0, 0), Color(0, 1, 0)])
	mouth.material_override.set_shader_parameter("replace_colors", [facecolor, mouthcolor, Color(0, 0, 0, 0)])
	mouth.material_override.set_shader_parameter("texture_offset", Vector2(0, mouth_offset))
	scale = Vector3(catscale,catscale,catscale)
	left_ear.scale.x = ear_width
	left_ear.scale.z = ear_width
	left_ear.scale.y = ear_length
	left_ear.rotation_degrees.z = ear_angle
	right_ear.scale.x = ear_width
	right_ear.scale.z = ear_width
	right_ear.scale.y = ear_length
	right_ear.rotation_degrees.z = -ear_angle
	tail_collision.size = Vector3(tail_thickness, tail_length, tail_thickness)
	tail_1_mesh.scale = Vector3(tail_thickness, tail_length, tail_thickness)
	tail_2_mesh.scale = Vector3(tail_thickness, tail_length, tail_thickness)
	body_collision.shape.size = Vector3(body_width, body_height, body_length)
	body_mesh.scale = Vector3(body_width, body_height, body_length)

	var body_extents = body_collision.shape.extents
	
	head.scale = Vector3(head_size,head_size,head_size)
	head.position = Vector3(0,
	body_extents.y + head_size / 2 - .1,
	body_extents.z
	)
	
	tail_1.position = Vector3(0,
	body_extents.y - .1,
	-body_extents.z + .2
	)
	
	tail_1.rotation_degrees.x = -tail_1_angle
	tail_2.rotation_degrees.x = tail_2_angle
	tail_1_collision.position.y += tail_length / 2
	left_ear.position = head.position + Vector3(-.15, 0, 0)
	right_ear.position = head.position + Vector3(.15, 0, 0)
	$Tail1/Tail2.position.y = tail_length
	$Tail1/Tail2/CollisionShape3D.position.y += tail_length / 2
	$Tail1/Tail2.reparent($".")

	leg_collision.size = Vector3(leg_thickness, leg_height, leg_thickness)
	left_front_mesh.scale = Vector3(leg_thickness, leg_height, leg_thickness)
	right_front_mesh.scale = Vector3(leg_thickness, leg_height, leg_thickness)
	left_back_mesh.scale = Vector3(leg_thickness, leg_height, leg_thickness)
	right_back_mesh.scale = Vector3(leg_thickness, leg_height, leg_thickness)
	var leg_extents = left_front_collision.shape.extents
	left_front_collision.position.y -= (leg_height - 0.8) / 2.0
	right_front_collision.position.y -= (leg_height - 0.8) / 2.0
	left_back_collision.position.y -= (leg_height - 0.8) / 2.0
	right_back_collision.position.y -= (leg_height - 0.8) / 2.0
	
	left_front.position = Vector3(
	-body_extents.x + leg_extents.x,
	-body_extents.y,
	body_extents.z - leg_extents.z
	)

	right_front.position = Vector3(
	body_extents.x - leg_extents.x,
	-body_extents.y,
	body_extents.z - leg_extents.z
	)

	left_back.position = Vector3(
	-body_extents.x + leg_extents.x,
	-body_extents.y,
	-body_extents.z + leg_extents.z
	)

	right_back.position = Vector3(
	body_extents.x - leg_extents.x,
	-body_extents.y,
	-body_extents.z + leg_extents.z
	)
	
	left_front_joint.node_a = left_front.get_path()
	left_front_joint.node_b = body.get_path()
	right_front_joint.node_a = right_front.get_path()
	right_front_joint.node_b = body.get_path()
	left_back_joint.node_a = left_back.get_path()
	left_back_joint.node_b = body.get_path()
	right_back_joint.node_a = right_back.get_path()
	right_back_joint.node_b = body.get_path()
	body_joint.node_a = head.get_path()
	body_joint.node_b = body.get_path()
	tail_1_joint.node_a = tail_1.get_path()
	tail_1_joint.node_b = body.get_path()
	tail_2_joint.node_a = tail_2.get_path()
	tail_2_joint.node_b = tail_1.get_path()
	left_ear_joint.node_a = head.get_path()
	left_ear_joint.node_b = left_ear.get_path()
	right_ear_joint.node_a = head.get_path()
	right_ear_joint.node_b = right_ear.get_path()
	name_text.text = catname
	ready2()
#endregion

#region variables
@onready var player := get_tree().get_first_node_in_group("player")
@onready var agent: NavigationAgent3D = $Body/NavigationAgent3D
@onready var nametags: Node3D = $Nametags
var iswalking := false
var loose := false
var sitting := false
var laying := false
var walktimer := 0.0
var wandering := false
var grabbed := false
var lookingat_head := Vector3(0, 0, 0)
var forcelookplayer := Vector3(0, 0, 0)
var headlookspeed := 30.0
var lookingat_body := Vector3(0, 0, 0)
var bodylookspeed := 30.0
var walkspeed := 1
var destination = Vector3.ZERO
var decision_timer := 0.0
var wait_timer := 0.0
var wander_count := 1
#endregion

func ready2():
	randomize()
	agent.debug_path_custom_color = catcolor
func get_random_valid_spot(radius: float = 10.0) -> Vector3:
	var nav_map = agent.get_navigation_map()
	var origin = body.global_position

	for i in range(10):
		var random_offset = Vector3(
			randf_range(-radius, radius),
			0,
			randf_range(-radius, radius)
		)
		var candidate = origin + random_offset
		var valid_pos = NavigationServer3D.map_get_closest_point(nav_map, candidate)
		
		if valid_pos.distance_to(candidate) < 1.0:
			return valid_pos

	return origin


func _process(_delta: float) -> void:
	nametags.global_position = head.global_position + Vector3(0, 1, 0)

func _physics_process(delta: float) -> void:
	#region things for variables
	var forward = body.transform.basis.z.normalized()
	
	if lookingat_head != Vector3.ZERO or forcelookplayer != Vector3.ZERO:
		var pos = lookingat_head if not forcelookplayer != Vector3.ZERO else forcelookplayer
		head.apply_torque(head.transform.basis.y.cross(Vector3.UP) * 30 + (-head.angular_velocity))
		var direction_to_target = (pos - head.global_transform.origin).normalized()
		var desired_forward = -direction_to_target
		var current_forward = -head.global_transform.basis.z
		var rotation_axis = current_forward.cross(desired_forward).normalized()
		var angle = acos(current_forward.dot(desired_forward))
		if angle > 0.001:
			var torque = rotation_axis * angle * headlookspeed + -head.angular_velocity
			head.apply_torque_impulse(torque * get_physics_process_delta_time())
	else:
		head.apply_torque(head.transform.basis.y.cross(Vector3.UP) * 50 + (-head.angular_velocity))
	
	if lookingat_body != Vector3.ZERO or forcelookplayer != Vector3.ZERO:
		var pos = lookingat_body if not forcelookplayer != Vector3.ZERO else forcelookplayer
		var direction_to_target = (pos - body.global_transform.origin).normalized()
		var desired_forward = -direction_to_target
		var current_forward = -body.global_transform.basis.z
		var rotation_axis = current_forward.cross(desired_forward).normalized()
		var angle = acos(current_forward.dot(desired_forward))
		if angle > 0.001:
			var torque = rotation_axis * angle * bodylookspeed
			body.apply_torque_impulse(torque * get_physics_process_delta_time())
		
	if destination != Vector3.ZERO:
		agent.target_position = destination
		lookingat_body = agent.get_next_path_position()
	else:
		agent.target_position = Vector3.ZERO
		lookingat_body = Vector3.ZERO

	if not grabbed:
		if iswalking:
			walktimer += delta * (4.5 * walkspeed)
			var forward_legs = body.transform.basis.x.normalized()
			var side_legs = body.transform.basis.z.normalized()
			var forward_body = body.transform.basis.z.normalized()
			body.apply_central_force(forward_body * (10.0 + (leg_height + .4) * 10) * walkspeed)
			body.apply_central_force(Vector3.UP * 40.0)
			body.apply_torque(-forward * 10)
			body.apply_torque(body.transform.basis.y.cross(Vector3.UP) * 300 + (-body.angular_velocity))
			var circle_forward = cos(walktimer)
			var circle_side = sin(walktimer)
			var torque_vec = (forward_legs * circle_forward + side_legs * circle_side) * 50.0
			var opposite_torque = (forward_legs * -circle_forward + side_legs * -circle_side) * 50.0
			left_front.apply_torque(torque_vec)
			right_back.apply_torque(torque_vec)
			right_front.apply_torque(opposite_torque)
			left_back.apply_torque(opposite_torque)
		else:
			left_front.apply_torque(left_front.transform.basis.y.cross(Vector3.UP) * 30 + (-left_front.angular_velocity))
			left_back.apply_torque(left_back.transform.basis.y.cross(Vector3.UP) * 30 + (-left_back.angular_velocity))
			right_front.apply_torque(right_front.transform.basis.y.cross(Vector3.UP) * 30 + (-right_front.angular_velocity))
			right_back.apply_torque(right_back.transform.basis.y.cross(Vector3.UP) * 30 + (-right_back.angular_velocity))

	body.apply_torque(body.transform.basis.y.cross(Vector3.UP) * 60 + (-body.angular_velocity))
	#endregion
	decision_timer += delta
	if decision_timer >= wait_timer:
		decision_timer = randi_range(-2, 1)
		var decision = randi_range(1, 2)
		if decision == 1:
			wait_timer = randi_range(20, 40)
			iswalking = true
			wander_count = randi_range(1, 5)
			for i in wander_count:
				destination = get_random_valid_spot(randf_range(10, 30))
				await agent.target_reached
			wait_timer = randi_range(3,7)
			destination = Vector3.ZERO
			iswalking = false
			
			
				
			
