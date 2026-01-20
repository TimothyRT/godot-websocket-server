extends Button


signal files_retrieved(dir: String, files: Array[Variant])


func _get_csv_files(path: String) -> Array[Variant]:
	var csv_files = []
	
	# Check if the directory exists and open it
	if DirAccess.dir_exists_absolute(path):
		var dir = DirAccess.open(path)
		if dir:
			# Get all file names in the directory
			var all_files = dir.get_files()
			
			# Filter files that end with ".csv"
			for file_name in all_files:
				if file_name.get_extension().to_lower() == "csv" and file_name.begins_with("save"):
					csv_files.append(file_name)
		else:
			print("An error occurred when trying to access the path.")
	else:
		print("Path does not exist: ", path)
		
	return csv_files


func _pressed() -> void:
	var file_dialog = FileDialog.new()
	file_dialog.use_native_dialog = true
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	file_dialog.access = FileDialog.ACCESS_USERDATA
	file_dialog.filters = ["*.csv"]
	file_dialog.dir_selected.connect(_on_dir_selected)
	add_child(file_dialog)
	file_dialog.popup_centered()


func _on_dir_selected(dir: String) -> void:	
	var files: Array[Variant] = _get_csv_files(dir)
	files_retrieved.emit(dir, files)
