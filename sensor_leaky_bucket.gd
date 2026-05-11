extends Node


var bucket: Dictionary[String, Array] = {
	"gyro_x": [],
	"gyro_y": [],
	"gyro_z": [],
	"acc_x": [],
	"acc_y": [],
	"acc_z": [],
	"gesture": []
}


func _ready() -> void:
	SignalBus.client_sensor_batch_received.connect(_on_client_sensor_batch_received)


func _physics_process(_delta: float) -> void:
	# congestion control; drop oldest frames from queue if needed
	if len(bucket["gesture"]) > 100:
		for key in bucket:
			bucket[key] = bucket[key].slice(int(0.2 * len(bucket[key])), len(bucket[key]))
	
	if len(bucket["gesture"]) > 0:
		var sensor_sample_dict: Dictionary
		for key in bucket:
			sensor_sample_dict[key] = bucket[key].pop_front()
		SignalBus.client_sensor_retrieved.emit(sensor_sample_dict)
	
	#print("TESTING: %d" % [len(bucket['gesture'])])


func _on_client_sensor_batch_received(data_dict: Dictionary) -> void:
	if not data_dict.has("gesture"):
		return
	for key in bucket:
		bucket[key].append_array(data_dict[key])
