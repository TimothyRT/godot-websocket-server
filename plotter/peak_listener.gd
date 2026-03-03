extends Node


func _ready() -> void:
	SignalBus.avg_acc_y_changed.connect(_on_avg_acc_y_changed)


func _on_avg_acc_y_changed(val) -> void:
	#var truthiness = int(abs(SensorDataStore.data_dict["acc_y"][-2] - val) > abs(1.5 * val))
	var truthiness = int(SensorDataStore.data_dict["acc_y"][-2] > 20)
	#text = "Average acc_y: %f; current acc_y: %f; truthiness: %d" % [val, SensorDataStore.data_dict["acc_y"][-1], truthiness]
	if truthiness:
		#if SensorDataStore.data_dict["acc_y"][-2] >= SensorDataStore.data_dict["acc_y"][-1]:
			#if SensorDataStore.data_dict["acc_y"][-2] >= SensorDataStore.data_dict["acc_y"][-3]:
		SignalBus.peak_detected.emit()
