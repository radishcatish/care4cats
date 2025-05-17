extends Skeleton3D
#region nodes
@onready var head: RigidBody3D = $Head
@onready var head_mesh: MeshInstance3D = $Head/Collision/Head
@onready var right_ear: RigidBody3D = $RightEar
@onready var right_ear_collision: CollisionShape3D = $RightEar/CollisionShape3D
@onready var right_ear_mesh: MeshInstance3D = $RightEar/CollisionShape3D/RightEar
@onready var left_ear: RigidBody3D = $LeftEar
@onready var left_ear_collision: CollisionShape3D = $LeftEar/CollisionShape3D
@onready var left_ear_mesh: MeshInstance3D = $LeftEar/CollisionShape3D/LeftEar

@onready var body: RigidBody3D = $Body
@onready var body_joint: ConeTwistJoint3D = $Body/BodyHeadJoint
@onready var body_collision: CollisionShape3D = $Body/Collision
@onready var body_mesh: MeshInstance3D = $Body/Collision/MeshInstance3D

@onready var tail_1: RigidBody3D = $Tail1
@onready var tail_1_joint: Generic6DOFJoint3D = $Tail1/Generic6DOFJoint3D
@onready var tail_1_collision: CollisionShape3D = $Tail1/CollisionShape3D
@onready var tail_1_mesh: MeshInstance3D = $Tail1/CollisionShape3D/MeshInstance3D
@onready var tail_2: RigidBody3D = $Tail2
@onready var tail_2_joint: Generic6DOFJoint3D = $Tail2/Generic6DOFJoint3D
@onready var tail_2_collision: CollisionShape3D = $Tail2/CollisionShape3D
@onready var tail_2_mesh: MeshInstance3D = $Tail2/CollisionShape3D/MeshInstance3D

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

@onready var thingtolookat_head
@onready var thingtolookat_body
@onready var nodestolookat: Array
@onready var nodestochase: Array
@onready var meow_cooldown: Timer = $MeowCooldown
@onready var decision_cooldown: Timer = $DecisionCooldown
@onready var meows: Node3D = $Head/Meows
@onready var face: AnimatedSprite3D = $Head/Collision/Sprite3D
@onready var name_text: Label3D = $Head/Collision/Label3D
@onready var id_text: Label3D = $Head/Collision/Label3D2

#endregion

var catname                := ""
@onready var voicepitch    : float = 1
@onready var hyperactivity : float = 1
@onready var limbdamping   : float = .5
@onready var limbspeed     : float = 20
@onready var walkspeed     : float = 0.1
var make_decision          : bool  = true

func _ready() -> void:
	
	left_front_joint.node_a = left_front.get_path()
	left_front_joint.node_b = body.get_path()
	
	right_front_joint.node_a = right_front.get_path()
	right_front_joint.node_b = body.get_path()
	
	left_back_joint.node_a = left_back.get_path()
	left_back_joint.node_b = body.get_path()
	
	right_back_joint.node_a = right_back.get_path()
	right_back_joint.node_b = body.get_path()
	
	
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
		if randi_range(0, 500 / hyperactivity) == 0:
			var soundtoplay = randi_range(0,meows.get_child_count() - 1)
			meows.get_child(soundtoplay).pitch_scale = voicepitch
			meows.get_child(soundtoplay).play()
			meow_cooldown.start(randf_range(0, .8))
			face.play("default")
			face.frame = 0
			head.apply_force(Vector3(0, 100, 0))
