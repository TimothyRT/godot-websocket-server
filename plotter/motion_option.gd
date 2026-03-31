extends OptionButton


var gestures := [
	"HIT",
	"IDLE",
	"SHAKE",
	"SWING_LEFT",
	"SWING_RIGHT",
	"TILT_UP",
	"TILT_DOWN",
	"ROLL",
	"STIR",
	"POUR"]


func _ready() -> void:
	for gesture_label in gestures:
		add_item(gesture_label)
		set_item_metadata(-1, gesture_label)
	select(0)
