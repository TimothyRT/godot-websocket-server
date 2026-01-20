@tool
extends Graph2D
class_name GraphGesture


var gesture: PlotItem


func _on_labelling_csv_opened(csv_row_count: int) -> void:
	if csv_row_count >= Config.WINDOW_WIDTH:
		gesture = add_plot_item("", Color.RED)
	else:
		remove_all()


func _str_to_float(_input: String) -> float:
	if _input == "true":
		return 1.0
	return 0.0


func _on_index_edit_index_updated(index: int) -> void:
	if gesture != null:
		remove_all()
		
		gesture = add_plot_item("", Color.RED)
		
		var _x = 0
		for i in range(index - Config.WINDOW_WIDTH + 1, index + 1):
			gesture.add_point(Vector2(float(_x), _str_to_float(owner.csv_data["gesture"][i])))
			_x += 1
