extends Node
class_name FileWriter


var file: FileAccess
var next_csv_line_array := PackedStringArray()

@onready var window_width: int = %RecordingController.window_width


func _ready() -> void:
	SignalBus.client_sensor_stored.connect(_on_client_sensor_stored)


func _on_client_sensor_stored(player_number: int) -> void:
	var sensor_dims = 3 + 3  # gyro + accel
		
	if %RecordingController.inference_threshold and player_number == 0:
		if len(next_csv_line_array) < sensor_dims * window_width:
			if file != null:
				next_csv_line_array.append(str(SensorDataStore.retrieve_last(player_number, "gyroscope")[0]))
				next_csv_line_array.append(str(SensorDataStore.retrieve_last(player_number, "gyroscope")[1]))
				next_csv_line_array.append(str(SensorDataStore.retrieve_last(player_number, "gyroscope")[2]))
				next_csv_line_array.append(str(SensorDataStore.retrieve_last(player_number, "accelerometer")[0]))
				next_csv_line_array.append(str(SensorDataStore.retrieve_last(player_number, "accelerometer")[1]))
				next_csv_line_array.append(str(SensorDataStore.retrieve_last(player_number, "accelerometer")[2]))
		
		if len(next_csv_line_array) == sensor_dims * window_width:
			if file != null:
				next_csv_line_array.append(Datetime.now(true))
				next_csv_line_array.append("unlabeled")
				file.store_csv_line(next_csv_line_array)
				next_csv_line_array.clear()
				
			%RecordingController.negate_inference_threshold()
			
	if file == null:
		%RecordingController.negate_inference_threshold()


func _on_recording_started() -> void:
	file = FileAccess.open("user://save_%s.csv" % Datetime.now(true), FileAccess.WRITE)
	
	var first_csv_line_array = PackedStringArray()
	
	for i in range(window_width):
		first_csv_line_array.append("gyro_x_" + str(i))
		first_csv_line_array.append("gyro_y_" + str(i))
		first_csv_line_array.append("gyro_z_" + str(i))
		first_csv_line_array.append("accel_x_" + str(i))
		first_csv_line_array.append("accel_y_" + str(i))
		first_csv_line_array.append("accel_z_" + str(i))
	first_csv_line_array.append("datetime")
	first_csv_line_array.append("label")
	
	file.store_csv_line(first_csv_line_array)


func _on_recording_stopped() -> void:
	if file != null:
		file.close()


func write(... args: Array) -> void:
	if file != null:
		file.store_csv_line(PackedStringArray(args))


func _exit_tree() -> void:
	if file != null:
		file.close()
