extends Node3D
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
#region cat body stats
# misc
var material : StandardMaterial3D = StandardMaterial3D.new()
var color = Color().from_hsv(rng.randf(), rng.randf(), rng.randf_range(0.5, 0.9))
# head
var overall_size : float = 1
var head_size : float = 1
# ears
var ear_count : int = 2
var ear_height : float = 1
var ear_thickness : float = 1
var ear_rotation : float = 0
var ear_position : float = 0
# legs
var leg_height : float = 1
var leg_thickness : float = 1
# body
var body_length : float = 2.5
var body_width : float = 1.5
var body_height : float = .8
#endregion

#region define objects
# joints
@onready var head_body_joint = Generic6DOFJoint3D.new()
# head
@onready var head = RigidBody3D.new()
@onready var head_collision = CollisionShape3D.new()
@onready var head_collision_shape = SphereShape3D.new()
@onready var head_mesh_instance = MeshInstance3D.new()
@onready var head_mesh = SphereMesh.new()
# body
@onready var body = RigidBody3D.new()
@onready var body_collision = CollisionShape3D.new()
@onready var body_collision_shape = BoxShape3D.new()
@onready var body_mesh_instance = MeshInstance3D.new()
@onready var body_mesh = BoxMesh.new()
#endregion

func _ready():
	material.albedo_color = color
	
	head_collision.shape = head_collision_shape
	head.add_child(head_collision)
	head_mesh_instance.mesh = head_mesh
	head_mesh_instance.material_override = material
	head_mesh.radial_segments = 10
	head_mesh.rings = 5
	head_collision.add_child(head_mesh_instance)
	head.scale = Vector3(head_size + 1, head_size + 1, head_size + 1)
	head.add_child(head_body_joint)
	add_child(head)
	
	body_collision.shape = body_collision_shape
	body_collision_shape.size = Vector3(body_width, body_height, body_length)
	body.add_child(body_collision)
	body_mesh_instance.mesh = body_mesh
	body_mesh_instance.material_override = material
	body_mesh.size = Vector3(body_width, body_height, body_length)
	body_collision.add_child(body_mesh_instance)
	add_child(body)
	head.position = Vector3(0, 1.1, 1.3)
	head_body_joint.node_a = head.get_path()
	head_body_joint.node_b = body.get_path()
