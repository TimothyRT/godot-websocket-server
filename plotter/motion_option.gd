extends OptionButton


var gestures := [
	"HIT",
	"SHAKE",
	"SWING_LEFT",
	"SWING_RIGHT",
	"FAN"]


func _ready() -> void:
	for gesture_label in gestures:
		add_item(gesture_label)
		set_item_metadata(-1, gesture_label)
	select(0)
