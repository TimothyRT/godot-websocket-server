extends Node
class_name RecordingController


signal recording_started
signal recording_stopped


var is_recording: bool


var start_recording_button: StartRecordingButton
var stop_recording_button: StopRecordingButton
var recording_label: RecordingLabel
var file_writer: FileWriter


func setup(
	_file_writer: FileWriter,
	_start_recording_button: StartRecordingButton,
	_stop_recording_button: StopRecordingButton,
	_recording_label: RecordingLabel
	) -> void:
	file_writer = _file_writer
	file_writer.setup(self)
	start_recording_button = _start_recording_button
	start_recording_button.setup(self)
	stop_recording_button = _stop_recording_button
	stop_recording_button.setup(self)
	recording_label = _recording_label
	recording_label.setup(self)
	
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
