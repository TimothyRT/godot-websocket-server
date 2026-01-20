extends Node
class_name FileWriter


var file: FileAccess


func _on_recording_started() -> void:
	file = FileAccess.open("user://save_%s.csv" % Datetime.now(true), FileAccess.WRITE)
	file.store_csv_line(PackedStringArray([
		"gyro_x",
		"gyro_y",
		"gyro_z",
		"accel_x",
		"accel_y",
		"accel_z",
		"mag_x",
		"mag_y",
		"mag_z",
		"ahrs_x",
		"ahrs_y",
		"ahrs_z",
		"ahrs_w",
		"datetime",
		"gesture"
	]))


func _on_recording_stopped() -> void:
	if file != null:
		file.close()


func write(... args: Array) -> void:
	if file != null:
		file.store_csv_line(PackedStringArray(args))


func _exit_tree() -> void:
	if file != null:
		file.close()
