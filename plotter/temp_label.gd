extends Label


var peak_count := 0
var counter := {
	"hit": 0,
	"swing_left": 0,
	"swing_right": 0,
	"shake": 0
}


func _ready() -> void:
	SignalBus.classification_made.connect(_on_classification_made)
	SignalBus.peak_detected.connect(_on_peak_detected)


func _on_peak_detected() -> void:
	peak_count += 1
	redraw_text()


func _on_classification_made(_input_arr: Array, predicted_class: int) -> void:
	match predicted_class:
		MotionRecognition.MOTION.HIT:
			counter["hit"] += 1
		MotionRecognition.MOTION.SWING_LEFT:
			counter["swing_left"] += 1
		MotionRecognition.MOTION.SWING_RIGHT:
			counter["swing_right"] += 1
		MotionRecognition.MOTION.SHAKE:
			counter["shake"] += 1
		_:
			pass
	redraw_text()


func redraw_text() -> void:
	var values: Array[int] = [peak_count, counter["hit"], counter["swing_left"], counter["swing_right"], counter["shake"]]
	text = "Peaks detected: %d; hits: %d; swing_lefts: %d; swing_rights: %d; shakes: %d" % values
