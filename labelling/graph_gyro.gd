@tool
extends Graph2D
class_name GraphGyro


var gyro_x: PlotItem
var gyro_y: PlotItem
var gyro_z: PlotItem


func _on_labelling_csv_opened(csv_row_count: int) -> void:
	if csv_row_count >= Config.WINDOW_WIDTH:
		gyro_x = add_plot_item("Gyroscope", Color.RED)
		gyro_y = add_plot_item("", Color.GREEN)
		gyro_z = add_plot_item("", Color.BLUE)
	else:
		remove_all()


func _on_index_edit_index_updated(index: int) -> void:
	if gyro_x != null:
		remove_all()
		
		gyro_x = add_plot_item("", Color.RED)
		gyro_y = add_plot_item("", Color.GREEN)
		gyro_z = add_plot_item("", Color.BLUE)
		
		var _x = 0
		for i in range(index - Config.WINDOW_WIDTH + 1, index + 1):
			gyro_x.add_point(Vector2(float(_x), owner.csv_data["gyro_x"][i]))
			gyro_y.add_point(Vector2(float(_x), owner.csv_data["gyro_y"][i]))
			gyro_z.add_point(Vector2(float(_x), owner.csv_data["gyro_z"][i]))
			_x += 1
