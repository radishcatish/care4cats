extends Node
#const CAT = preload("res://scenes/cat.tscn")
#const BALL = preload("res://scenes/ball.tscn")
#func _ready():
	#return
	#print("spawning cats")
	#for i in 50:
		#await get_tree().create_timer(.05).timeout
		#var catscene = CAT.instantiate()
		#add_child(catscene)
		#catscene.global_position = Vector3(randi_range(-30, 30), randi_range(0, 30), randi_range(-30, 30))
	#print("done spawning cats")
	#
	#await get_tree().create_timer(.5).timeout
	#print("spawning balls now")
	#for i in 500:
		#await get_tree().create_timer(.001).timeout
		#var ballscene = BALL.instantiate()
		#add_child(ballscene)
		#ballscene.global_position = Vector3(randi_range(-30, 30), randi_range(0, 30), randi_range(-30, 30))
	#print("done spawning balls")
