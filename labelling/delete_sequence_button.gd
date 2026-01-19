extends Button


func _pressed() -> void:
	%AnnotationSaver.delete_last_annotation()
