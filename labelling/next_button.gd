extends Button


func _pressed() -> void:
	owner.next_button_pressed.emit()
