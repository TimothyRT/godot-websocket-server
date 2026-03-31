extends Button


func _pressed() -> void:
	var err = get_tree().change_scene_to_file("res://labelling/labelling.tscn")
	if err != OK:
		print("An error occurred when attempting to switch context: ", err)
