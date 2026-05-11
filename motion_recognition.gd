extends Node


const MIN_PEAK_THRESHOLD := 20.0
const MIN_GYRO_THRESHOLD := 150.0

enum MOTION {
	HIT,
	SHAKE,
	SWING_LEFT,
	SWING_RIGHT,
	FAN,
	IDLE,
	STIR,
	LIFT,
	SPIN,
	POUR,
}

var time_steps_to_ignore := 0

var last_predicted_motion: int


func _ready() -> void:
	SignalBus.client_sensor_stored.connect(_on_client_sensor_stored)


func _on_client_sensor_stored(_sample_count: int) -> void:
	if time_steps_to_ignore > 0:
		time_steps_to_ignore -= 1
		return

	var buffer_size := len(SensorDataStore.data_dict["gesture"])
	if buffer_size < Config.WINDOW_WIDTH:
		return

	var offset_begin := buffer_size - Config.WINDOW_WIDTH
	var offset_current: int = buffer_size - ceili(Config.WINDOW_WIDTH / 2.0)
	var offset_previous := offset_current - 1
	var offset_next := offset_current + 1
	var offset_end := buffer_size

	var acc_mag := _compute_acc_magnitude(offset_current)
	var gyro_mag := _compute_gyro_magnitude(offset_current)

	if acc_mag < MIN_PEAK_THRESHOLD and gyro_mag < MIN_GYRO_THRESHOLD:
		return

	var mag_window := _build_acc_magnitude_window(offset_begin, offset_end)
	if not _is_peak(mag_window, false):
		return

	SignalBus.peak_detected.emit()

	var input_arr := PackedFloat32Array()
	input_arr.append_array(SensorDataStore.data_dict["gyro_x"].slice(offset_begin, offset_end))
	input_arr.append_array(SensorDataStore.data_dict["gyro_y"].slice(offset_begin, offset_end))
	input_arr.append_array(SensorDataStore.data_dict["gyro_z"].slice(offset_begin, offset_end))
	input_arr.append_array(SensorDataStore.data_dict["acc_x"].slice(offset_begin, offset_end))
	input_arr.append_array(SensorDataStore.data_dict["acc_y"].slice(offset_begin, offset_end))
	input_arr.append_array(SensorDataStore.data_dict["acc_z"].slice(offset_begin, offset_end))
	
	print("Array Received: ", input_arr)

	# Debug size
	if input_arr.size() != 90:
		print("ERROR: Array size is ", input_arr.size(), " (Expected 90). Classifier will fail.")

	var predicted_motion: int = Svc.classify(input_arr)
	print("Prediction Guess: ", predicted_motion)

	if predicted_motion != -1:
		SignalBus.classification_made.emit(input_arr, predicted_motion)

		match predicted_motion:
			MOTION.HIT:
				time_steps_to_ignore = 12
				%AudioHit.play()
			MOTION.SHAKE:
				time_steps_to_ignore = 5
				%AudioShake.play()
			MOTION.SWING_LEFT:
				time_steps_to_ignore = 15
				%AudioSwingLeft.play()
			MOTION.SWING_RIGHT:
				time_steps_to_ignore = 15
				%AudioSwingRight.play()
			MOTION.FAN:
				time_steps_to_ignore = 12
				#%AudioFan.play()
			MOTION.STIR:
				time_steps_to_ignore = 20
				#%AudioStir.play()
			MOTION.SPIN:
				time_steps_to_ignore = 12
				#%AudioSpin.play()
			MOTION.LIFT:
				time_steps_to_ignore = 12
				#%AudioLift.play()
			MOTION.POUR:
				time_steps_to_ignore = 12
				#%AudioPour.play()

		if last_predicted_motion == null or predicted_motion != last_predicted_motion:
			last_predicted_motion = predicted_motion


func _compute_acc_magnitude(idx: int) -> float:
	var ax: float = SensorDataStore.data_dict["acc_x"][idx]
	var ay: float = SensorDataStore.data_dict["acc_y"][idx]
	var az: float = SensorDataStore.data_dict["acc_z"][idx]
	return sqrt(ax * ax + ay * ay + az * az)


func _compute_gyro_magnitude(idx: int) -> float:
	var gx: float = SensorDataStore.data_dict["gyro_x"][idx]
	var gy: float = SensorDataStore.data_dict["gyro_y"][idx]
	var gz: float = SensorDataStore.data_dict["gyro_z"][idx]
	return sqrt(gx * gx + gy * gy + gz * gz)


func _build_acc_magnitude_window(offset_begin: int, offset_end: int) -> Array[Variant]:
	var mag_window: Array[Variant] = []
	for i in range(offset_begin, offset_end):
		mag_window.append(_compute_acc_magnitude(i))
	return mag_window


func _is_peak(arr: Array[Variant], negativity: bool) -> bool:
	var offset_midpoint: int = ceili(len(arr) / 2.0)
	var val_midpoint = arr[offset_midpoint]

	for val in arr:
		if negativity:
			if val < val_midpoint:
				return false
		else:
			if val > val_midpoint:
				return false
	return true
