extends Label


var peak_count := 0


func _ready() -> void:
	SignalBus.peak_detected.connect(_on_peak_detected)


func _on_peak_detected() -> void:
	peak_count += 1
	text = "Peak count: %d" % peak_count
