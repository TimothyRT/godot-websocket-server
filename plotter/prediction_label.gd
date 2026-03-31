extends Label


func _ready() -> void:
	SignalBus.classification_made.connect(_on_classification_made)
	
	
func _on_classification_made(_input_arr: Array, predicted_class: int) -> void:
	text = "Predicted class: %d (%s)" % [predicted_class, MotionRecognition.MOTION.keys()[predicted_class]]
