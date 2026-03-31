extends Node


const MAX_PLAYERS := 2
const WINDOW_WIDTH := 30

var csv_col_names := PackedStringArray([
	"gyro_x",
	"gyro_y",
	"gyro_z",
	"acc_x",
	"acc_y",
	"acc_z",
	"mag_x",
	"mag_y",
	"mag_z",
	"ahrs_x",
	"ahrs_y",
	"ahrs_z",
	"ahrs_w",
	"gesture"
])


var csv_col_names_for_recognition := PackedStringArray([
	"gyro_x",
	"gyro_y",
	"gyro_z",
	"acc_x",
	"acc_y",
	"acc_z",
])
