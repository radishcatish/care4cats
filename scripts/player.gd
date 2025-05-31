class_name Player extends RigidBody3D

var speed: float = 5 # m/s
var acceleration: float = 100 # m/s^2

var jump_height: float = 1 # m
var camera_sens: float = 5

var jumping: bool = false
var mouse_captured: bool = false

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

@onready var camera: Camera3D = $Camera
@onready var snd_run: AudioStreamPlayer = $Walking
@onready var snd_fly: AudioStreamPlayer = $Jetpack
@onready var crosshair: Label3D = $Camera/Label3D
@onready var snd_grab: AudioStreamPlayer = $Grab



func _ready() -> void:
	capture_mouse()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if mouse_captured: _rotate_camera()

const CAT = preload("res://scenes/cat_spawner.tscn")
const BALL = preload("res://scenes/ball.tscn")
var body : RigidBody3D
func _physics_process(delta: float) -> void:
	
	move_dir = Input.get_vector(&"left", &"right", &"up", &"down")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	
	
	if Input.is_action_pressed(&"jump"):
		linear_velocity.y += 4

	if Input.is_action_just_pressed("jump"):
		snd_fly.play()
	if Input.is_action_just_released("jump"):
		snd_fly.stop()
		
		
	linear_velocity += walk_vel / (float(Input.is_action_pressed("shift")) + 1)
	linear_velocity.x *= .8
	linear_velocity.z *= .8
	
	
	if Input.is_action_just_pressed("esc"):
		get_tree().quit(0)
		
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("spawncat"):
		var catscene = CAT.instantiate()
		catscene.global_position = global_position
		add_sibling(catscene)
		
	if Input.is_action_pressed("spawnball"):
		var ballscene = BALL.instantiate()
		add_sibling(ballscene)
		ballscene.global_position = global_position
		
	if Input.is_action_pressed("grab"):
		if not body:
			if $Camera/RayCast3D.get_collider() is RigidBody3D:
				snd_grab.play()
				body = $Camera/RayCast3D.get_collider()
				$Camera/Node3D.position.z = -3
			else: return
		var target_position = $Camera/Node3D.global_position
		var to_target = target_position - body.global_position
		var force = to_target * 1200 * body.mass
		body.apply_force(force, Vector3.ZERO)
		body.apply_force(-body.linear_velocity * 100 * body.mass, Vector3.ZERO)
		

	body = null if Input.is_action_just_released("grab") else body
		
	if Input.is_action_just_pressed("scrollup"):
		$Camera/Node3D.position.z -= 2
	if Input.is_action_just_pressed("scrolldown"):
		$Camera/Node3D.position.z += 2
		
	if Input.is_action_pressed("shift"):
		camera.position.y = lerpf(camera.position.y, 0, delta * 20)
		linear_velocity.y -= 4

	else:
		camera.position.y = lerpf(camera.position.y, 1.3, delta * 20)

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	mouse_captured = true

func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	mouse_captured = false

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)
