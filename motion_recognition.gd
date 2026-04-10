extends Node


const MIN_PEAK_THRESHOLD := 20.0

enum MOTION {
	HIT,
	SHAKE,
	SWING_LEFT,
	SWING_RIGHT,
	FAN
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
	
	# ignore small peaks
	if -MIN_PEAK_THRESHOLD < SensorDataStore.data_dict["acc_y"][offset_current] and SensorDataStore.data_dict["acc_y"][offset_current] < MIN_PEAK_THRESHOLD:
		return
	
	var is_negative_peak := false 
	if SensorDataStore.data_dict["acc_y"][offset_current] <= -MIN_PEAK_THRESHOLD:
		is_negative_peak = true
	
	# ignore un-peak-like points
	if not _is_peak(SensorDataStore.data_dict["acc_y"].slice(offset_begin, offset_end), is_negative_peak):
		return
	
	SignalBus.peak_detected.emit()
	
	var input_arr := []  # should be of length 6 * WINDOW_WIDTH normally
	for i in range(buffer_size - Config.WINDOW_WIDTH, buffer_size, 3):
		input_arr += SensorDataStore.data_dict["gyro_x"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["gyro_y"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["gyro_z"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_x"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_y"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_z"].slice(i, i + 3)
	var predicted_motion: int = Svc.classify(input_arr)
	
	if predicted_motion != -1:
		# ---- REMOVE LATER ----
		SensorDataStore.data_dict["mag_y"][offset_previous] = 31.0
		SensorDataStore.data_dict["mag_y"][offset_current] = 30.0
		SensorDataStore.data_dict["mag_y"][offset_next] = 29.0
		# ---- REMOVE LATER ----
		
		play_input_event(predicted_motion)
		SignalBus.classification_made.emit(input_arr, predicted_motion)
		
		if predicted_motion == MOTION.SHAKE:
			time_steps_to_ignore = 10
		else:
			time_steps_to_ignore = 12
		
		if last_predicted_motion == null or predicted_motion != last_predicted_motion:
			last_predicted_motion = predicted_motion


func play_input_event(i: int) -> void:
	match i:
		MOTION.HIT:
			%AudioHit.play()
			generate_input_event("motion_hit", 0.5)
		MOTION.SWING_LEFT:
			%AudioSwingLeft.play()
			generate_input_event("motion_swing_left", 0.5)
		MOTION.SWING_RIGHT:
			%AudioSwingRight.play()
			generate_input_event("motion_swing_right", 0.5)
		MOTION.SHAKE:
			%AudioShake.play()
			generate_input_event("motion_shake", 0.5)
		MOTION.FAN:
			%AudioTiltUp.play()
			generate_input_event("motion_fan", 0.5)
		#MOTION.TILT_DOWN:
			#%AudioTiltDown.play()


func generate_input_event(event_name: String, delay: float, player_index=0) -> void:
	var input_event = InputEventAction.new()
	if player_index == 0 or player_index == 1:
		input_event.strength = player_index
	else:
		print("player_index must either be 0 (for player #1) or 1 (for player #2).")
		return
	input_event.action = event_name
	input_event.pressed = true
	Input.parse_input_event(input_event)
	
	await get_tree().create_timer(delay).timeout
	input_event.pressed = false
	Input.parse_input_event(input_event)


#func _on_timer_timeout() -> void:
	#just_performed_big_action = false


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
