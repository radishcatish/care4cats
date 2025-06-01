extends Node3D
#region nodes
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

@onready var left_front_foot: MeshInstance3D = $LeftFront/Collision/Foot
@onready var right_front_foot: MeshInstance3D = $RightFront/Collision/Foot
@onready var left_back_foot: MeshInstance3D = $LeftBack/Collision/Foot
@onready var right_back_foot: MeshInstance3D = $RightBack/Collision/Foot

@onready var meow_cooldown: Timer = $MeowCooldown
@onready var decision_cooldown: Timer = $DecisionCooldown
@onready var meows: Node3D = $Head/Meows
@onready var face: AnimatedSprite3D = $Head/Collision/Sprite3D
@onready var name_text: Label3D = $Head/Collision/Label3D
@onready var id_text: Label3D = $Head/Collision/Label3D2

const CATEARMESH = preload("res://scenes/catearmesh.tres")
var ear_mesh = CATEARMESH.duplicate()
#endregion

const NAMESYLLABLES =  ["ba", "be", "bi", "bo", "bu", "bun", "cah", 
					"car", "cas", "cu", "cur", "dig", "dix", "dol",
					"dor", "da", "dox", "dul", "dur", "dus", "ef", "ex", 
					"fe", "fi", "fo", "fu", "fuz", "ga", "ge", "gi", 
					"go", "gus", "he", "hi", "hin", "ho", "hus", "ja", 
					"ji", "jo", "ju", "ka", "kel", "ki", "ko", "ku", 
					"kun", "la", "le", "li", "lo", "lu", "ma", "me",
					"mo", "mu", "na", "ne", "new", "ni", "nif", "no", 
					"not", "nu", "nuk", "num", "nie", "om", "os", "pa", "pe", "pi", 
					"po", "pu", "ra", "rak", "re", "rek", "ri", "rip", 
					"ris", "rit", "ro", "ros", "rot", "ru", "rut", "sa", 
					"se", "si", "so", "su", "sut", "ta", "te", "tex", "ti", 
					"tis", "to", "ton", "tu", "tus", "um", "up", "va", "ve", 
					"vi", "vid", "vo", "vu", "wa", "wawa", "wed", "wo", "won", "wun", "win",
					"wu", "wus", "xa", "xi", "xit", "ya", "ye", "yi", "yo", 
					"yu", "za", "ze", "zi", "zo", "zu", "zun", 
					"a", "e", "i", "o", "u"]
var syllables      : int        = 0
var voicepitch     : float      = 0.0
var hyperactivity  : float      = 0.0
var limbdamping    : float      = 0.0
var limbspeed      : float      = 0.0
var walkspeed      : float      = 0.0
var catcolor       : Color      = Color(0,0,0)
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
var leg_collision      : BoxShape3D            = BoxShape3D.new()
var leg_mesh           : BoxMesh               = BoxMesh.new()
var body_collision_new : BoxShape3D            = BoxShape3D.new()
var body_mesh_new      : BoxMesh               = BoxMesh.new()
var tail_collision     : BoxShape3D            = BoxShape3D.new()
var tail_mesh          : BoxMesh               = BoxMesh.new()
var foot_mesh          : BoxMesh               = BoxMesh.new()
var material           : StandardMaterial3D    = StandardMaterial3D.new()
var rng                : RandomNumberGenerator = RandomNumberGenerator.new()
var rngseed : int = randi_range(1, 9999)
@export var catname : String = ""

var make_decision : bool = true
@onready var thingtolookat_head
@onready var thingtolookat_body
@onready var nodestolookat: Array
@onready var nodestochase: Array

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
	left_front_foot.mesh = foot_mesh
	right_front_foot.mesh = foot_mesh
	left_back_foot.mesh = foot_mesh
	right_back_foot.mesh = foot_mesh
	right_ear_mesh.mesh = ear_mesh
	left_ear_mesh.mesh  = ear_mesh
	
	id_text.text = str(rngseed)
	rng.seed = rngseed
	
	syllables = rng.randi_range(2, 3)
	if catname == "":
		for i in syllables:
			catname += NAMESYLLABLES[rng.randi_range(0, NAMESYLLABLES.size() - 1)]
	else: 
		id_text.text = "custom"
		name_text.modulate = Color(1, 1, 0)
		id_text.modulate = Color(.5, .5, 0)
		
	rng.seed = catname.hash()
	catcolor = Color().from_hsv(rng.randf(), rng.randf(), rng.randf_range(0.5, 0.9))
	material.albedo_color = catcolor
	material.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
	voicepitch     = rng.randf_range(0.75, 1.15)
	hyperactivity  = rng.randf_range(0.1, 2)
	limbdamping    = rng.randf_range(0.1, 1)
	limbspeed      = rng.randf_range(25, 30)
	walkspeed      = rng.randf_range(0.05, 0.25)
	var catscale   = rng.randf_range(0.75, 1.1)
	scale          = Vector3(catscale,catscale,catscale)
	leg_height     = rng.randf_range(.6, 1.4)
	leg_thickness  = rng.randf_range(.25, .35)
	body_length    = rng.randf_range(1.2, 1.8)
	body_width     = rng.randf_range(.7, 1.3)
	body_height    = rng.randf_range(.55, .65)
	head_size      = rng.randf_range(.95, 1.05)
	tail_length    = rng.randf_range(.7, 1.3)
	tail_thickness = rng.randf_range(.2, .5)
	tail_1_angle   = rng.randf_range(45, 120)
	tail_2_angle   = rng.randf_range(45, 75)
	ear_width      = rng.randf_range(.33, .4)
	ear_length     = rng.randf_range(.15, .25)
	ear_angle      = rng.randf_range(-20, 12)
	
	foot_mesh.size = Vector3(leg_thickness, leg_height / 5, .2)
	ear_mesh.radius = ear_width
	ear_mesh.section_length = ear_length
	left_ear.rotation_degrees.z = ear_angle
	right_ear.rotation_degrees.z = -ear_angle
	tail_collision.size = Vector3(tail_thickness, tail_length, tail_thickness)
	tail_mesh.size = Vector3(tail_thickness, tail_length, tail_thickness)
	
	body_collision.shape.size = Vector3(body_width, body_height, body_length)
	body_mesh.mesh.size = Vector3(body_width, body_height, body_length)
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
	left_ear.position = head.position + Vector3(-.15, .15, 0)
	right_ear.position = head.position + Vector3(.15, .15, 0)
	$Tail1/Tail2.position.y = tail_length
	$Tail1/Tail2/CollisionShape3D.position.y += tail_length / 2
	$Tail1/Tail2.reparent($".")
	
#region lots of leg stuff
	leg_collision.size = Vector3(leg_thickness, leg_height, leg_thickness)
	leg_mesh.size = Vector3(leg_thickness, leg_height, leg_thickness)
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
	
	left_front_foot.position = Vector3(0,
	-leg_extents.y + foot_mesh.size.y / 2,
	 leg_extents.z
	)

	right_front_foot.position = Vector3(0,
	-leg_extents.y + foot_mesh.size.y / 2,
	 leg_extents.z
	)

	left_back_foot.position = Vector3(0,
	-leg_extents.y + foot_mesh.size.y / 2,
	 leg_extents.z
	)

	right_back_foot.position = Vector3(0,
	-leg_extents.y + foot_mesh.size.y / 2,
	 leg_extents.z
	)
	
	left_front_joint.node_a = left_front.get_path()
	left_front_joint.node_b = body.get_path()
	right_front_joint.node_a = right_front.get_path()
	right_front_joint.node_b = body.get_path()
	left_back_joint.node_a = left_back.get_path()
	left_back_joint.node_b = body.get_path()
	right_back_joint.node_a = right_back.get_path()
	right_back_joint.node_b = body.get_path()
#endregion

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
	head_mesh.material_override = material
	left_ear_mesh.material_override = material
	right_ear_mesh.material_override = material
	body_mesh.material_override = material
	left_front_mesh.material_override = material
	right_front_mesh.material_override = material
	left_back_mesh.material_override = material
	right_back_mesh.material_override = material
	tail_2_mesh.material_override = material
	tail_1_mesh.material_override = material
	left_front_foot.material_override = material
	right_front_foot.material_override = material
	left_back_foot.material_override = material
	right_back_foot.material_override = material


	
func _process(_delta: float) -> void:
	if decision_cooldown.is_stopped():
		make_decision = randi() % 10 == 1 
	if make_decision:
		make_decision = false
		thingtolookat_head = null
		head.islooking = false
		thingtolookat_body = null

		
		match randi_range(0, 8):
			0, 1: # walk
				decision_cooldown.start(randf_range(2 / hyperactivity, 10 / hyperactivity))
				body.iswalking = true
				if body.iswalking:
					body.sitting = false
					body.laying = false
			2, 3: # sit
				var sitanim = randi_range(1, 2)
				body.iswalking = false
				body.sitting = true if sitanim == 1 else false
				body.laying = true if sitanim == 2 else false
				
				if body.sitting:
					right_back.apply_torque(body.forward_direction * -35)
					left_back.apply_torque(body.forward_direction * -35)
					decision_cooldown.start(randf_range(10 / hyperactivity, 20 / hyperactivity))
				else:
					decision_cooldown.start(randf_range(30 / hyperactivity, 120 / hyperactivity))
				


			4: # looking
				decision_cooldown.start(randf_range(2, 10))
				if get_tree().get_nodes_in_group("canbelookedat"):
					nodestolookat = get_tree().get_nodes_in_group("canbelookedat")
					make_decision = nodestolookat.is_empty()
					body.sitting = body.laying == false
					for node in nodestolookat:
						if node.get_parent() == self:
							continue
						if (node.global_position - head.global_position).length() < 10:
							thingtolookat_head = nodestolookat[randi_range(0, nodestolookat.size() - 1)] 
							head.islooking = true

			5: # chasing 
				decision_cooldown.start(randf_range(10 / hyperactivity, 60 / hyperactivity))
				if get_tree().get_nodes_in_group("canbechased"):
					body.sitting = false
					body.laying = false
					nodestochase = get_tree().get_nodes_in_group("canbechased")
					make_decision = nodestochase.is_empty()
					for node in nodestochase:
						if node.get_parent() == self:
							continue
						if (node.global_position - head.global_position).length() < 10:
							thingtolookat_head = nodestochase[randi_range(0, nodestochase.size() - 1)] 
							head.islooking = true
							thingtolookat_body = thingtolookat_head
							body.islooking = true
							body.iswalking = true
			6, 7: # jump
				body.apply_force(Vector3(0, randi_range(700, 2000), 0))
				decision_cooldown.start(randf_range(.5 * hyperactivity, 3 * hyperactivity))


	if meow_cooldown.is_stopped():
		if randf_range(0, 500 / hyperactivity) == 0:
			var soundtoplay = randi_range(0,meows.get_child_count() - 1)
			meows.get_child(soundtoplay).pitch_scale = voicepitch
			meows.get_child(soundtoplay).play()
			meow_cooldown.start(randf_range(0, .8))
			face.play("default")
			face.frame = 0
			head.apply_force(Vector3(0, 100, 0))
