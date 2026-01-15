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
	}
}

var sensor_data = SensorDataStore.sensor_data


func _ready():
	_setup_plot()
	SignalBus.connect("client_sensor_stored", _on_client_sensor_stored)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("motion_hit"):
		print("[MOTION] Hit")
		%AudioBanana.play()


func _setup_plot():
	%GraphGyro.remove_all()
	%GraphAcc.remove_all()
	
	plot["gyroscope"]["x"] = %GraphGyro.add_plot_item("Gyroscope", Color.RED)
	plot["gyroscope"]["y"] = %GraphGyro.add_plot_item("", Color.GREEN)
	plot["gyroscope"]["z"] = %GraphGyro.add_plot_item("", Color.BLUE)
	plot["accelerometer"]["x"] = %GraphAcc.add_plot_item("Accelerometer", Color.RED)
	plot["accelerometer"]["y"] = %GraphAcc.add_plot_item("", Color.GREEN)
	plot["accelerometer"]["z"] = %GraphAcc.add_plot_item("", Color.BLUE)


func _on_client_sensor_stored(player_number: int) -> void:
	plot["gyroscope"]["x"].remove_all()
	plot["gyroscope"]["y"].remove_all()
	plot["gyroscope"]["z"].remove_all()
	for i in range(len(sensor_data[player_number]["gyroscope"]["x"])):
		plot["gyroscope"]["x"].add_point(Vector2(i, sensor_data[player_number]["gyroscope"]["x"][i]))
		plot["gyroscope"]["y"].add_point(Vector2(i, sensor_data[player_number]["gyroscope"]["y"][i]))
		plot["gyroscope"]["z"].add_point(Vector2(i, sensor_data[player_number]["gyroscope"]["z"][i]))
	
	plot["accelerometer"]["x"].remove_all()
	plot["accelerometer"]["y"].remove_all()
	plot["accelerometer"]["z"].remove_all()
	for i in range(len(sensor_data[player_number]["accelerometer"]["x"])):
		plot["accelerometer"]["x"].add_point(Vector2(i, sensor_data[player_number]["accelerometer"]["x"][i]))
		plot["accelerometer"]["y"].add_point(Vector2(i, sensor_data[player_number]["accelerometer"]["y"][i]))
		plot["accelerometer"]["z"].add_point(Vector2(i, sensor_data[player_number]["accelerometer"]["z"][i]))
	
	%FileWriter.write(
		str(sensor_data[player_number]["gyroscope"]["x"][-1]),
		str(sensor_data[player_number]["gyroscope"]["y"][-1]),
		str(sensor_data[player_number]["gyroscope"]["z"][-1]),
		str(sensor_data[player_number]["accelerometer"]["x"][-1]),
		str(sensor_data[player_number]["accelerometer"]["y"][-1]),
		str(sensor_data[player_number]["accelerometer"]["z"][-1]),
		Datetime.now(true)
	)
