extends Button


func _pressed() -> void:
	owner.prev_button_pressed.emit()
