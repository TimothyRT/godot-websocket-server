extends Node2D


func _process(_delta: float) -> void:
	%DrinkTextureLabel.text = "Beverage quality: %f" % [%Hand.drink_texture]
