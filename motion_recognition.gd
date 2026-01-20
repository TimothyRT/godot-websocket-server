extends Node


enum Motion {HIT}


#func _ready() -> void:
	#SignalBus.client_sensor_stored.connect(_on_client_sensor_stored)


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
