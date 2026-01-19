extends Label


var ori_text = "Viewing: Point %d to %d (%d data points in this CSV file)"


func _ready() -> void:
	text = "No valid CSV has been opened."


func _on_index_edit_index_updated(index: int) -> void:
	text = ori_text % [index - Config.WINDOW_WIDTH + 1, index, owner.csv_row_count]
