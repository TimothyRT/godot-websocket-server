extends Button
class_name StartRecordingButton


var controller: RecordingController


func _ready() -> void:
	pass
	
	
func setup(_controller: RecordingController) -> void:
	controller = _controller
	controller.connect("recording_started", _on_recording_started)
	controller.connect("recording_stopped", _on_recording_stopped)


func _on_recording_started() -> void:
	print("[Start] Recording started")


func _on_recording_stopped() -> void:
	print("[Start] Recording stopped")
