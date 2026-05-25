extends Button


var label_prev := "Click to begin labeling data points"


func _pressed() -> void:
	var user_dir = ProjectSettings.globalize_path("user://")
	OS.shell_open(user_dir)
	
	#var err = get_tree().change_scene_to_file("res://labelling/labelling.tscn")
	#if err != OK:
		#print("An error occurred when attempting to switch context: ", err)
