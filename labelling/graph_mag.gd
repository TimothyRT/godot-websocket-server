@tool
extends Graph2D
class_name GraphMag


var mag_x: PlotItem
var mag_y: PlotItem
var mag_z: PlotItem


func _on_labelling_csv_opened(csv_row_count: int) -> void:
	if csv_row_count >= Config.WINDOW_WIDTH:
		mag_x = add_plot_item("", Color.RED)
		mag_y = add_plot_item("", Color.GREEN)
		mag_z = add_plot_item("", Color.BLUE)
	else:
		remove_all()


func _on_index_edit_index_updated(index: int) -> void:
	if mag_x != null:
		remove_all()
		
		mag_x = add_plot_item("Magnetometer", Color.RED)
		mag_y = add_plot_item("", Color.GREEN)
		mag_z = add_plot_item("", Color.BLUE)
		
		var _x = 0
		for i in range(index - Config.WINDOW_WIDTH + 1, index + 1):
			mag_x.add_point(Vector2(float(_x), owner.csv_data["mag_x"][i]))
			mag_y.add_point(Vector2(float(_x), owner.csv_data["mag_y"][i]))
			mag_z.add_point(Vector2(float(_x), owner.csv_data["mag_z"][i]))
			_x += 1
