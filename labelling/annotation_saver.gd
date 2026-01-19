extends VBoxContainer


signal annotations_updated

var annotations := []


func add_annotation(arr: PackedStringArray):
	annotations.append(arr)
	annotations_updated.emit()


func delete_all_annotations():
	annotations.clear()
	annotations_updated.emit()


func delete_last_annotation():
	annotations.remove_at(-1)
	annotations_updated.emit()
