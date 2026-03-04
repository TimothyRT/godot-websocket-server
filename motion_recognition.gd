extends Node


const MIN_PEAK_THRESHOLD := 20.0

enum MOTION {
	HIT,
	IDLE,
	SHAKE,
	SWING_LEFT,
	SWING_RIGHT
}

var just_performed_big_action := false

var last_predicted_motion: int


func _ready() -> void:
	SignalBus.client_sensor_stored.connect(_on_client_sensor_stored)


func _on_client_sensor_stored(_sample_count: int) -> void:
	var buffer_size := len(SensorDataStore.data_dict["gesture"])
	if buffer_size < Config.WINDOW_WIDTH:
		return
	
	var offset_begin := buffer_size - Config.WINDOW_WIDTH
	var offset_current: int = buffer_size - ceili(Config.WINDOW_WIDTH / 2.0)
	var offset_previous := offset_current - 1
	var offset_next := offset_current + 1
	var offset_end := buffer_size
	
	# ignore un-peak-like points
	if not _is_peak(SensorDataStore.data_dict["acc_y"].slice(offset_begin, offset_end)):
		return
	
	# ignore lower peaks
	if SensorDataStore.data_dict["acc_y"][offset_current] < MIN_PEAK_THRESHOLD:
		return
	
	SignalBus.peak_detected.emit()
	
	var input_arr := []
	for i in range(buffer_size - Config.WINDOW_WIDTH, buffer_size, 3):
		input_arr += SensorDataStore.data_dict["gyro_x"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["gyro_y"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["gyro_z"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_x"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_y"].slice(i, i + 3)
		input_arr += SensorDataStore.data_dict["acc_z"].slice(i, i + 3)
	var predicted_motion: int = Svc.classify(input_arr)
	
	if predicted_motion != -1:
		if just_performed_big_action:
			return
		
		# ---- REMOVE LATER ----
		SensorDataStore.data_dict["mag_y"][offset_previous] = 31.0
		SensorDataStore.data_dict["mag_y"][offset_current] = 30.0
		SensorDataStore.data_dict["mag_y"][offset_next] = 29.0
		# ---- REMOVE LATER ----
		
		SignalBus.classification_made.emit(predicted_motion)
		if predicted_motion != MOTION.IDLE:
			play_input_event(predicted_motion)
			just_performed_big_action = true
			%Timer.start()
			
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
		
		#MOTION.TILT_UP:
			#%AudioTiltUp.play()
		#MOTION.TILT_DOWN:
			#%AudioTiltDown.play()


func generate_input_event(event_name: String, delay: float) -> void:
	var input_event = InputEventAction.new()
	input_event.action = event_name
	input_event.pressed = true
	Input.parse_input_event(input_event)
	
	await get_tree().create_timer(delay).timeout
	input_event.pressed = false
	Input.parse_input_event(input_event)


func _on_timer_timeout() -> void:
	just_performed_big_action = false


func _is_peak(arr: Array[Variant]) -> bool:
	var offset_midpoint: int = ceili(len(arr) / 2.0)
	var val_midpoint = arr[offset_midpoint]
	
	for val in arr:
		if val > val_midpoint:
			return false
	return true
