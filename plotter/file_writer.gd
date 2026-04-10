extends Node
class_name FileWriter


var file: FileAccess


func _ready() -> void:
	SignalBus.classification_made.connect(_on_classification_made)


func _on_recording_started() -> void:
	file = FileAccess.open("user://save_v2_%s.csv" % Datetime.now(true), FileAccess.WRITE)
	var header_arr = PackedStringArray()
	for i in range(Config.WINDOW_WIDTH):
		for col in Config.csv_col_names_for_recognition:
			if col == "motion_type":
				continue
			header_arr.append(col + "_" + str(i))
	header_arr.append("motion_type")
	file.store_csv_line(header_arr)


func _on_recording_stopped() -> void:
	if file != null:
		file.close()


func _on_classification_made(_input_arr: Array, _predicted_class: int) -> void:
	print("[WORK] _on_classification_made")
	var arr_with_gesture: Array = _input_arr + [%MotionOption.get_item_text(%MotionOption.selected)]
	print("[WORK2] %s" % [len(arr_with_gesture)])
	write(arr_with_gesture)


func write(arr: Array) -> void:
	if file == null:
		return
	
	var expected_length := len(Config.csv_col_names_for_recognition) * Config.WINDOW_WIDTH + 1
	var arr_to_write := PackedStringArray(arr)
	if len(arr_to_write) != expected_length:
		print("Expected array of length %d instead of %d for CSV input" % [expected_length, len(arr_to_write)])
		return
	
	file.store_csv_line(PackedStringArray(arr_to_write))


func _exit_tree() -> void:
	if file != null:
		file.close()
