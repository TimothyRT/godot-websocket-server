extends Node2D


func _process(_delta: float) -> void:
	if Input.is_action_pressed("motion_shake"):
		print("timun")
