extends Label
class_name AnnotationsList


@export var ori_text = "Labeled sequences:"


func _on_annotation_saver_annotations_updated() -> void:
	text = ori_text
	for annotation in %AnnotationSaver.annotations:
		text += "\n"
		text += ",".join(annotation)
