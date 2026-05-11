extends ONNXLoader
class_name SVC

func _ready() -> void:
	load_model("onnx/v4/clf_svm_ori.onnx")

func classify(input_arr: Array) -> int:
	if len(input_arr) < 90:
		return -1
	var output_arr = predict(input_arr)
	if len(output_arr) > 0:
		return output_arr[0]
	return -1 
