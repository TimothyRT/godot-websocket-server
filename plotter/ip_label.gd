extends Label


func _ready() -> void:
	text += str(IpAddress.ip)
