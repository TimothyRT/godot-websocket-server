extends Label


var ori_text = "Index of data point to examine: \n(valid: %d-%d) [inclusive]"


func _on_labelling_csv_opened(csv_row_count: int) -> void:
	if csv_row_count >= Config.WINDOW_WIDTH:
		text = ori_text % [(Config.WINDOW_WIDTH - 1), (csv_row_count - 1)]
	else:
		text = "Not enough data points in this CSV file! \n(%d samples at least needed)" % Config.WINDOW_WIDTH
