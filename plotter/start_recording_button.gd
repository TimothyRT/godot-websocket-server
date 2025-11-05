extends Button
class_name StartRecordingButton


func _on_recording_started() -> void:
	visible = false


func _on_recording_stopped() -> void:
	visible = true
