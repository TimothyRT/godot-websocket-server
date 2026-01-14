extends Node
class_name RecordingController


signal recording_started
signal recording_stopped
signal inference_threshold_reached
signal inference_threshold_negated

const INFERENCE_DELAY := 1.0  # in seconds

@export var window_width = 30

var is_recording: bool
var inference_threshold: bool

var last_inference_time := 0.0  # in seconds


func _ready() -> void:	
	inference_threshold = false
	inference_threshold_negated.emit()
	
	is_recording = false
	recording_stopped.emit()


func _process(delta: float) -> void:
	if last_inference_time + delta < INFERENCE_DELAY:
		last_inference_time += delta
		
	elif not inference_threshold:
		if (
			abs(
				SensorDataStore.retrieve(0, "accelerometer", -1)[0] - 
				SensorDataStore.retrieve(0, "accelerometer", -2)[0]
			) >= 3.0 or 
			abs(
				SensorDataStore.retrieve(0, "accelerometer", -1)[1] - 
				SensorDataStore.retrieve(0, "accelerometer", -2)[1]
			) >= 3.0 or 
			abs(
				SensorDataStore.retrieve(0, "accelerometer", -1)[2] - 
				SensorDataStore.retrieve(0, "accelerometer", -2)[2]
			) >= 3.0 or 
			abs(
				SensorDataStore.retrieve(0, "gyroscope", -1)[0] - 
				SensorDataStore.retrieve(0, "gyroscope", -2)[0]
			) >= 3.0 or 
			abs(
				SensorDataStore.retrieve(0, "gyroscope", -1)[1] - 
				SensorDataStore.retrieve(0, "gyroscope", -2)[1]
			) >= 3.0 or 
			abs(
				SensorDataStore.retrieve(0, "gyroscope", -1)[2] - 
				SensorDataStore.retrieve(0, "gyroscope", -2)[2]
			) >= 3.0
		):
			print("SO TRUE")
			inference_threshold = true
			inference_threshold_reached.emit()
			
			last_inference_time = delta - last_inference_time


func negate_inference_threshold() -> void:
	inference_threshold = false
	inference_threshold_negated.emit()


func _on_start_recording_button_down() -> void:
	if not is_recording:
		is_recording = true
		emit_signal("recording_started")


func _on_stop_recording_button_down() -> void:
	if is_recording:
		is_recording = false
		emit_signal("recording_stopped")
