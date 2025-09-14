extends Node3D
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
@onready var eyes: MeshInstance3D = $Head/Collision/Head/Eyes
@onready var mouth: MeshInstance3D = $Head/Collision/Head/Mouth


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
var namelength     : int        = 0
var voicepitch     : float      = 0.0
var hyperactivity  : float      = 0.0
var limbspeed      : float      = 0.0
var walkspeed      : float      = 0.0
var catcolor       : Color      = Color(0,0,0)
var catcolor_alt   : Color      = Color(0,0,0)
var catcolor_alt2  : Color      = Color(0,0,0)
var facecolor      : Color      = Color(0,0,0)
var mouthcolor     : Color      = Color(0,0,0)
var head_size      : float      = 1
var leg_height     : float      = 1
var leg_thickness  : float      = .3
var catscale       : float      = 1
var body_length    : float      = 1.5
var body_width     : float      = 1
var body_height    : float      = .6
var tail_length    : float      = .6
var tail_thickness : float      = .2
var tail_1_angle   : float      = 0
var tail_2_angle   : float      = 0
var ear_width      : float      = .35
var ear_length     : float      = .18
var ear_angle      : float      = 0
var dark_ears      : bool       = false
var leg_collision      : BoxShape3D            = BoxShape3D.new()
var leg_mesh           :                       = CUBE.duplicate()
var body_collision_new : BoxShape3D            = BoxShape3D.new()
var body_mesh_new      :                       = CUBE.duplicate()
var tail_collision     : BoxShape3D            = BoxShape3D.new()
var tail_mesh          :                       = CUBE.duplicate()
var foot_mesh          :                       = CUBE.duplicate()
var body_texture
var leg_texture
var tail2_texture
var head_texture
var ear_texture
var eyes_texture
var mouth_texture
var eyes_texture_blink
var mouth_texture_meow
var material           : StandardMaterial3D    = StandardMaterial3D.new()
var catname : String = ""

func get_random_texture_file(path: String, starts: String = "", ends: String = "", exclude_contains: String = "") -> String:
	var dir_access = DirAccess.open(path)
	var files = dir_access.get_files()
	var texture_files = []
	
	for file in files:
		var starts_with = starts.is_empty() or not file.begins_with(starts)
		var ends_with = ends.is_empty() or not file.ends_with(ends)
		var contains = exclude_contains.is_empty() or not exclude_contains in file
		if starts_with and ends_with and contains:
			if file.ends_with(".import"):
				# Remove the .import extension and add the file to the list
				var base_file = file.substr(0, file.length() - 7)
				texture_files.append(base_file)
			else:
				texture_files.append(file)
	if texture_files.is_empty():
		return "res://images/cat/green.png"
	var random_index = randi_range(0, texture_files.size() - 1)
	var The_File = path.path_join(texture_files[random_index])
	
	return The_File

func makecat():
	var is_vowel_turn = randf() < 0.5
	namelength = randi_range(3, 6)
	for i in namelength:
		var last_char_was_vowel = false
		if is_vowel_turn:
			catname += VOWELS[randi_range(0, VOWELS.size() - 1)]
			if randf() < 0.2: # 20% chance to double
				continue
			last_char_was_vowel = true
		else:
			catname += CONSONANTS[randi_range(0, CONSONANTS.size() - 1)]
			if randf() < 0.2: # 20% chance to double
				continue
			last_char_was_vowel = false
		is_vowel_turn = not last_char_was_vowel

	catcolor = Color.from_hsv(randf(), randf(), randf()) 
	catcolor_alt = Color.from_hsv(catcolor.h + randf_range(-0.05, 0.05), catcolor.s + randf_range(-0.05, 0.05), clamp(catcolor.v + randf_range(0.1, 0.2), 0, 1))
	catcolor_alt2 = Color.from_hsv(catcolor.h + randf_range(-0.05, 0.05), catcolor.s + randf_range(-0.05, 0.05), clamp(catcolor.v - randf_range(0.1, 0.2), 0, 1))
	facecolor = Color.from_hsv(randf(), randf(), 0)
	if catcolor.get_luminance() < .4:
		facecolor.v = randf_range(.45, 1)
	else:
		facecolor.v -= randf_range(.05, 5)
		
	mouthcolor = Color.from_hsv(facecolor.h - .2, facecolor.s, clamp(facecolor.v - .2, 0, 1))

	name_text.modulate = catcolor_alt
	name_text.outline_modulate = Color.from_hsv(catcolor_alt2.h, catcolor_alt2.s, clamp(catcolor.v - .4, 0, 1))
	body_texture = get_random_texture_file(BODYTEX)
	leg_texture = get_random_texture_file(LEGTEX)
	tail2_texture = get_random_texture_file(LEGTEX)
	head_texture = get_random_texture_file(HEADTEX)
	eyes_texture = get_random_texture_file(FACETEX, "mouth")
	mouth_texture = get_random_texture_file(FACETEX, "eye")
	if head_texture.contains("dark"):
		ear_texture = load("res://images/cat/ears/eardark.png")
	else:
		ear_texture = load(get_random_texture_file(EARTEX, "", "", "dark"))
		
	voicepitch     = randf_range(0.75, 1.15)
	limbspeed      = randf_range(25, 30)
	walkspeed      = randf_range(0.05, 0.25)
	catscale       = randf_range(0.7, 1)
	leg_height     = randf_range(.6, 1.4)
	leg_thickness  = randf_range(.25, .35)
	body_length    = randf_range(1.2, 1.8)
	body_width     = randf_range(.7, 1)
	body_height    = randf_range(.55, .65)
	head_size      = randf_range(.95, 1.05)
	tail_length    = randf_range(.7, 1.3)
	tail_thickness = randf_range(.2, .5)
	tail_1_angle   = randf_range(45, 120)
	tail_2_angle   = randf_range(45, 75)
	ear_width      = randf_range(.7, 1)
	ear_length     = randf_range(.7, 1)
	ear_angle      = randf_range(-20, 12)
	
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
	
	if not premade: makecat()
	
	var shader_template = ShaderMaterial.new()
	shader_template.shader = SHADER
	shader_template.set_shader_parameter("original_colors", [Color(0, 1, 0), Color(1, 0, 0), Color(0, 0, 1)])
	shader_template.set_shader_parameter("replace_colors", [catcolor, catcolor_alt, catcolor_alt2])

	var legmat = shader_template.duplicate(true)
	legmat.set_shader_parameter("texture_albedo", load(leg_texture))
	left_front_mesh.material_override = legmat
	right_front_mesh.material_override = legmat
	left_back_mesh.material_override = legmat
	right_back_mesh.material_override = legmat

	var headmat = shader_template.duplicate(true)
	headmat.set_shader_parameter("texture_albedo", load(head_texture))
	head_mesh.material_override = headmat

	var earmat = shader_template.duplicate(true)
	earmat.set_shader_parameter("texture_albedo", ear_texture)
	left_ear_mesh.material_override = earmat
	right_ear_mesh.material_override = earmat

	var bodymat = shader_template.duplicate(true)
	bodymat.set_shader_parameter("texture_albedo", load(body_texture))
	body_mesh.material_override = bodymat
	
	var tail2mat = shader_template.duplicate(true)
	tail2mat.set_shader_parameter("texture_albedo", load(tail2_texture))
	tail_2_mesh.material_override = tail2mat
	
	var tail1mat = shader_template.duplicate(true)
	tail1mat.set_shader_parameter("texture_albedo", load("res://images/cat/green.png"))
	tail_1_mesh.material_override = tail1mat
	
	eyes.material_override = eyes.material_override.duplicate()
	eyes.material_override.set_shader_parameter("texture_albedo", load(eyes_texture))
	eyes.material_override.set_shader_parameter("original_colors", [Color(0, 0, 1), Color(1, 0, 0), Color(0, 1, 0)])
	eyes.material_override.set_shader_parameter("replace_colors", [facecolor, mouthcolor, Color(0, 0, 0, 0)])
	mouth.material_override = mouth.material_override.duplicate()
	mouth.material_override.set_shader_parameter("texture_albedo", load(mouth_texture))
	mouth.material_override.set_shader_parameter("original_colors", [Color(0, 0, 1), Color(1, 0, 0), Color(0, 1, 0)])
	mouth.material_override.set_shader_parameter("replace_colors", [facecolor, mouthcolor, Color(0, 0, 0, 0)])
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
#endregion


@onready var nametags: Node3D = $Nametags
func _physics_process(_delta: float) -> void:
	for child in get_children():
		if child is not RigidBody3D or child.collision_layer == 0: 
			continue
		child.apply_torque(child.transform.basis.y.cross(Vector3.UP) * 50 + (-child.angular_velocity))
		
	nametags.global_position = head.global_position + Vector3(0, 1, 0)

	
