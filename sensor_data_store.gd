extends Node


const SAMPLING_RATE := 0.06  # in seconds

var sensor_data = []
var temp_sensor_data = []

var last_update_time := 0.0  # in seconds


func _ready() -> void:
	SignalBus.client_sensor_retrieved.connect(_on_client_sensor_retrieved)
	
	for i in range(Config.MAX_PLAYERS):
		temp_sensor_data.append({
			"gyroscope": {
				"x": [],
				"y": [],
				"z": []
			},
			"accelerometer": {
				"x": [],
				"y": [],
				"z": []
			}
		})
	
	for i in range(Config.MAX_PLAYERS):
		sensor_data.append({
			"gyroscope": {
				"x": [],
				"y": [],
				"z": []
			},
			"accelerometer": {
				"x": [],
				"y": [],
				"z": []
			}
		})


func _process(delta: float) -> void:
	if last_update_time + delta < SAMPLING_RATE:
		last_update_time += delta
	
	else:  # more than SAMPLING_RATE seconds have passed
		for player_number in range(Config.MAX_PLAYERS):
			# plotting currently only works for player #1
			if player_number == 0:
				for sensor_type in ["gyroscope", "accelerometer"]:
					for axis in ["x", "y", "z"]:
						var average = _average(temp_sensor_data[player_number][sensor_type][axis])
						temp_sensor_data[player_number][sensor_type][axis] = []
						sensor_data[player_number][sensor_type][axis].append(average)
						
						if len(sensor_data[player_number][sensor_type][axis]) > 100:
							sensor_data[player_number][sensor_type][axis] = sensor_data[player_number][sensor_type][axis].slice(1, 100)
				
				SignalBus.emit_signal(
					"client_sensor_stored",
					player_number)
		
		last_update_time = delta - last_update_time


func _average(arr: Array) -> float:
	if len(arr) == 0:
		return 0.0
	else:
		var sum := 0.0
		for number in arr:
			sum += number
		return sum / len(arr)


func _on_client_sensor_retrieved(player_number: int, sensor_type: String, x: float, y: float, z: float) -> void:
	temp_sensor_data[player_number][sensor_type]["x"].append(x)
	temp_sensor_data[player_number][sensor_type]["y"].append(y)
	temp_sensor_data[player_number][sensor_type]["z"].append(z)


func retrieve_last(player_number: int, sensor_type: String) -> Vector3:
	return Vector3(
		sensor_data[player_number][sensor_type]["x"][-1],
		sensor_data[player_number][sensor_type]["y"][-1],
		sensor_data[player_number][sensor_type]["z"][-1]
	)
