extends Node2D


var hit_count := 0
var timeout := false


func _ready() -> void:
	SignalBus.client_sensor_retrieved.connect(_on_client_sensor_retrieved)


func _on_client_sensor_retrieved(data_dict: Dictionary):
	if timeout:
		return
	
	var data_length := len(SensorDataStore.data_dict["acc_y"])
	if data_length < 100:
		return
	
	for i in range(70, 100):
		if SensorDataStore.data_dict["acc_y"][i] > 40:
			for j in range(i + 1, 100):
				if SensorDataStore.data_dict["acc_y"][j] < 0:
					hit_count += 1
					%Label.text = "Hits: %d" % hit_count
					timeout = true
					%Timer.start()
					%AudioStreamPlayer2D.play()
					return


func _on_timer_timeout() -> void:
	timeout = false
