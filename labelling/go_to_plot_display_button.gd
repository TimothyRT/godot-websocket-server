extends Button


func _pressed() -> void:
	var err = get_tree().change_scene_to_file("res://plotter/plot_display.tscn")
	if err != OK:
		print("An error occurred when attempting to switch context: ", err)
