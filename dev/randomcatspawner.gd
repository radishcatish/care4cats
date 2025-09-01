extends Node
const CAT = preload("res://scenes/cat.tscn")
const BALL = preload("res://scenes/ball.tscn")
func _ready():

	print("spawning cats")
	for i in 50:
		await get_tree().create_timer(.05).timeout
		var catscene = CAT.instantiate()
		add_child(catscene)
		catscene.global_position = Vector3(randi_range(-20, 20), 0, randi_range(-20, 20))
	print("done spawning cats")
	
	await get_tree().create_timer(.5).timeout
	print("spawning balls now")
	for i in 70:

		var ballscene = BALL.instantiate()
		add_child(ballscene)
		ballscene.global_position = Vector3(randi_range(-20, 20), 0, randi_range(-20, 20))
	print("done spawning balls")
