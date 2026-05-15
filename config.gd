extends Node


const MAX_PLAYERS := 2
const WINDOW_WIDTH := 15

const RED := Color("ec5f44ff")
const BLUE := Color(0.132, 0.618, 0.88, 1.0)

var csv_col_names := PackedStringArray([
	"gyro_x",
	"gyro_y",
	"gyro_z",
	"acc_x",
	"acc_y",
	"acc_z",
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
