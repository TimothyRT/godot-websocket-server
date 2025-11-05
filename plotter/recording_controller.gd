extends Node
class_name RecordingController


signal recording_started
signal recording_stopped

var is_recording: bool


func _ready() -> void:	
	is_recording = false
	emit_signal("recording_stopped")


func _on_start_recording_button_down() -> void:
	if not is_recording:
		is_recording = true
		emit_signal("recording_started")


func _on_stop_recording_button_down() -> void:
	if is_recording:
		is_recording = false
		emit_signal("recording_stopped")
