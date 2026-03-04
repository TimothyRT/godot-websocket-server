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

var buffer_max_size := 100

var last_update_time := 0.0  # in seconds


func _ready() -> void:
	SignalBus.client_sensor_retrieved.connect(_on_client_sensor_retrieved)


func _on_client_sensor_retrieved(_data_dict: Dictionary) -> void:
	for key in _data_dict:
		data_dict[key].append(_data_dict[key])
	
	if len(data_dict["gesture"]) > buffer_max_size:
		var excess = len(data_dict["gesture"]) - buffer_max_size
	
		for k in data_dict:
			data_dict[k] = data_dict[k].slice(excess)
	
	SignalBus.client_sensor_stored.emit(1)
