extends Label


func _ready() -> void:
	text += IpAddress.ip + "   (Application version " + ProjectSettings.get_setting("application/config/version") + ")"
