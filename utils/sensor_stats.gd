extends Node


var sum_buffer = {
	"gyro_x": 0.0,
	"gyro_y": 0.0,
	"gyro_z": 0.0,
	"acc_x": 0.0,
	"acc_y": 0.0,
	"acc_z": 0.0,
	"mag_x": 0.0,
	"mag_y": 0.0,
	"mag_z": 0.0
}

var sum_buffer_size = {
	"gyro_x": 0,
	"gyro_y": 0,
	"gyro_z": 0,
	"acc_x": 0,
	"acc_y": 0,
	"acc_z": 0,
	"mag_x": 0,
	"mag_y": 0,
	"mag_z": 0
}


func _ready() -> void:
	SignalBus.client_sensor_stored.connect(_on_client_sensor_stored)


func _on_client_sensor_stored(sample_count: int) -> void:	
	var main_buffer_size := len(SensorDataStore.data_dict["gyro_x"])
	for i in range(main_buffer_size - sample_count, main_buffer_size):
		for key in sum_buffer:
			if sum_buffer_size[key] < SensorDataStore.buffer_max_size:
				sum_buffer_size[key] += 1
			else:
				sum_buffer[key] -= SensorDataStore.data_dict[key][i % sample_count]
			sum_buffer[key] += SensorDataStore.data_dict[key][i]
	
	#print("sum_buffer: ", str(sum_buffer))
	#print("sum_buffer_size: ", str(sum_buffer_size))
	
	var avg_acc_y: float = sum_buffer["acc_y"] / sum_buffer_size["acc_y"]
	SignalBus.avg_acc_y_changed.emit(avg_acc_y)
	print("average acc_y: %f" % avg_acc_y)
