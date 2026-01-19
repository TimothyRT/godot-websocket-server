extends Button


var file: FileAccess


func _pressed() -> void:
	if len(%AnnotationSaver.annotations) > 0:
		file = FileAccess.open("user://annotation_%s.csv" % Datetime.now(true), FileAccess.WRITE)
		
		var header_arr = PackedStringArray()
		for i in range(Config.WINDOW_WIDTH):
			header_arr.append("gyro_x_%d" % [i])
			header_arr.append("gyro_y_%d" % [i])
			header_arr.append("gyro_z_%d" % [i])
			header_arr.append("accel_x_%d" % [i])
			header_arr.append("accel_y_%d" % [i])
			header_arr.append("accel_z_%d" % [i])
		header_arr.append("motion_type")
		file.store_csv_line(header_arr)
		
		for annotation in %AnnotationSaver.annotations:
			file.store_csv_line(annotation)
		
		file.close()
		
		%AnnotationSaver.delete_all_annotations()
