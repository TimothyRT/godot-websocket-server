@tool
extends Graph2D
class_name GraphAccel


var accel_x: PlotItem
var accel_y: PlotItem
var accel_z: PlotItem


func _on_labelling_csv_opened(csv_row_count: int) -> void:
	if csv_row_count >= Config.WINDOW_WIDTH:
		accel_x = add_plot_item("Accelerometer", Color.RED)
		accel_y = add_plot_item("", Color.GREEN)
		accel_z = add_plot_item("", Color.BLUE)
	else:
		remove_all()


func _on_index_edit_index_updated(index: int) -> void:
	if accel_x != null:
		
		remove_all()
		
		accel_x = add_plot_item("", Color.RED)
		accel_y = add_plot_item("", Color.GREEN)
		accel_z = add_plot_item("", Color.BLUE)
		
		var _x = 0
		for i in range(index - Config.WINDOW_WIDTH + 1, index + 1):
			accel_x.add_point(Vector2(float(_x), owner.csv_data["accel_x"][i]))
			accel_y.add_point(Vector2(float(_x), owner.csv_data["accel_y"][i]))
			accel_z.add_point(Vector2(float(_x), owner.csv_data["accel_z"][i]))
			_x += 1
