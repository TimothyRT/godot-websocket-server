extends Label


var theme_green = preload("res://plotter/text_green.tres")
var theme_red = preload("res://plotter/text_red.tres")


func _ready() -> void:
	%RecordingController.inference_threshold_reached.connect(_on_inference_threshold_reached)
	%RecordingController.inference_threshold_negated.connect(_on_inference_threshold_negated)
	
	#_on_inference_threshold_negated()


func _on_inference_threshold_reached():
	text = ":D Inference mode is active."
	theme = theme_green


func _on_inference_threshold_negated():
	text = ":( Inference mode is inactive."
	theme = theme_red
