extends Button
class_name StopRecordingButton


func _on_recording_started() -> void:
	visible = true


func _on_recording_stopped() -> void:
	visible = false
