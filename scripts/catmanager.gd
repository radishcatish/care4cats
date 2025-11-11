extends Node
const CAT = preload("res://scenes/cat.tscn")
func spawn_cat_from_data(data: Dictionary, count) -> Node3D:
	var cat = CAT.instantiate()
	cat.global_position.y = 5

	for key in ["voicepitch","catscale","leg_height","leg_thickness",
		"body_length","body_width","body_height","head_size",
		"tail_length","tail_thickness","tail_1_angle","tail_2_angle",
		"ear_width","ear_length","ear_angle","mouth_offset",
		"body_texture","leg_texture","tail2_texture","head_texture",
		"ear_texture","eyes_texture","mouth_texture","head_dark", "catname"]:
		if data.has(key):
			cat.set(key, data[key])
	
	cat.left_eye_offset  = Vector2(data["left_eye_offset_x"], data["left_eye_offset_y"])
	cat.right_eye_offset = Vector2(data["right_eye_offset_x"], data["right_eye_offset_y"])
	
	cat.catcolor      = Color(data["catcolor_r"], data["catcolor_g"], data["catcolor_b"])
	cat.catcolor_alt  = Color(data["catcolor_alt_r"], data["catcolor_alt_g"], data["catcolor_alt_b"])
	cat.catcolor_alt2 = Color(data["catcolor_alt2_r"], data["catcolor_alt2_g"], data["catcolor_alt2_b"])
	cat.facecolor     = Color(data["facecolor_r"], data["facecolor_g"], data["facecolor_b"])
	cat.mouthcolor    = Color(data["mouthcolor_r"], data["mouthcolor_g"], data["mouthcolor_b"])
	
	cat.premade = true
	cat.global_position = Vector3(count - 3, 5, 0)
	add_child(cat)
	
	return cat


func spawn_new_cat(count: int):
	var cat = CAT.instantiate()
	cat.global_position.y = 5
	cat.global_position = Vector3(randf() * 10, 11, randf() * 10)
	add_child(cat)
	return cat

var catcount = 0
func spawnpremade():
	var dir = DirAccess.open("user://")
	dir.list_dir_begin()
	var f = dir.get_next()
	while f != "":
		if not dir.current_is_dir() and f.ends_with(".bloccat"):
			var file = FileAccess.open("user://" + f, FileAccess.READ)
			var data = JSON.parse_string(file.get_as_text())
			file.close()
			catcount += 1
			spawn_cat_from_data(data, catcount)
		f = dir.get_next()
	dir.list_dir_end()
	
const BALL = preload("res://scenes/ball.tscn")
func spawn_balls(amt: int):
	for i in amt:
		await get_tree().create_timer(.001).timeout
		var ballscene = BALL.instantiate()
		add_child(ballscene)
		ballscene.global_position = Vector3(randi_range(-30, 30), randi_range(0, 30), randi_range(-30, 30))

var catamt = 50
func _ready():
	#spawnpremade()
	for i in catamt:
		spawn_new_cat(catamt)
		catcount += 1
