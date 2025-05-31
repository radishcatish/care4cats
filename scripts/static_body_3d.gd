extends StaticBody3D


func _process(delta: float) -> void:
	if Input.is_action_pressed("decrease"):
		scale -= Vector3(0.05, 0, 0.05)
	if Input.is_action_pressed("increase"):
		scale += Vector3(0.05, 0, 0.05)
