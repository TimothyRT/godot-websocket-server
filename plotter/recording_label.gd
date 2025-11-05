extends Label
class_name RecordingLabel


const active_msg := "Currently recording"
const passive_msg := "Recording stopped."

var is_recording := false
var ellipsis_length := 0


func _on_recording_started() -> void:
	text = active_msg
	$Timer.start()
	is_recording = true


func _on_recording_stopped() -> void:
	text = passive_msg
	$Timer.stop()
	is_recording = false


func _on_timer_timeout() -> void:
	if is_recording:
		text = active_msg
		for i in range(ellipsis_length):
			text += "."
		ellipsis_length = (ellipsis_length + 1) % 4
