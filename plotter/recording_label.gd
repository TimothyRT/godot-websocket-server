extends Label
class_name RecordingLabel


var controller: RecordingController
var is_recording := false

var original_text := "Currently recording"
var ellipsis_length := 0


func _ready() -> void:
	pass
	
	
func setup(_controller: RecordingController) -> void:
	controller = _controller
	controller.connect("recording_started", _on_recording_started)
	controller.connect("recording_stopped", _on_recording_stopped)


func _on_recording_started() -> void:
	text = original_text
	$Timer.start()
	is_recording = true


func _on_recording_stopped() -> void:
	text = "Recording stopped."
	$Timer.stop()
	is_recording = false


func _on_timer_timeout() -> void:
	#print('timeout')
	if is_recording:
		text = original_text
		for i in range(ellipsis_length):
			text += "."
		ellipsis_length = (ellipsis_length + 1) % 4
