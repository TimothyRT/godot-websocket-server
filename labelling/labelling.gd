extends Node2D


signal csv_opened(csv_row_count: int)
signal prev_button_pressed
signal next_button_pressed

var stored_dir: String
var csv_data: Dictionary
var csv_header: PackedStringArray
var csv_row_count := 0


func _ready() -> void:
	csv_opened.connect(_csv_opened)
	
	%CSVFolderButton.files_retrieved.connect(_on_files_retrieved)


func csv_to_dict(file_path: String) -> Dictionary:
	var file = FileAccess.open(file_path, FileAccess.READ)
	var dict = {}
	
	if file == null:
		printerr("Could not open file: %s" % FileAccess.get_open_error())
		return dict
	
	# Optional: read and discard the header line if your CSV has one
	if not file.eof_reached():
		csv_header = file.get_csv_line()
		print("CSV header: ", csv_header)
		
		for h in csv_header:
			dict[h] = []

	# Loop through the file line by line until the end is reached
	while not file.eof_reached():
		# Get the current line
		var line_data: PackedStringArray = file.get_csv_line()

		# Check if the line is not empty (sometimes an extra empty line is read at the end)
		if line_data.size() > 0:
			# Process the data (e.g., print it, store in a dictionary/array)
			print("Read line data: ", line_data)
			for i in range(len(line_data)):
				var val = line_data[i]
				if val.is_valid_float():
					dict[csv_header[i]].append(float(val))
				elif val != "":
					dict[csv_header[i]].append(val)

	file.close()
	return dict


func _on_files_retrieved(dir: String, _files: Array[Variant]) -> void:
	stored_dir = dir


func _on_csv_option_item_selected(index: int) -> void:
	var filename = %CSVOption.get_item_metadata(index)
	
	var dict = csv_to_dict(stored_dir + "/" + filename)
	if dict.size() > 0:
		csv_data = dict
		csv_row_count = csv_data[csv_header[0]].size()
		print("this: ", str(csv_data[csv_header[0]]))
		csv_opened.emit(csv_row_count)
		print("CSV successfully opened and read!")


func _csv_opened():
	pass
