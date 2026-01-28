extends LineEdit


signal index_updated(index: int)

@export var step := 10


func _on_labelling_csv_opened(csv_row_count: int) -> void:
	if csv_row_count >= Config.WINDOW_WIDTH:
		visible = true
		text = str(Config.WINDOW_WIDTH - 1)
		text_changed.emit(text)
	else:
		visible = false
		text = ""


func _on_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		var new_index = int(new_text)
		if new_index >= (Config.WINDOW_WIDTH - 1) and new_index <= (owner.csv_row_count - 1):
			index_updated.emit(int(new_text))


func _on_labelling_next_button_pressed() -> void:
	if text.is_valid_int():
		text = str(min(int(text) + step, (owner.csv_row_count - 1)))
		text_changed.emit(text)


func _on_labelling_prev_button_pressed() -> void:
	if text.is_valid_int():
		text = str(max(int(text) - step, (Config.WINDOW_WIDTH - 1)))
		text_changed.emit(text)
