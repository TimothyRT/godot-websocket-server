extends OptionButton


func _ready() -> void:
	%CSVFolderButton.files_retrieved.connect(_on_files_retrieved)


func _on_files_retrieved(_dir: String, files: Array[Variant]) -> void:
	for file in files:
		add_item(file)
		set_item_metadata(-1, file)
	select(-1)
