extends Node


var plot = {
	"gyroscope": {
		"x": PlotItem,
		"y": PlotItem,
		"z": PlotItem
	},
	"accelerometer": {
		"x": PlotItem,
		"y": PlotItem,
		"z": PlotItem
	},
	"magnetometer": {
		"x": PlotItem,
		"y": PlotItem,
		"z": PlotItem
	},
	"ahrs": {
		"x": PlotItem,
		"y": PlotItem,
		"z": PlotItem,
		"w": PlotItem
	},
	"gesture": PlotItem
}

#var sensor_data = SensorDataStore.sensor_data


func _ready():
	_setup_plot()
	SignalBus.client_sensor_stored.connect(_on_client_sensor_stored)
	SignalBus.client_sensor_retrieved.connect(_on_client_sensor_retrieved)


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("motion_hit"):
		#print("[MOTION] Hit")
		#%AudioBanana.play()


func _setup_plot():
	%GraphGyro.remove_all()
	%GraphAcc.remove_all()
	%GraphMag.remove_all()
	%GraphAHRS.remove_all()
	%GraphGesture.remove_all()
	
	plot["gyroscope"]["x"] = %GraphGyro.add_plot_item("Gyroscope", Color.RED)
	plot["gyroscope"]["y"] = %GraphGyro.add_plot_item("", Color.GREEN)
	plot["gyroscope"]["z"] = %GraphGyro.add_plot_item("", Color.BLUE)
	plot["accelerometer"]["x"] = %GraphAcc.add_plot_item("Accelerometer", Color.RED)
	plot["accelerometer"]["y"] = %GraphAcc.add_plot_item("", Color.GREEN)
	plot["accelerometer"]["z"] = %GraphAcc.add_plot_item("", Color.BLUE)
	plot["magnetometer"]["x"] = %GraphMag.add_plot_item("Magnetometer", Color.RED)
	plot["magnetometer"]["y"] = %GraphMag.add_plot_item("", Color.GREEN)
	plot["magnetometer"]["z"] = %GraphMag.add_plot_item("", Color.BLUE)
	plot["ahrs"]["x"] = %GraphAHRS.add_plot_item("AHRS", Color.RED)
	plot["ahrs"]["y"] = %GraphAHRS.add_plot_item("", Color.GREEN)
	plot["ahrs"]["z"] = %GraphAHRS.add_plot_item("", Color.BLUE)
	plot["ahrs"]["w"] = %GraphAHRS.add_plot_item("", Color.WHITE)
	plot["gesture"] = %GraphGesture.add_plot_item("User gesture?", Color.RED)


func _on_client_sensor_stored(_sample_count: int) -> void:
	#print("stored: ", str(SensorDataStore.data_dict["gesture"]))
	plot["gyroscope"]["x"].remove_all()
	plot["gyroscope"]["y"].remove_all()
	plot["gyroscope"]["z"].remove_all()
	plot["accelerometer"]["x"].remove_all()
	plot["accelerometer"]["y"].remove_all()
	plot["accelerometer"]["z"].remove_all()
	plot["magnetometer"]["x"].remove_all()
	plot["magnetometer"]["y"].remove_all()
	plot["magnetometer"]["z"].remove_all()
	plot["ahrs"]["x"].remove_all()
	plot["ahrs"]["y"].remove_all()
	plot["ahrs"]["z"].remove_all()
	plot["ahrs"]["w"].remove_all()
	plot["gesture"].remove_all()
	
	for i in range(len(SensorDataStore.data_dict["gyro_x"])):
		plot["gyroscope"]["x"].add_point(Vector2(i, SensorDataStore.data_dict["gyro_x"][i]))
		plot["gyroscope"]["y"].add_point(Vector2(i, SensorDataStore.data_dict["gyro_y"][i]))
		plot["gyroscope"]["z"].add_point(Vector2(i, SensorDataStore.data_dict["gyro_z"][i]))
		plot["accelerometer"]["x"].add_point(Vector2(i, SensorDataStore.data_dict["acc_x"][i]))
		plot["accelerometer"]["y"].add_point(Vector2(i, SensorDataStore.data_dict["acc_y"][i]))
		plot["accelerometer"]["z"].add_point(Vector2(i, SensorDataStore.data_dict["acc_z"][i]))
		plot["magnetometer"]["x"].add_point(Vector2(i, SensorDataStore.data_dict["mag_x"][i]))
		plot["magnetometer"]["y"].add_point(Vector2(i, SensorDataStore.data_dict["mag_y"][i]))
		plot["magnetometer"]["z"].add_point(Vector2(i, SensorDataStore.data_dict["mag_z"][i]))
		plot["ahrs"]["x"].add_point(Vector2(i, SensorDataStore.data_dict["ahrs_x"][i]))
		plot["ahrs"]["y"].add_point(Vector2(i, SensorDataStore.data_dict["ahrs_y"][i]))
		plot["ahrs"]["z"].add_point(Vector2(i, SensorDataStore.data_dict["ahrs_z"][i]))
		plot["ahrs"]["w"].add_point(Vector2(i, SensorDataStore.data_dict["ahrs_w"][i]))
		plot["gesture"].add_point(Vector2(i, SensorDataStore.data_dict["gesture"][i]))


func _on_client_sensor_retrieved(data_dict: Dictionary) -> void:
	var batch_size := 10
	for i in range(batch_size):
		%FileWriter.write(
			str(data_dict["gyro_x"][i]),
			str(data_dict["gyro_y"][i]),
			str(data_dict["gyro_z"][i]),
			str(data_dict["acc_x"][i]),
			str(data_dict["acc_y"][i]),
			str(data_dict["acc_z"][i]),
			str(data_dict["mag_x"][i]),
			str(data_dict["mag_y"][i]),
			str(data_dict["mag_z"][i]),
			str(data_dict["ahrs_x"][i]),
			str(data_dict["ahrs_y"][i]),
			str(data_dict["ahrs_z"][i]),
			str(data_dict["ahrs_w"][i]),
			str(data_dict["datetime"][i]),
			str(data_dict["gesture"][i]),
		)
