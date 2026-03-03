extends Node

signal client_sensor_retrieved(data_dict: Dictionary)
signal client_sensor_stored(sample_count: int)

signal classification_made(predicted_class: int)

signal avg_acc_y_changed(val: float)
signal peak_detected
