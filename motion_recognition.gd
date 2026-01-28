extends Node


var leaky_bucket := {
	"gyro_x": [],
	"gyro_y": [],
	"gyro_z": [],
	"acc_x": [],
	"acc_y": [],
	"acc_z": []
}


enum MOTION {
	HIT,
	IDLE,
	SHAKE,
	SWING_LEFT,
	SWING_RIGHT
}

var just_performed_big_action := false

var predicted_motion: int
var predicted_motion_count := 0
var predicted_motion_threshold := 2


func _ready() -> void:
	SignalBus.client_sensor_retrieved.connect(_on_client_sensor_retrieved)


func _physics_process(_delta: float) -> void:
	if len(leaky_bucket["gyro_x"]) < Config.WINDOW_WIDTH:
		return
		
	var input_arr = []
	for i in range(0, 30, 3):
		input_arr += leaky_bucket["gyro_x"].slice(i, i + 3)
		input_arr += leaky_bucket["gyro_y"].slice(i, i + 3)
		input_arr += leaky_bucket["gyro_z"].slice(i, i + 3)
		input_arr += leaky_bucket["acc_x"].slice(i, i + 3)
		input_arr += leaky_bucket["acc_y"].slice(i, i + 3)
		input_arr += leaky_bucket["acc_z"].slice(i, i + 3)
	var res: int = Svc.classify(input_arr)
	
	if res != -1:
		if just_performed_big_action:
			pass
		elif predicted_motion == null or res != predicted_motion:
			predicted_motion = res
			predicted_motion_count = 1
		else:
			predicted_motion_count += 1
			
			if predicted_motion_count >= predicted_motion_threshold:
				predicted_motion_count = 0
				SignalBus.classification_made.emit(res)
				if res != 1:
					play_audio(res)
					just_performed_big_action = true
					%Timer.start()
		
		#if not just_performed_big_action and res != MOTION.IDLE:
			#SignalBus.classification_made.emit(res)
			#just_performed_big_action = true
			#%Timer.start()
		#elif not just_performed_big_action and res == MOTION.IDLE:
			#SignalBus.classification_made.emit(res)
	
	for key in leaky_bucket:
		leaky_bucket[key].pop_front()


func play_audio(i: int) -> void:
	match i:
		MOTION.HIT:
			%AudioHit.play()
		MOTION.SWING_LEFT:
			%AudioSwingLeft.play()
		MOTION.SWING_RIGHT:
			%AudioSwingRight.play()
		MOTION.SHAKE:
			%AudioShake.play()
			
		#MOTION.TILT_UP:
			#%AudioTiltUp.play()
		#MOTION.TILT_DOWN:
			#%AudioTiltDown.play()


func _on_client_sensor_retrieved(_data_dict: Dictionary) -> void:
	for key in leaky_bucket:
		leaky_bucket[key].append_array(_data_dict[key])


#func recognize_motion(motion: Motion, gyroscope: Vector3, accelerometer: Vector3) -> bool:
	#match motion:
		#Motion.HIT:
			#if accelerometer.y < -17:
				#var cancel_event = InputEventAction.new()
				#cancel_event.action = "motion_hit"
				#cancel_event.pressed = true
				#Input.parse_input_event(cancel_event)
				#
				#await get_tree().create_timer(0.5).timeout
				#cancel_event.pressed = false
				#Input.parse_input_event(cancel_event)
				#return true
			#else:
				#return false
		#
		#_:
			#return false


#func _on_client_sensor_stored(player_number: int) -> void:
	#var gyroscope: Vector3 = SensorDataStore.retrieve_last(player_number, "gyroscope")
	#var accelerometer: Vector3 = SensorDataStore.retrieve_last(player_number, "accelerometer")
	#recognize_motion(Motion.HIT, gyroscope, accelerometer)


func _on_timer_timeout() -> void:
	just_performed_big_action = false
