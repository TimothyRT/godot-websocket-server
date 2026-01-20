extends Node


const SAMPLING_RATE := 0.06  # in seconds

var data_dict = {
	"gyro_x": [],
	"gyro_y": [],
	"gyro_z": [],
	"acc_x": [],
	"acc_y": [],
	"acc_z": [],
	"mag_x": [],
	"mag_y": [],
	"mag_z": [],
	"ahrs_x": [],
	"ahrs_y": [],
	"ahrs_z": [],
	"ahrs_w": [],
	"datetime": [],
	"gesture": []
}

var last_update_time := 0.0  # in seconds


func _ready() -> void:
	SignalBus.client_sensor_retrieved.connect(_on_client_sensor_retrieved)


#func _process(delta: float) -> void:
	#if last_update_time + delta < SAMPLING_RATE:
		#last_update_time += delta
	#
	#else:  # more than SAMPLING_RATE seconds have passed
		#for player_number in range(Config.MAX_PLAYERS):
			## plotting currently only works for player #1
			#if player_number == 0:
				#for sensor_type in ["gyroscope", "accelerometer"]:
					#for axis in ["x", "y", "z"]:
						#var average = _average(temp_sensor_data[player_number][sensor_type][axis])
						#temp_sensor_data[player_number][sensor_type][axis] = []
						#sensor_data[player_number][sensor_type][axis].append(average)
						#
						#if len(sensor_data[player_number][sensor_type][axis]) > 100:
							#sensor_data[player_number][sensor_type][axis] = sensor_data[player_number][sensor_type][axis].slice(1, 100)
				#
				#SignalBus.emit_signal(
					#"client_sensor_stored",
					#player_number)
		#
		#last_update_time = delta - last_update_time


#func _average(arr: Array) -> float:
	#if len(arr) == 0:
		#return 0.0
	#else:
		#var sum := 0.0
		#for number in arr:
			#sum += number
		#return sum / len(arr)


func _on_client_sensor_retrieved(_data_dict: Dictionary) -> void:
	data_dict["gyro_x"].append_array(_data_dict["gyro_x"])
	data_dict["gyro_y"].append_array(_data_dict["gyro_y"])
	data_dict["gyro_z"].append_array(_data_dict["gyro_z"])
	data_dict["acc_x"].append_array(_data_dict["acc_x"])
	data_dict["acc_y"].append_array(_data_dict["acc_y"])
	data_dict["acc_z"].append_array(_data_dict["acc_z"])
	data_dict["mag_x"].append_array(_data_dict["mag_x"])
	data_dict["mag_y"].append_array(_data_dict["mag_y"])
	data_dict["mag_z"].append_array(_data_dict["mag_z"])
	data_dict["ahrs_x"].append_array(_data_dict["ahrs_x"])
	data_dict["ahrs_y"].append_array(_data_dict["ahrs_y"])
	data_dict["ahrs_z"].append_array(_data_dict["ahrs_z"])
	data_dict["ahrs_w"].append_array(_data_dict["ahrs_w"])
	data_dict["datetime"].append_array(_data_dict["datetime"])
	data_dict["gesture"].append_array(_data_dict["gesture"])
	
	if len(data_dict["gesture"]) > 100:
		data_dict["gyro_x"] = data_dict["gyro_x"].slice(10, -1)
		data_dict["gyro_y"] = data_dict["gyro_y"].slice(10, -1)
		data_dict["gyro_z"] = data_dict["gyro_z"].slice(10, -1)
		data_dict["acc_x"] = data_dict["acc_x"].slice(10, -1)
		data_dict["acc_y"] = data_dict["acc_y"].slice(10, -1)
		data_dict["acc_z"] = data_dict["acc_z"].slice(10, -1)
		data_dict["mag_x"] = data_dict["mag_x"].slice(10, -1)
		data_dict["mag_y"] = data_dict["mag_y"].slice(10, -1)
		data_dict["mag_z"] = data_dict["mag_z"].slice(10, -1)
		data_dict["ahrs_x"] = data_dict["ahrs_x"].slice(10, -1)
		data_dict["ahrs_y"] = data_dict["ahrs_y"].slice(10, -1)
		data_dict["ahrs_z"] = data_dict["ahrs_z"].slice(10, -1)
		data_dict["ahrs_w"] = data_dict["ahrs_w"].slice(10, -1)
		data_dict["datetime"] = data_dict["datetime"].slice(10, -1)
		data_dict["gesture"] = data_dict["gesture"].slice(10, -1)
	
	SignalBus.client_sensor_stored.emit(10)


#func retrieve_last(player_number: int, sensor_type: String) -> Vector3:
	#return Vector3(
		#sensor_data[player_number][sensor_type]["x"][-1],
		#sensor_data[player_number][sensor_type]["y"][-1],
		#sensor_data[player_number][sensor_type]["z"][-1]
	#)
