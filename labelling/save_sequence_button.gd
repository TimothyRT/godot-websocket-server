extends Button


func _pressed() -> void:
	if %MotionTypeEdit.selected != -1:
		if %IndexEdit.text.is_valid_int():
			var index = int(%IndexEdit.text)
			var arr = PackedStringArray()
			for i in range(index - Config.WINDOW_WIDTH + 1, index + 1):
				arr.append(str(owner.csv_data["gyro_x"][i]))
				arr.append(str(owner.csv_data["gyro_y"][i]))
				arr.append(str(owner.csv_data["gyro_z"][i]))
				arr.append(str(owner.csv_data["accel_x"][i]))
				arr.append(str(owner.csv_data["accel_y"][i]))
				arr.append(str(owner.csv_data["accel_z"][i]))
			arr.append(%MotionTypeEdit.get_item_text(%MotionTypeEdit.selected))
	
			%AnnotationSaver.add_annotation(arr)
