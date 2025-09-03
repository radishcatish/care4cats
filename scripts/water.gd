extends MeshInstance3D

var startingy = position.y
var timeelapsed = 0
func _process(_delta: float) -> void:
	timeelapsed += 0.01
	position.y = startingy + (sin(timeelapsed) / 2)
