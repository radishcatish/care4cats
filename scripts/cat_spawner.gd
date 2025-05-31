extends Node3D
const CAT = preload("res://scenes/cat.tscn")

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
var syllables     : int        = 0
var catname       : String     = ""
var voicepitch    : float      = 0.0
var hyperactivity : float      = 0.0
var limbdamping   : float      = 0.0
var limbspeed     : float      = 0.0
var walkspeed     : float      = 0.0
var catcolor      : Color      = Color(0,0,0)
var leg_scale     : Vector3    = Vector3(.3, .8, .3)
var leg_collision : BoxShape3D = BoxShape3D.new()
var leg_mesh      : BoxMesh    = BoxMesh.new()
var material      : StandardMaterial3D = StandardMaterial3D.new()
var rng  = RandomNumberGenerator.new()
var seed = randi_range(1, 9999)

const OUTLINEMATERIAL = preload("res://scenes/outlinematerial.tres")
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	var cat_scene = CAT.instantiate()
	get_parent().add_child(cat_scene)
	cat_scene.id_text.text = str(seed)
	rng.seed = seed.hash() if seed is String else seed
	
	syllables = rng.randi_range(2, 3)
	for i in syllables:
		catname += NAMESYLLABLES[rng.randi_range(0, NAMESYLLABLES.size() - 1)]
	
	rng.seed = catname.hash()
	
	
	catcolor = Color().from_hsv(rng.randf(), rng.randf(), rng.randf_range(0.5, 0.9))
	material.albedo_color = catcolor
	material.next_pass = OUTLINEMATERIAL
	
	cat_scene.voicepitch    = rng.randf_range(0.75, 1.15)
	cat_scene.hyperactivity = rng.randf_range(0.1, 2)
	cat_scene.limbdamping   = rng.randf_range(0.1, 1)
	cat_scene.limbspeed     = rng.randf_range(25, 30)
	cat_scene.walkspeed     = rng.randf_range(0.05, 0.25)
	var catscale = rng.randf_range(0.75, 1.1)
	cat_scene.scale         = Vector3(catscale,catscale,catscale)
	leg_scale.y = rng.randf_range(.7, 1.2)
	leg_collision.size = leg_scale
	leg_mesh.size = leg_scale
	
	cat_scene.name_text.text = catname
	cat_scene.head_mesh.material_override = material
	cat_scene.left_ear_mesh.material_override = material
	cat_scene.right_ear_mesh.material_override = material
	cat_scene.body_mesh.material_override = material
	cat_scene.tail_2_mesh.material_override = material
	cat_scene.tail_1_mesh.material_override = material
	cat_scene.left_front_mesh.material_override = material
	cat_scene.right_front_mesh.material_override = material
	cat_scene.left_back_mesh.material_override = material
	cat_scene.right_back_mesh.material_override = material

	cat_scene.left_front_collision.shape = leg_collision
	cat_scene.left_front_mesh.mesh = leg_mesh
	cat_scene.right_front_collision.shape = leg_collision
	cat_scene.right_front_mesh.mesh = leg_mesh
	cat_scene.left_back_collision.shape = leg_collision
	cat_scene.left_back_mesh.mesh = leg_mesh
	cat_scene.right_back_collision.shape = leg_collision
	cat_scene.right_back_mesh.mesh = leg_mesh
	
	var body_extents  = cat_scene.body_collision.shape.extents
	var corner_offsets = [
	Vector3(body_extents.x, -body_extents.y, body_extents.z),
	Vector3(-body_extents.x, -body_extents.y, body_extents.z),
	Vector3(body_extents.x, -body_extents.y, -body_extents.z),
	Vector3(-body_extents.x, -body_extents.y, -body_extents.z)
	]
	cat_scene.left_front.position = corner_offsets[0]
	cat_scene.right_front.position = corner_offsets[1]
	cat_scene.left_back.position = corner_offsets[2]
	cat_scene.right_back.position = corner_offsets[3]
	

	cat_scene.left_front.position.y = -body_extents.y * leg_scale.y
	cat_scene.right_front.position.y = -body_extents.y  * leg_scale.y
	cat_scene.left_back.position.y = -body_extents.y  * leg_scale.y
	cat_scene.right_back.position.y = -body_extents.y  * leg_scale.y
	cat_scene.global_position = global_position
	
	cat_scene.left_front_joint.node_a = cat_scene.left_front.get_path()
	cat_scene.left_front_joint.node_b = cat_scene.body.get_path()
	cat_scene.right_front_joint.node_a = cat_scene.right_front.get_path()
	cat_scene.right_front_joint.node_b = cat_scene.body.get_path()
	cat_scene.left_back_joint.node_a = cat_scene.left_back.get_path()
	cat_scene.left_back_joint.node_b = cat_scene.body.get_path()
	cat_scene.right_back_joint.node_a = cat_scene.right_back.get_path()
	cat_scene.right_back_joint.node_b = cat_scene.body.get_path()
	queue_free()
